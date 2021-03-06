
Pod::Spec.new do |s|

  s.name         = "TRMemoryWave"
  s.version      = "0.1.4"
  s.ios.deployment_target = "8.0"
  s.summary      = "小清新能量球,帮助猿们检测pfs/内存占用/内存空闲,帮助你升华你的代码,优化项目利器.^_^"
  s.homepage     = "https://github.com/junqingwuchu/TRMemoryWave"
  s.license      = "MIT"
  s.requires_arc = true
  s.author             = { "Tracky" => "302855862@qq.com" }
  s.social_media_url   = "https://github.com/junqingwuchu"

  s.source       = { :git => 'https://github.com/junqingwuchu/TRMemoryWave.git', :tag => "v#{s.version}"}
  s.source_files = 'TRFPS/*.{h,m}'

end
