# see http://guides.cocoapods.org/syntax/podspec.html
Pod::Spec.new do |s|
  s.name         = "LDOLayoutTemplates"
  s.version      = "0.9.3"
  s.summary      = "Design multiple layouts of the same view in IB, and transition between them."

  s.description  = <<-DESC
    Design multiple layouts of the same view in Interface Builder, and easily transition between them.
    
    The best way to understand this library is to read its GitHub README while looking at the example storyboard.
  DESC

  s.homepage    = "https://github.com/lurado/LDOLayoutTemplates"
  s.screenshots = "https://github.com/lurado/LDOLayoutTemplates/blob/master/Screenshots/DashboardExample.gif"
  s.license     = { type: "MIT", file: "LICENSE" }
  s.author      = { "Julian Raschke und Sebastian Ludwig GbR" => "info@lurado.com" }
  s.source      = { git: "https://github.com/lurado/LDOLayoutTemplates.git", tag: s.version.to_s }

  s.ios.deployment_target = "8.0"

  s.source_files = "LDOLayoutTemplates/Classes/**/*"
end
