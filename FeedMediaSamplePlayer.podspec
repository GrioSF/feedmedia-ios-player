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
  s.resources    =  "PlayerInterfaceLibrary/Player Interface/*.{xib}", "PlayerInterfaceLibrary/Player Interface/assets/*.{png,ttf}"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  
  s.dependency 'FeedMediaSdk', '~> 1.0.0' 
  s.platform     = :ios, "7.0"
  s.public_header_files = "PlayerInterfaceLibrary/Player Interface/**/*.h"
  s.requires_arc = true
  s.post_install do |library_representation|
    require 'rexml/document'

    library = library_representation.library
    proj_path = library.user_project_path
    proj = Xcodeproj::Project.new(proj_path)
    target = proj.targets.first # good guess for simple projects

    info_plists = target.build_configurations.inject([]) do |memo, item|
      memo << item.build_settings['INFOPLIST_FILE']
    end.uniq
    info_plists = info_plists.map { |plist| File.join(File.dirname(proj_path), plist) }

    resources = library.file_accessors.collect(&:resources).flatten
    fonts = resources.find_all { |file| File.extname(file) == '.otf' || File.extname(file) == '.ttf' }
    fonts = fonts.map { |f| File.basename(f) }

    info_plists.each do |plist|
      doc = REXML::Document.new(File.open(plist))
      main_dict = doc.elements["plist"].elements["dict"]
      app_fonts = main_dict.get_elements("key[text()='UIAppFonts']").first
      if app_fonts.nil?
        elem = REXML::Element.new 'key'
        elem.text = 'UIAppFonts'
        main_dict.add_element(elem)
        font_array = REXML::Element.new 'array'
        main_dict.add_element(font_array)
      else
        font_array = app_fonts.next_element
      end

      fonts.each do |font|
        if font_array.get_elements("string[text()='#{font}']").empty?
          font_elem = REXML::Element.new 'string'
          font_elem.text = font
          font_array.add_element(font_elem)
        end
      end

      doc.write(File.open(plist, 'wb'))
    end
  end
end
