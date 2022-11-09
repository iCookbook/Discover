Pod::Spec.new do |s|
  s.name             = 'Discover'
  s.version          = '0.2.5'
  s.summary          = '\'Discover\' module.'
  s.homepage         = 'https://github.com/iCookbook/Discover'
  s.author           = { 'htmlprogrammist' => '60363270+htmlprogrammist@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/iCookbook/Discover.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.source_files = 'Discover/**/*.{swift}'
  
  s.dependency 'CommonUI'
  s.dependency 'Resources'
  s.dependency 'Networking'
  s.dependency 'Models'
  s.dependency 'RecipeDetails'
end
