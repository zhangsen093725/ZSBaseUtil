#
# Be sure to run `pod lib lint ZSBaseUtil.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'ZSBaseUtil'
    s.version          = '0.6.2'
    s.summary          = '基础扩展库'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    项目基础库
    DESC
    
    s.homepage         = 'https://github.com/zhangsen093725/ZSBaseUtil'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'zhangsen093725' => '376019018@qq.com' }
    s.source           = { :git => 'https://github.com/zhangsen093725/ZSBaseUtil.git', :tag => s.version.to_s }
    s.swift_version    = '5.0'
    
    s.default_subspecs = 'All'
    
    s.subspec 'All' do |a|
        a.source_files = 'ZSBaseUtil/Classes/**/*'
    end
    
    s.subspec 'Codable' do |c|
        c.source_files = 'ZSBaseUtil/Classes/Codable/**/*'
    end

    s.subspec 'Crypto' do |cc|
        cc.source_files = 'ZSBaseUtil/Classes/Crypto/**/*'
    end

    s.subspec 'Default' do |d|
        d.source_files = 'ZSBaseUtil/Classes/Default/**/*'
    end

    s.subspec 'Timer' do |t|
        t.source_files = 'ZSBaseUtil/Classes/Timer/**/*'
    end

    s.subspec 'File' do |ff|
        ff.source_files = 'ZSBaseUtil/Classes/File/**/*'
    end

    s.subspec 'Image' do |i|
        i.source_files = 'ZSBaseUtil/Classes/Image/**/*'
    end

    s.subspec 'Notice' do |n|
        n.source_files = 'ZSBaseUtil/Classes/Notice/**/*'
    end

    s.subspec 'TimeStamp' do |ts|
        ts.source_files = 'ZSBaseUtil/Classes/TimeStamp/**/*'
    end
    
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '8.0'
    
    # s.resource_bundles = {
    #   'ZSBaseUtil' => ['ZSBaseUtil/Assets/*.png']
    # }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking'
end
