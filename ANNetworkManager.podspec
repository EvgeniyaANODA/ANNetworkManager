Pod::Spec.new do |spec|
  spec.name     = 'ANNetworkManager'
  spec.version  = '1.0'
  spec.license  = { :type => 'MIT' }
  spec.homepage = 'https://github.com/anodamobi/ANNetworkManager'
  spec.authors  = { 'Oksana Kovalchuk' => 'oksana@anoda.mobi' }
  spec.summary  = 'Reactive NSURLSession'
  spec.source   = { :git => 'https://github.com/anodamobi/ANNetworkManager.git', :tag => '1.0' }

  spec.source_files =  "ANNetworkManager/ActivityManager/*.{h,m}", "ANNetworkManager/Error/*.{h,m}", "ANNetworkManager/Request/*.{h,m}", "ANNetworkManager/SessionManager/*.{h,m}"

  spec.public_header_files = "ANNetworkManager/ActivityManager/*.h", "ANNetworkManager/Error/*.h", "ANNetworkManager/Request/*.h", "ANNetworkManager/SessionManager/*.h"

  spec.framework = "Foundation", "UIKit"
  spec.requires_arc = true

  spec.dependency 'ReactiveCocoa'
end