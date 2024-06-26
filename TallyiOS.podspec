#
# Be sure to run `pod lib lint TallyiOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TallyiOS'
  s.version          = '1.0.3'
  s.summary          = 'A drop in library to accept payment with GetTally on iOS'
  s.description      = 'A drop in library to accept payment with GetTally on iOS. This is the easiest way to start collecting payments on your mobile apps.'

  s.homepage         = 'https://github.com/netplusTeam/GETTALLYSDK-IOS'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Promise Ochornma' => 'ochornmapromise@gmail.com' }
  s.source           = { :git => 'https://github.com/netplusTeam/GETTALLYSDK-IOS.git', :tag => s.version.to_s }


  s.ios.deployment_target = '13.0'
  s.swift_versions = '5.0'

  s.source_files = 'TallyiOS/Classes/**/*'
  
   #s.resource_bundles = {
   #  'TallyiOS' => ['TallyiOS/Assets/*.png', 'TallyiOS/Assets/**/*.{xcassets,json,imageset,png}' 'TallyiOS/Classes/**/*.{storyboard,xib}']
  # }
   s.resources = "TallyiOS/Assets/*.{png,jpeg,jpg,storyboard,xib,xcassets,json}"
  # s.resources = {
   #  'TallyiOS' => ['TallyiOS/Assets/*.png', 'TallyiOS/Assets/**/*.{xcassets,json,imageset,png}' 'TallyiOS/Classes/**/*.{storyboard,xib}']
 #  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Valet', '~> 4.3.0'
end
