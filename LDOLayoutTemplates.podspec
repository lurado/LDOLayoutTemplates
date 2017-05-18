# see http://guides.cocoapods.org/syntax/podspec.html
Pod::Spec.new do |s|
  s.name             = 'LDOLayoutTemplates'
  s.version          = '0.9.0'
  s.summary          = 'Design different states of a screen in IB and easily transition between them.'

  s.description      = <<-DESC
    Cleanly design different variations of a layout in Interface Builder. No constraint mess.
                       DESC

  s.homepage         = 'https://github.com/lurado/LDOLayoutTemplates'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Julian Raschke und Sebastian Ludwig GbR" => "info@lurado.com" }
  s.source           = { :git => 'https://github.com/lurado/LDOLayoutTemplates.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'LDOLayoutTemplates/Classes/**/*'
end
