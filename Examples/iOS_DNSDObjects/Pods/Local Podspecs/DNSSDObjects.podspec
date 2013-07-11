Pod::Spec.new do |s|
  s.name         = "DNSSDObjects"
  s.version      = "0.0.1"
  s.summary      = "Objective-C library to use Bonjour services."
  s.homepage     = "https://github.com/HBehrens/DNSSDObjects"
  s.license      = {:type => 'New BSD', :file => 'LICENSE' }
  s.author       = { "Heiko Behrens" => "HeikoBehrens@gmx.de" }
  s.source       = { :git => "https://github.com/HBehrens/DNSSDObjects.git", :commit => "0939681fb6898b46a74c6645c898b3ba7078d743" }
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'  
  s.source_files = 'Source/*.{h,m}'
  s.public_header_files = 'Source/*.h'
  s.requires_arc = false
end
