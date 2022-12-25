# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

def spotchart_pods
    pod 'Charts', :git => 'https://github.com/tiss-co/Charts.git', :branch => 'fix-app-version'
end

target 'SpotChart' do
    spotchart_pods
end

target 'SpotChartExample' do
    spotchart_pods
end

post_install do |installer|
   installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
     config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
    end
   end
  end
