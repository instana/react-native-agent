require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-instana-eum"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-instana-eum
                   DESC
  s.homepage     = "https://github.com/instana/react-native-instana-eum"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.authors      = { "Instana Inc." => "info@instana.com" }
  s.platforms    = { :ios => "11.0" }
  s.source       = { :git => "https://github.com/instana/react-native-instana-eum.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true
  s.swift_version = "5.1"
  s.dependency "React"
  s.dependency "InstanaAgent"
end

