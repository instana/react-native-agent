require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "instana_react-native-agent"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  @instana/react-native-agent
                   DESC
  s.homepage     = "https://github.com/instana/react-native-agent"
  s.license      = "MIT"
  s.authors      = { "Instana Inc." => "support@instana.com" }
  s.platforms    = { :ios => "11.0" }
  s.source       = { :git => "https://github.com/instana/react-native-agent.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true
  s.swift_version = "5.3"
  s.dependency "React-Core"
  s.dependency "InstanaAgent", "1.6.4"
end
