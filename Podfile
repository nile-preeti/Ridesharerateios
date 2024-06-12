# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

target 'Driver RideshareRates' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Driver RideshareRates

  target 'Driver RideshareRatesTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Driver RideshareRatesUITests' do
    # Pods for testing
  end
  pod 'DropDown'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'Alamofire'
  pod 'TOCropViewController'
  pod 'SDWebImage'
  pod 'iOSDropDown'
  pod 'IQKeyboardManager'
  pod 'IBAnimatable'
  pod 'Charts'
    # Add the Firebase pod for Google Analytics
   
    pod "Popover"
    pod 'FSCalendar'
    pod'SwiftyJSON'
    project.targets.each do |target|
       target.build_configurations.each do |config|
         config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
       end
     end
   end
end
