Pod::Spec.new do |s|
  s.name     = 'TomboAFNetworking'
  s.version  = '2.5.4'
  s.license  = 'MIT'
  s.summary  = 'A delightful iOS and OS X networking framework.'
  s.homepage = 'https://github.com/TomboAFNetworking/TomboAFNetworking'
  s.social_media_url = 'https://twitter.com/TomboAFNetworking'
  s.authors  = { 'Mattt Thompson' => 'm@mattt.me' }
  s.source   = { :git => 'https://github.com/TomboAFNetworking/TomboAFNetworking.git', :tag => s.version, :submodules => true }
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.public_header_files = 'TomboAFNetworking/*.h'
  s.source_files = 'TomboAFNetworking/TomboAFNetworking.h'

  s.subspec 'Serialization' do |ss|
    ss.source_files = 'TomboAFNetworking/TomboAFURL{Request,Response}Serialization.{h,m}'
    ss.ios.frameworks = 'MobileCoreServices', 'CoreGraphics'
    ss.osx.frameworks = 'CoreServices'
  end

  s.subspec 'Security' do |ss|
    ss.source_files = 'TomboAFNetworking/TomboAFSecurityPolicy.{h,m}'
    ss.frameworks = 'Security'
  end

  s.subspec 'Reachability' do |ss|
    ss.source_files = 'TomboAFNetworking/TomboAFNetworkReachabilityManager.{h,m}'
    ss.frameworks = 'SystemConfiguration'
  end

  s.subspec 'NSURLConnection' do |ss|
    ss.dependency 'TomboAFNetworking/Serialization'
    ss.dependency 'TomboAFNetworking/Reachability'
    ss.dependency 'TomboAFNetworking/Security'

    ss.source_files = 'TomboAFNetworking/TomboAFURLConnectionOperation.{h,m}', 'TomboAFNetworking/TomboAFHTTPRequestOperation.{h,m}', 'TomboAFNetworking/TomboAFHTTPRequestOperationManager.{h,m}'
  end

  s.subspec 'NSURLSession' do |ss|
    ss.dependency 'TomboAFNetworking/Serialization'
    ss.dependency 'TomboAFNetworking/Reachability'
    ss.dependency 'TomboAFNetworking/Security'

    ss.source_files = 'TomboAFNetworking/TomboAFURLSessionManager.{h,m}', 'TomboAFNetworking/TomboAFHTTPSessionManager.{h,m}'
  end

  s.subspec 'UIKit' do |ss|
    ss.ios.deployment_target = '6.0'

    ss.dependency 'TomboAFNetworking/NSURLConnection'
    ss.dependency 'TomboAFNetworking/NSURLSession'

    ss.ios.public_header_files = 'UIKit+TomboAFNetworking/*.h'
    ss.ios.source_files = 'UIKit+TomboAFNetworking'
    ss.osx.source_files = ''
  end
end
