Pod::Spec.new do |s|
s.name         = "Pipeline"
s.version      = "2.0.2"
s.summary      = "Pipeline"
s.description  = "A framework for building functional data pipelines."
s.homepage     = "https://github.com/patgoley/Pipeline"
s.license      = { :type => 'Apache 2', :file => 'LICENSE.md' }
s.author       = { "Patrick Goley" => 'patrick.goley@gmail.com' }
s.source       = { :git => "https://github.com/patgoley/Pipeline.git", :tag => '2.0.2' }

s.ios.deployment_target = '8.0'
s.osx.deployment_target = '10.11'
s.requires_arc = true

s.source_files =  "Pipeline/**/*.{swift,h,m}"

end
