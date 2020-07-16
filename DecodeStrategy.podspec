Pod::Spec.new do |s|
  s.name             = 'DecodeStrategy'
  s.version          = '0.1.1'
  s.summary          = 'Decode strategy with @propertywrapper.'

  s.description      = <<-DESC
  This project is convenient applying decode strategy if your backend uses weak type language.

  DESC
   
  s.homepage         = 'https://github.com/ohlulu/DecodeStrategy'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }


  s.author           = { 'Ohlulu' => 'z30262226@gmail.com' }

  s.source                = { :git => 'https://github.com/ohlulu/DecodeStrategy.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.cocoapods_version     = '>= 1.4.0'
  s.swift_version         = '5.1.2'
  s.source_files          = 'DecodeStrategy/Sources/**/*'
  s.frameworks  = "Foundation"
end
