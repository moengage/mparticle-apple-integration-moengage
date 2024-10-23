require 'fileutils'
require 'optparse'
require 'json'
require 'ostruct'

config = JSON.parse(File.read('package.json'), {object_class: OpenStruct})

EXAMPLES = 'Examples'
LOCK = File.join(EXAMPLES, 'Podfile.lock')
TUIST = File.join(`brew --prefix`.strip, 'bin', 'tuist')

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
    system('pod install', out: STDOUT, exception: true)
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
    system('pod install', out: STDOUT, exception: true)
  end
end

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
