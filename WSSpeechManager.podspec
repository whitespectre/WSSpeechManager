Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "WSSpeechManager"
  s.version      = "1.0.0"
  s.summary      = "A singleton that allows you to handle speech recognition and playing sounds."
  s.description  = "The WSSpeechManager allows you to detect words with the Speech API and execute callback blocks when a specific word/phrase is detected. Since it handles Audio inputs, we've also included methods to play custom and system sounds, to make it easier to handle the Audio Buffers (input + output) and avoid crashes due to forbidden accesses."

  s.homepage     = "https://www.whitespectre.com"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "MIT"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "Whitespectree" => "developer@whitespectre.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "10.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => 'https://github.com/whitespectre/WSSpeechManager.git', :tag => '1.0.0' }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "WSSpeechManager", "WSSpeechManager/**/*.{h,m,swift}"

  # ――― Other Settings ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }

  s.swift_version = "4.2"

end
