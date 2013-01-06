module CommonPods
  def self.extended(base)
    base.pod 'OCHamcrest', '~> 1.6'
  end
end

target :ios do
  platform :ios, deployment_target: 5.0
  
  link_with "Mocky-iOS"
  
  extend CommonPods
end

target :osx do
  platform :osx, deployment_target: 10.7
  link_with ["Mocky-OSX", "Examples"]
  
  extend CommonPods
end
