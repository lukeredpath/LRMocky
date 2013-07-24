Pod::Spec.new do |s|
  s.name         = 'LRMocky'
  s.version      = '1.0'
  s.license      = 'MIT'
  s.summary      = 'A mock object library for Objective C, inspired by JMock 2.0'
  s.homepage     = 'http://github.com/lukeredpath/LRMocky'
  s.authors      = { 'Luke Redpath' => 'luke@lukeredpath.co.uk' }
  s.source       = { :git => 'https://github.com/lukeredpath/LRMocky.git' }
  s.requires_arc = true
  s.source_files = 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  
  non_arc_compatible_file_patterns = ['Classes/**/NSInvocation+{BlockArguments,OCMAdditions}']
  
  # exclude files that are not ARC compatible
  non_arc_source_files = non_arc_compatible_file_patterns.map { |p| p + ".{h,m}" }
  s.exclude_files = non_arc_source_files + ['Classes/**/LRMockyAutomation.{h,m}']
  
  # create a sub-spec just for the non-ARC files
   s.subspec 'no-arc' do |sp|
     sp.source_files = non_arc_source_files
     sp.public_header_files = non_arc_compatible_file_patterns.map { |p| p + ".h" }
     sp.requires_arc = false
   end

  # platform targets
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  
  # dependencies
  s.dependency 'OCHamcrest', '1.9'
end
