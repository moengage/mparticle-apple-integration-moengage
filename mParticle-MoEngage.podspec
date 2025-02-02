require 'json'
require 'ostruct'

Pod::Spec.new do |s|
    s.name             = 'mParticle-MoEngage'
    s.version          = '1.0.0'
    s.summary          = 'MoEngageSDK integration for mParticle'

    s.description      = <<-DESC
                       This is the MoEngageSDK integration for mParticle.
                       DESC

    s.homepage          = 'https://www.moengage.com'
    s.documentation_url = 'https://developers.moengage.com'
    s.license           = { :type => 'Commercial', :file => 'LICENSE' }
    s.author            = { 'MobileDev' => 'mobiledevs@moengage.com' }
    s.social_media_url  = 'https://twitter.com/moengage'
    s.source            = {
      :git => 'https://github.com/moengage/mparticle-apple-integration-moengage.git',
      :tag => s.version.to_s
    }

    s.swift_version          = '5.3'
    s.ios.deployment_target  = '11.0'
    s.tvos.deployment_target = '11.0'

    config = JSON.parse(File.read('package.json'), {object_class: OpenStruct})
    s.source_files = 'Sources/mParticle-MoEngage/**/*.swift', 'Sources/mParticle-MoEngageObjC/**/*.{h,m}'
    s.project_header_files = 'Sources/mParticle-MoEngageObjC/**/*.h'
    s.dependency 'mParticle-Apple-SDK', "~> #{config.mParticleVersion}"
    s.dependency 'MoEngage-iOS-SDK', ">= #{config.sdkVerMin}", "<#{config.sdkVerMax}"

    s.test_spec 'Tests' do |ts|
      ts.source_files = "Tests/mParticle-MoEngageTests/**/*.{swift,h,m}"
      ts.dependency 'mParticle-Apple-SDK'
      ts.dependency 'MoEngage-iOS-SDK'
      ts.scheme = { :code_coverage => true }
    end
end
