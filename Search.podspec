

  Pod::Spec.new do |s|
  s.name = "Search"
  s.summary = '斗鱼搜索模块'
  s.version = '0.0.1'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.authors = { 'yangshangda' => '372154465@qq.com' }
  s.homepage = 'https://github.com/dearmiku/MN_Live'
  s.source = { :git => '', :tag => s.version.to_s }

  s.resource  = "Search/Search/Search.bundle"

  s.source_files   = "source", "Search/Search/source/**/*.*"

  s.swift_version = '4.2' 

  s.ios.deployment_target = "8.0"

  s.frameworks = 'Foundation', 'UIKit'

  s.dependency 'RxSwift', '~> 4.3.1'            #响应式框架
  s.dependency 'RxCocoa', '~> 4.3.1'            #响应式框架
  s.dependency 'SnapKit', '~> 4.0.0'            #布局框架
  s.dependency 'Moya', '~> 11.0.0'              #网络封装
  s.dependency 'Moya/RxSwift', '~> 11.0'        #网络封装响应扩展
  s.dependency 'Kingfisher', '~> 4.6.1'         #图片下载管理
  s.dependency 'HandyJSON'                      #ORM框架
  s.dependency 'SwiftSoup'                      #HTML解析框架

  s.dependency 'Base'                           #基础
  s.dependency 'LivingRoom'                     #直播间

  end
  

