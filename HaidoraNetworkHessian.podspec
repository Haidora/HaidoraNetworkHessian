Pod::Spec.new do |s|
  s.name             = "HaidoraNetworkHessian"
  s.version          = "0.1.4"
  s.summary          = "HaidoraNetworkHessian."

  s.description      = <<-DESC
                          A short description of HaidoraNetworkHessian.
                       DESC

  s.homepage         = "https://github.com/Haidora/HaidoraNetworkHessian"
  s.license          = 'MIT'
  s.author           = { "mrdaios" => "mrdaios@gmail.com" }
  s.source           = { :git => "https://github.com/Haidora/HaidoraNetworkHessian.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'HaidoraNetworkHessian' => ['Pod/Assets/*.png']
  }
  s.dependency 'HaidoraNetwork'
  s.dependency 'AFNetworking'
end
