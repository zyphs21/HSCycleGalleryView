Pod::Spec.new do |s|
  s.name              = "HSCycleGalleryView"
  s.version           = "1.0.3"
  s.summary           = "A simple carousel view using UICollectionView."
  s.homepage          = "https://github.com/zyphs21/HSCycleGalleryView"
  s.license           = { :type => "MIT", :file => "LICENSE" }
  s.author            = { "zyphs21" => "hansenhs21@live.com" }
  s.platform          = :ios, "8.0"
  s.source            = { :git => "https://github.com/zyphs21/HSCycleGalleryView.git", :tag => s.version.to_s }
  s.source_files      = "Source/*.swift"
end