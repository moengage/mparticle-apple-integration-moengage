require 'fileutils'
require 'json'
require 'ostruct'

def get_devices
  # get device to test
  devices = JSON.parse(`xcrun simctl list --json devices available`.strip!)['devices'].flat_map do |runtime, devices|
    devices.map do |device|
      device['runtime'] = runtime
      device
    end
  end

  ios_device = devices.find do |device|
    device['runtime'].include?('iOS')
  end
  tvos_device = devices.find do |device|
    device['runtime'].include?('tvOS')
  end

  return ios_device, tvos_device
end

# Run SPM linting verifying build and Unit tests for each framework.
def run_spm_tests
  ios_device, tvos_device = get_devices

  xcodebuild = "xcodebuild clean build test -configuration Debug "
  ios_command = "#{xcodebuild} -scheme \"mParticle-MoEngage\" -destination 'id=#{ios_device['udid']}'"
  tvos_command = "#{xcodebuild} -scheme \"mParticle-MoEngage\" -destination 'id=#{tvos_device['udid']}'"

  # build and test
  puts "::group::Checking for iOS"
  derived_data = File.expand_path('~/Library/Developer/Xcode/DerivedData')
  FileUtils.rm_rf(derived_data) if File.directory?(derived_data)
  system(ios_command, out: STDOUT, exception: true)
  puts "::endgroup::"
  puts "::group::Checking for tvOS"
  FileUtils.rm_rf(derived_data) if File.directory?(derived_data)
  system(tvos_command, out: STDOUT, exception: true)
  puts "::endgroup::"
end

# Run CocoaPods linting verifying build and Unit tests for each framework.
def run_pods_tests
  ios_device, tvos_device = get_devices

  xcodebuild = "xcodebuild clean build test -configuration Debug -workspace \"Examples/MoEngagemParticle.xcworkspace\" "
  ios_command = "#{xcodebuild} -scheme \"mParticle-MoEngage-iOS\" -destination 'id=#{ios_device['udid']}' CODE_SIGN_IDENTITY=-"
  tvos_command = "#{xcodebuild} -scheme \"mParticle-MoEngage-tvOS\" -destination 'id=#{tvos_device['udid']}' CODE_SIGN_IDENTITY=-"

  # build and test
  puts "::group::Checking for iOS"
  derived_data = File.expand_path('~/Library/Developer/Xcode/DerivedData')
  FileUtils.rm_rf(derived_data) if File.directory?(derived_data)
  system(ios_command, out: STDOUT, exception: true)
  puts "::endgroup::"
  puts "::group::Checking for tvOS"
  FileUtils.rm_rf(derived_data) if File.directory?(derived_data)
  system(tvos_command, out: STDOUT, exception: true)
  puts "::endgroup::"
end
