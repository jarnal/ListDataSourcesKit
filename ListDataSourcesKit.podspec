Pod::Spec.new do |s|
  s.name         = "ListDataSourcesKit"
  s.version      = "0.1"
  s.summary      = "Framework allowing to remove data source boilerplate for UITableView and UICollectionView. "
  s.description  = <<-DESC
    Framework allowing to remove data source boilerplate for UITableView and UICollectionView. 
  DESC
  s.homepage     = "https://github.com/jarnal/ListDataSourcesKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Jonathan Arnal" => "jonathan.arnal89@gmail.com" }
  s.social_media_url   = ""
  s.ios.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/jarnal/ListDataSourcesKit.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
