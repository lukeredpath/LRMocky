target :tests, :exclusive => true do
  platform :ios
  link_with 'Tests'
  
  pod 'OCHamcrest', '~> 1.6'
end

target :tests_osx, :exclusive => true do
  platform :osx, :deployment_target => '10.7'
  link_with ['UnitTests', 'FunctionalTests']
  
  pod 'OCHamcrest', '~> 1.6'
end
