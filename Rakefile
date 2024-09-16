require 'fileutils'
require 'optparse'
require 'json'

EXAMPLES = 'Examples'
WORKSPACE = File.join(EXAMPLES, 'MoEngage.xcworkspace')
LOCK = File.join(EXAMPLES, 'Podfile.lock')
TUIST = File.join(`brew --prefix`.strip, 'bin', 'tuist')

file TUIST do
  system('brew install tuist', out: STDOUT, exception: true)
end

directory WORKSPACE
file WORKSPACE => TUIST do
  Dir.chdir(EXAMPLES) do
    system('tuist generate --no-open', out: STDOUT, exception: true)
  end
end

file LOCK => [WORKSPACE] do
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
