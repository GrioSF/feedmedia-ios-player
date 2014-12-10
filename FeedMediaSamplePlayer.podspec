Pod::Spec.new do |s|
  s.name         = "FeedMediaSamplePlayer"
  s.version      = "1.0.0"
  s.summary      = "Feed Media Sample Player"
  s.description  = <<-DESC
                    Feed Media Sample Player for iOS 

                    Resources
                    =========

                    For more information, please contact `support@fuzz.com` or check out our Github repo at [https://github.com/fuzz-radio/iOS-SDK][2].

                    [1]: http://feed.fm/documentation
                    [2]: https://github.com/fuzz-radio/iOS-SDK
                    [3]: http://feed.fm/dashboard
                    [4]: http://feed.fm/
                   DESC

  s.homepage     = "https://github.com/fuzz-radio/iOS-SDK"
  s.author       = { "FUZZ ftw!" => "eric@fuzz.com" }
  s.source       = { :git => "https://github.com/GrioSF/feedmedia-ios-player.git", :tag => '1.0.0' }
  s.source_files  = "PlayerInterfaceLibrary/Player Interface", "PlayerInterfaceLibrary/Player Interface/**/*.{h,m}"
  s.resources    =  "PlayerInterfaceLibrary/Player Interface/*.{xib}", "PlayerInterfaceLibrary/Player Interface/assets/*.{png}"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  
  s.dependency 'FeedMediaSdk', '~> 1.0.0' 
  s.platform     = :ios, "7.0"
  s.public_header_files = "PlayerInterfaceLibrary/Player Interface/**/*.h"
  s.requires_arc = true
end
