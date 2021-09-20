#
# Be sure to run `pod lib lint JXPageControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JXPageControl'
  s.version          = '0.1.5'
  s.summary          = 'Custom UIPageControl: supports multiple animations, layouts'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Custom UIPageControl: a most complete PageControl framework that supports multiple animations and layouts.'

  s.homepage         = 'https://github.com/Code-TanJX'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Code-TanJX' => 'Code_TanJX@163.com' }
  s.source           = { :git => 'https://github.com/Code-TanJX/JXPageControl.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  
  
  if s.respond_to? 'swift_version'
      s.swift_version = "5.0"
  end
  
  if s.respond_to? 'swift_versions'
      s.swift_versions = ['4.0', '4.2', '5.0']
  end  
  
  s.subspec 'Common' do |ss|
      ss.source_files = 'JXPageControl/Classes/Common/**/*'
  end
  
  s.subspec 'Jump' do |ss|
      ss.source_files = 'JXPageControl/Classes/Jump/**/*'
      ss.dependency 'JXPageControl/Common'
  end
  
  s.subspec 'Transform' do |ss|
      ss.source_files = 'JXPageControl/Classes/Transform/**/*'
      ss.dependency 'JXPageControl/Common'
  end
  

end
