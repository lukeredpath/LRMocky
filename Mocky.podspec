Pod::Spec.new do |s|
  s.name         = 'Mocky'
  s.version      = '1.0'
  s.summary      = 'A mock object library for Objective C, inspired by JMock 2.0'
  s.homepage     = 'http://github.com/lukeredpath/LRMocky'
  s.authors      = { 'Luke Redpath' => 'luke@lukeredpath.co.uk' }
  s.source       = { :git => 'https://github.com/lukeredpath/LRMocky.git' }
  s.source_files = FileList['Classes', 'Classes/LRMocky', 'Vendor'] - ['LRMockyAutomation.*']
  
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
end
