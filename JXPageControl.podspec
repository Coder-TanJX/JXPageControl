#
# Be sure to run `pod lib lint JXPageControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JXPageControl'
  s.version          = '0.1.0'
  s.summary          = 'A short description of JXPageControl.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/bboyXFX/JXPageControl'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bboyXFX' => 'jaixiang.tan@net263.com' }
  s.source           = { :git => 'https://github.com/bboyXFX/JXPageControl.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JXPageControl/Classes/**/*'
  
  s.subspec 'Common' do |ss|
      ss.source_files = 'JXPageControl/Classes/Common/**/*'
      ss.public_header_files = 'JXPageControl/Classes/Common/**/*.h'
  end
  
  s.subspec 'Jump' do |ss|
      ss.source_files = 'JXPageControl/Classes/Jump/**/*'
      ss.public_header_files = 'JXPageControl/Classes/Jump/**/*.h'
      ss.dependency 'JXPageControl/Common'
  end
  
  s.subspec 'Transform' do |ss|
      ss.source_files = 'JXPageControl/Classes/Transform/**/*'
      ss.public_header_files = 'JXPageControl/Classes/Transform/**/*.h'
      ss.dependency 'JXPageControl/Common'
  end
  

end
