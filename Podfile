# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Nexpil' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Nexpil

  pod 'Alamofire', '~> 4.7'
  pod 'ImageSlideshow', '~> 1.5'
  pod 'SkyFloatingLabelTextField', '~> 3.0'
  pod 'XLPagerTabStrip', '~> 8.0'
  pod 'CVCalendar', '~> 1.6.1'
  pod 'ASHorizontalScrollView', '~> 1.5.1'
  pod 'DropDown'
  pod 'fluid-slider'
  pod 'BarcodeScanner'
  pod 'ALCameraViewController'
  pod 'Kingfisher', '~> 4.0'
  pod 'VerticalSteppedSlider'
  pod 'YPImagePicker'
  pod 'OnlyPictures'
  pod 'SVProgressHUD', '~> 2.2' # <--- new added
  pod 'FSCalendar'
  pod 'StepSlider'
  pod 'IQKeyboardManagerSwift', '~> 5.0'
  
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end

