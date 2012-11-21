Pod::Spec.new do |s|
  s.name         = "ltools"
  s.version      = "1.0"
  s.summary      = "Tools to help with localising an iOS app."
  s.homepage     = "https://github.com/percysnoodle/ltools"

  s.license      = 'MIT'
  s.author       = 'Simon Booth'

  s.source       = { :git => "https://github.com/percysnoodle/ltools.git", :tag => "1.0" }
  s.platform     = :ios, '2.0'

  s.source_files = 'src'
  s.preserve_paths = 'bin'
end
