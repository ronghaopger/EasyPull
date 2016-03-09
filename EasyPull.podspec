Pod::Spec.new do |s|
  s.name = "EasyPull"
  s.version = "1.0.3"
  s.summary = "Let pull-to-refresh Easy for any UIScrollView in Swift"
  s.homepage = "https://github.com/ronghaopger/EasyPull"
  s.license = "MIT"
  s.authors = { 'RongHao' => 'ronghao_1989@hotmail.com'}
  s.platform = :ios, "8.0"
  s.source = { :git => "https://github.com/ronghaopger/EasyPull.git", :tag => s.version }
  s.source_files = 'EasyPull/EasyPull/*.swift'
  s.resource     = 'EasyPull/EasyPull/Resource/*.png'
  s.requires_arc = true
end
