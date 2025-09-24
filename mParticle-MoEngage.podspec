require 'json'
require 'ostruct'

Pod::Spec.new do |s|
    config = JSON.parse(File.read('package.json'), {object_class: OpenStruct})
    s.name             = 'mParticle-MoEngage'
    s.version          = config.packages.first().version
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
    s.ios.deployment_target  = '13.0'
    s.tvos.deployment_target = '13.0'

    s.source_files = 'Sources/mParticle-MoEngage/**/*.swift', 'Sources/mParticle-MoEngageObjC/**/*.{h,m}'
    s.project_header_files = 'Sources/mParticle-MoEngageObjC/**/*.h'
    recommendation = Pod::Version.new(config.mParticleVersion).approximate_recommendation
    s.dependency 'mParticle-Apple-SDK', "#{recommendation}"
    s.default_subspec = 'KMMedCore'
  
    s.subspec 'Core' do |ss|
      ss.dependency 'MoEngage-iOS-SDK/Core', ">= #{config.sdkVerMin}", "<#{config.sdkVerMax}"
    end

    s.subspec 'KMMedCore' do |ss|
      ss.dependency 'mParticle-MoEngage/Core'
      ss.dependency 'MoEngage-iOS-SDK/KMMedCore'
    end

    s.test_spec 'Tests' do |ts|
      ts.source_files = "Tests/mParticle-MoEngageTests/**/*.{swift,h,m}"
      ts.dependency 'mParticle-Apple-SDK'
      ts.scheme = { :code_coverage => true }
    end
end
