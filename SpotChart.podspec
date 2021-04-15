Pod::Spec.new do |spec|

  spec.name          = "SpotChart"
  spec.version       = "0.0.4"
  spec.summary       = "Customizable Charts"

  spec.homepage      = "https://github.com/boof-tech/SpotChart"


  spec.swift_versions = '5.0'
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  spec.license       = { :type => "MIT" }
  spec.author        = { "Boof.tech" => "info@boof.tech" }
  spec.platform      = :ios, "11.0"
  spec.source        = { :git => 'https://github.com/boof-tech/SpotChart.git', :tag => '0.0.4'}
  spec.dependency "Charts"
  spec.source_files  = "SpotChart/**/*.{swift,xib}"
end