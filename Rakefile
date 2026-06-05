require 'fileutils'
require 'optparse'
require 'json'
require 'ostruct'

config = JSON.parse(File.read('package.json'), {object_class: OpenStruct})

EXAMPLES = 'Examples'
LOCK = File.join(EXAMPLES, 'Podfile.lock')
TUIST = File.join(`brew --prefix`.strip, 'bin', 'tuist')

# Retries `pod install --repo-update` on CocoaPods CDN propagation lag —
# observed when chained partner releases run before the freshly-pushed
# native pod is visible in the CDN index. Only retries on spec-resolution
# failures; any other failure bubbles up immediately.
def pod_install_with_retry(max_attempts: 5, initial_delay: 30)
  attempt = 0
  delay = initial_delay
  loop do
    attempt += 1
    output = +''
    IO.popen('pod install --repo-update 2>&1', 'r') do |io|
      io.each_line do |line|
        print line
        output << line
      end
    end
    status = $?
    return if status.success?

    cdn_lag = output.include?('could not find compatible versions')
    if cdn_lag && attempt < max_attempts
      puts "[Rakefile] pod install failed — likely CocoaPods CDN propagation lag (attempt #{attempt}/#{max_attempts}). Retrying in #{delay}s..."
      sleep delay
      delay = [delay * 2, 480].min
    else
      raise "pod install --repo-update failed (exit #{status.exitstatus})"
    end
  end
end

file TUIST do
  system('brew install tuist', out: STDOUT, exception: true)
end

directory config.xcframework.workspace
file config.xcframework.workspace => TUIST do
  Dir.chdir(EXAMPLES) do
    system('tuist generate --no-open', out: STDOUT, exception: true)
  end
end

file LOCK => [config.xcframework.workspace] do
  Dir.chdir(EXAMPLES) do
    pod_install_with_retry
  end
end

desc <<~DESC
  Setup project for running
  Usage:
   [MO_MP_DEV_REPO=<repo> MO_MP_DEV_BRANCH=<branch>] rake setup
   MO_MP_DEV_REPO, MO_MP_DEV_BRANCH environment variables are optional.
   Set these variable to use a development repo and branch for MoEngage SDK.
DESC
task :setup => [TUIST] do |t|
  Dir.chdir(EXAMPLES) do
    pod_lock_file = 'Podfile.lock'
    FileUtils.rm(pod_lock_file) if File.exist?(pod_lock_file)
    system('tuist generate --no-open', out: STDOUT, exception: true)
    pod_install_with_retry
  end
end

# @todo: does not work anymore, need to handle require_relative in downloaded script
desc <<~DESC
  Build XCFramework zips
  pass environment variables:
    GITHUB_TOKEN: The token for GitHub authentication
    MO_CERTIFICATE_IDENTITY: The certificate identity for signing xcframeworks.
DESC
task :xcframework => [config.xcframework.workspace] do |t, args|
  require 'net/http'
  xcframework_script = URI('https://raw.githubusercontent.com/moengage/sdk-automation-scripts/refs/heads/master/scripts/release/ios/xcframework.rb')
  req = Net::HTTP::Get.new(xcframework_script.request_uri)
  req['Authorization'] = "Bearer #{ENV['GITHUB_TOKEN']}"
  http = Net::HTTP.new(xcframework_script.host, xcframework_script.port)
  http.use_ssl = true
  res = http.request(req)
  eval(res.body)
end

namespace 'test' do
  require_relative 'Utilities/test'
  desc 'Run SPM tests'
  task :spm do |t, args|
    run_spm_tests
  end
  desc 'Run CocoaPods tests'
  task :pods do |t, args|
    run_pods_tests
  end
end
