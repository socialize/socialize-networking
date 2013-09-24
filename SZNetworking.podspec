Pod::Spec.new do |s|
  s.name         = "SZNetworking"
  s.version      = "0.0.1"
  s.summary      = "Podspec for Socialize Networking project"
  s.homepage     = "https://github.com/socialize/socialize-networkingblob/dev/SZNetworking.podspec"
  s.author       = { "David Jedeikin" => "djedeikin@sharethis.com" }
  s.source       = { :git => "https://github.com/socialize/socialize-networking.git", :commit => 'b77e7a66a4bd9a0973bc74ef0c742e32159655a8' }
  s.platform     = :ios
  s.source_files = 'SZNetworking', 'SZNetworking/*.{h,m}'
end