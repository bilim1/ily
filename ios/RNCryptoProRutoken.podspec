require "json"

package = JSON.parse(File.read(File.join(__dir__, "../package.json")))

Pod::Spec.new do |s|
  s.name         = "RNCryptoProRutoken"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = "https://github.com/yourusername/react-native-cryptopro-rutoken"
  s.license      = { :type => "MIT" }
  s.authors      = { "Author" => "email@example.com" }
  s.platforms    = { :ios => "12.0" }
  s.source       = { :git => "", :tag => "v#{s.version}" }
  s.source_files = "RNCryptoProRutoken/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React-Core"
  s.dependency "CryptoPro-CSP"
  s.dependency "Rutoken"

  s.xcconfig = {
    "HEADER_SEARCH_PATHS" => "$(inherited) $(PODS_ROOT)/CryptoPro-CSP/Headers $(PODS_ROOT)/Rutoken/Headers",
    "LIBRARY_SEARCH_PATHS" => "$(inherited) $(PODS_ROOT)/CryptoPro-CSP/Libraries $(PODS_ROOT)/Rutoken/Libraries"
  }
end
