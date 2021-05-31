
Pod::Spec.new do |s|
  s.name         = "ReactNativeNFC"
  s.version      = "1.0.0"
  s.summary      = "ReactNativeNFC"
  s.description  = <<-DESC
                  ReactNativeNFC
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/joeldiaz2302/react-native-rfid-nfc.git", :tag => "master" }
  s.source_files  = "react-native-rfid-nfc/**/*.{h,m,swift}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  