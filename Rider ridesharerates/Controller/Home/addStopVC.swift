//
//  addStopVC.swift
//  Rider ridesharerates
//
//  Created by malika on 22/05/24.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import AVFoundation
import Firebase
import FirebaseDatabase
import MapKit
import Alamofire
struct CellData {
    // Add any data you want to display in the cell
    var id: Int
}
protocol addstop{
    func addstop(totalDistance:Int?, totalDuration:Int?, addstop:String?)
}

class addStopVC: UIViewController {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet var mtableview: UITableView!
    @IBOutlet var mbackbutton : UIButton!
    @IBOutlet var pickuplocation : UITextField!
    @IBOutlet var droplocation : UITextField!
    @IBOutlet var stoplocation : UITextField!
    @IBOutlet var stoploc1BTN: UIButton!
    @IBOutlet var mstoploc2BTN: UIButton!
    @IBOutlet var stoploc2 : UITextField!
    @IBOutlet var mstop3BTN: UIButton!
    @IBOutlet var stoploc3 : UITextField!
    
    var delegate : addstop?
    var totalDistance = 0
               var totalDuration = 0
    var polyline: GMSPolyline?
    var dMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var cellDataArray: [CellData] = [CellData(id: 0)]
    var selectedTextField: UITextField?
    var ongoing = ""
    var midpoint = ""
  
    var allMarkers: [GMSMarker] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ongoing == "ongoingadd"{
            
            
            let loc = NSUSERDEFAULT.value(forKey: OGCurrentAdd) as! String
            pickuplocation.text = loc
            
            let stop = NSUSERDEFAULT.value(forKey: kdroploc) as! String
            droplocation.text = stop
        }else{
            let loc = NSUSERDEFAULT.value(forKey: kpCurrentAdd) as! String
            pickuplocation.text = loc
            droplocation.text = midpoint
        }
        pickuplocation.delegate = self
        droplocation.delegate = self
               
        mtableview.delegate = self
        mtableview.dataSource = self
        stoplocation.delegate = self
        stoploc2.delegate = self
        stoploc3.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
      //  updateAppVersionPopup()
        applyMapStyle()
        pickuplocation.placeHolderColor = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        droplocation.placeHolderColor = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        stoplocation.placeHolderColor = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        pickuplocation.setLeftPaddingPoints(8)
        droplocation.setLeftPaddingPoints(8)

        stoplocation.setLeftPaddingPoints(8)

//        pickuplocation.setLeftPaddingPoints(20)
//        pickuplocation.layer.borderWidth = 1
//        pickuplocation.layer.borderColor = #colorLiteral(red: 0.9921568627, green: 0.9607843137, blue: 0.6901960784, alpha: 1)
//        
//        droplocation.setLeftPaddingPoints(20)
//        droplocation.layer.borderWidth = 1
//        droplocation.layer.borderColor = #colorLiteral(red: 0.9921568627, green: 0.9607843137, blue: 0.6901960784, alpha: 1)
//        stoplocation.setLeftPaddingPoints(20)
//        stoplocation.layer.borderWidth = 1
//        stoplocation.layer.borderColor = #colorLiteral(red: 0.9921568627, green: 0.9607843137, blue: 0.6901960784, alpha: 1)
//        stoploc2.setLeftPaddingPoints(20)
//        stoploc2.layer.borderWidth = 1
//        stoploc2.layer.borderColor = #colorLiteral(red: 0.9921568627, green: 0.9607843137, blue: 0.6901960784, alpha: 1)
//        stoploc3.setLeftPaddingPoints(20)
//        stoploc3.layer.borderWidth = 1
//        stoploc3.layer.borderColor = #colorLiteral(red: 0.9921568627, green: 0.9607843137, blue: 0.6901960784, alpha: 1)

        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = .black
        self.navigationController?.navigationBar.barStyle = .black
        setNeedsStatusBarAppearanceUpdate()
        currentlocation()
    }
    func currentlocation(){
        locationManager.delegate = self
               locationManager.requestWhenInUseAuthorization()
               locationManager.startUpdatingLocation()
        // Enable My Location on the map
                mapView.isMyLocationEnabled = true
                mapView.settings.myLocationButton = true
               // Setup initial camera position (optional)
              // let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
            //   mapView.camera = camera
    }
    func applyMapStyle() {
        // Retrieve the style URL from the JSON file
        guard let styleURL = Bundle.main.url(forResource: "dark_map_style", withExtension: "json") else {
            return
        }
        
        do {
            // Load the JSON file and create a GMSMapStyle object
            let mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            
            // Apply the custom style to the map view
            self.mapView.mapStyle = mapStyle
          //  self.mHomeMApV.mapStyle = mapStyle
        } catch {
            print("Error loading map style: \(error)")
        }
    }
    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        
    }
    @IBAction func booknow(_ sender: Any) {
        if pickuplocation.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please enter pickup location")
            return
        }else if stoplocation.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please enter drop location")
            return
        }else if droplocation.text == ""{
            self.showAlert("Rider RideshareRates", message: "Please enter drop location")
            return
        }else{
            if ongoing == "ongoingadd"{
                kDistanceInMiles = String(self.totalDistance)
                self.dismiss(animated: false, completion: {
                    self.delegate?.addstop(totalDistance: self.totalDistance, totalDuration: self.totalDuration, addstop: "ongoingadd")
                })
            }else{
                kDistanceInMiles = String(self.totalDistance)
                self.dismiss(animated: false, completion: {
                    self.delegate?.addstop(totalDistance: self.totalDistance, totalDuration: self.totalDuration, addstop: "")
                })
            }
            
        }
        
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    @IBAction func mdroplocBTN(_ sender: Any) {
        
        if droplocation.text != ""{
            droplocation.text = ""
           
            self.mapView.clear()
           
        }else{
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    
    @IBAction func mstop1BTN(_ sender: Any) {
        if stoplocation.text != ""{
            stoplocation.text = ""
            self.mapView.clear()
        }else{
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    @IBAction func mstop2BTN(_ sender: Any) {
    }
    
    
    @IBAction func mstop3btn(_ sender: Any) {
    }
}
extension addStopVC : UITextFieldDelegate, GMSAutocompleteViewControllerDelegate{
    // UITextFieldDelegate method
       func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
           selectedTextField = textField
           openAutocompleteController()
           return false
       }

       func openAutocompleteController() {
//           marker.map = nil
//           polyLine.map = nil
           let autocompleteController = GMSAutocompleteViewController()
           autocompleteController.delegate = self
           autocompleteController.primaryTextColor = UIColor.lightGray
           autocompleteController.primaryTextHighlightColor = UIColor.white
           autocompleteController.secondaryTextColor = UIColor.white
           autocompleteController.tableCellSeparatorColor = UIColor.lightGray
           autocompleteController.tableCellBackgroundColor = UIColor.lightBlackThemeColor()
           
           let searchBarTextAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white, NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: UIFont.systemFontSize)]
           UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
          // autocompleteController.searchbartextatt
           
           present(autocompleteController, animated: true, completion: nil)
       }
    // GMSAutocompleteViewControllerDelegate methods
//       func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//           dismiss(animated: true, completion: nil)
//
//           selectedTextField?.text = place.formattedAddress
//
//           // If all text fields are filled, call the routingLines function
//           if let origin = pickuplocation.text, !origin.isEmpty,
//              let stop = stoplocation.text, !stop.isEmpty,
//              let destination = droplocation.text, !destination.isEmpty {
//               routingLines(origin: origin, stop: stop, destination: destination)
//           }
//       }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            dismiss(animated: true, completion: nil)
        var fullAddress = ""
        if  place.name != nil{
            fullAddress += place.name! + ", "
        }
        let addressComponents = place.addressComponents
        
//        for component in addressComponents! {
//            let addressType = component.types[0]
//            if addressType == "street_number" || addressType == "route" {
//                fullAddress += component.name + ", "
//            }else if addressType == "sublocality_level_2" || addressType == "sublocality" {
//                fullAddress += component.name + ", "
//            }else if addressType == "sublocality_level_1" || addressType == "sublocality" {
//                fullAddress += component.name + ", "
//            } else if addressType == "locality" || addressType == "administrative_area_level_1" {
//                fullAddress += component.name + ", "
//            } else if addressType == "postal_code" {
//                fullAddress += component.name + ", "
//            } else if addressType == "country" {
//                fullAddress += component.name
//            }
//        }
        selectedTextField?.text = fullAddress + place.formattedAddress!
        
        if let textField = selectedTextField {
                   // textField.text = place.formattedAddress

                    // Store the latitude and longitude of the selected place
                    let latitude = String(place.coordinate.latitude)
                    let longitude = String(place.coordinate.longitude)

                    if textField == pickuplocation {
                        kCurrentLocaLat = latitude
                        kCurrentLocaLong = longitude
                        
                    } else if textField == droplocation {
//                        kDropLat = latitude
//                        kDropLong = longitude
                        kstoplat = latitude
                        kstoplong = longitude
                       
                    }else if textField == stoplocation {
                        kDropLat = latitude
                        kDropLong = longitude
//                        kstoplat = latitude
//                        kstoplong = longitude
                    }
                }
        
            // Gather the selected locations
            let origin = pickuplocation.text
          kpickupAddress = self.pickuplocation.text!
            let destination = droplocation.text
            var stops = [String]()
        if let destination = droplocation.text, !destination.isEmpty {
            stops.append(destination)
        }
            if let stop1 = stoplocation.text, !stop1.isEmpty {
                stops.append(stop1)
            }
            if let stop2 = stoploc2.text, !stop2.isEmpty {
                stops.append(stop2)
            }
            if let stop3 = stoploc3.text, !stop3.isEmpty {
                stops.append(stop3)
            }

            // Call the routingLines function if origin and destination are not empty
        if let origin = origin, !origin.isEmpty{
            if stops.count != 0 {
                let destination = stops.last!
                kDropAddress = destination
                stops.removeLast()
                kstops = stops
                
                if ongoing == "ongoingadd"{
                    
                    let stop = NSUSERDEFAULT.value(forKey: kdroploc) as! String
                   // droplocation.text = stop
                    
                    routingLineswithstop(origin: stop, stops: [""], destination: destination)

                }else{
                    routingLineswithstop(origin: origin, stops: stops, destination: destination)

                }
                
                
            }
        }
        }

       func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
           dismiss(animated: true, completion: nil)
           print("Error: \(error.localizedDescription)")
       }

       func wasCancelled(_ viewController: GMSAutocompleteViewController) {
           dismiss(animated: true, completion: nil)
       }
}
extension addStopVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addStopTableViewCellID", for: indexPath) as! addStopTableViewCell
        cell.configure(with: cellDataArray[indexPath.row])
        cell.indexlblBTN.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
        cell.crossbtn.addTarget(self, action: #selector(crossButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func plusButtonTapped(_ sender: UIButton) {
        if let indexPath = mtableview.indexPath(for: sender.superview?.superview as! addStopTableViewCell) {
            let newCellData = CellData(id: cellDataArray.count)
            cellDataArray.insert(newCellData, at: indexPath.row + 1)
            mtableview.insertRows(at: [IndexPath(row: indexPath.row + 1, section: 0)], with: .automatic)
        }
    }
    
    @objc func crossButtonTapped(_ sender: UIButton) {
        if let indexPath = mtableview.indexPath(for: sender.superview?.superview as! addStopTableViewCell) {
            cellDataArray.remove(at: indexPath.row)
            mtableview.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension addStopVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.first {
               updateMapCamera(to: location)
               locationManager.stopUpdatingLocation() // Stop updating to save battery
           }
       }

       // Handle authorization status change
       func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           switch status {
           case .authorizedWhenInUse, .authorizedAlways:
               locationManager.startUpdatingLocation()
           case .denied, .restricted:
               // Handle case when user denied location access
               break
           default:
               break
           }
       }

       // Update the map camera to the current location
       func updateMapCamera(to location: CLLocation) {
           let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 18.0)
           mapView.animate(to: camera)
       }
}
extension addStopVC{
    

    // Function to draw the polyline with the selected locations
    
    func routingLineswithstop(origin: String, stops: [String], destination: String) {
        print("PICK UP LAT LONG======\(origin)")
        print("STOPS LAT LONG======\(stops)")
        print("DROP LAT LONG======\(destination)")

        // Construct the waypoints parameter
        let waypoints = stops.joined(separator: "|")

        let googleapi = "AIzaSyABQXS9DNSgpuGVZnC5bwfpj1mrl4dd4Z8"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&waypoints=\(waypoints)&mode=driving&key=\(googleapi)"
        let headers: HTTPHeaders = [
            "X-Ios-Bundle-Identifier": "com.riderRideshare.app"
        ]

        print(url)

        AF.request(url, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)

                guard let json = value as? [String: Any],
                      let routes = json["routes"] as? [[String: Any]],
                      let route = routes.first,
                      let polyline = route["overview_polyline"] as? [String: Any],
                      let points = polyline["points"] as? String,
                      let legs = route["legs"] as? [[String: Any]]
                else {
                    // Handle parsing error or invalid response
                    return
                }

                // Clear existing markers from the map
                for marker in self.allMarkers {
                    marker.map = nil
                }
                self.allMarkers.removeAll()

                // Reset total distance and duration
                self.totalDistance = 0
                self.totalDuration = 0

                // Calculate total distance and duration
                for leg in legs {
                    if let distance = leg["distance"] as? [String: Any],
                       let distanceValue = distance["value"] as? Int {
                        self.totalDistance += distanceValue
                    }

                    if let duration = leg["duration"] as? [String: Any],
                       let durationValue = duration["value"] as? Int {
                        self.totalDuration += durationValue
                    }
                }

                // Print total distance and duration
                print("Total Distance: \(self.totalDistance) meters")
                print("Total Duration: \(self.totalDuration) seconds")

                var markerIndex = 0

                // Add origin marker
                if let originLocation = legs.first?["start_location"] as? [String: Any],
                   let originLat = originLocation["lat"] as? CLLocationDegrees,
                   let originLng = originLocation["lng"] as? CLLocationDegrees {
                    let originMarker = GMSMarker()
                    originMarker.position = CLLocationCoordinate2D(latitude: originLat, longitude: originLng)
                    originMarker.title = "Origin"
                    originMarker.icon = UIImage(named: "red_marker") // Set your red marker image here
                    originMarker.map = self.mapView
                    self.allMarkers.append(originMarker)
                    markerIndex += 1
                }

                // Add waypoints markers and leg end markers
                for leg in legs {
                    guard let endLocation = leg["end_location"] as? [String: Any],
                          let endLat = endLocation["lat"] as? CLLocationDegrees,
                          let endLng = endLocation["lng"] as? CLLocationDegrees
                    else {
                        continue
                    }
                    // Create a marker for each leg end location
                    let endMarker = GMSMarker()
                    endMarker.position = CLLocationCoordinate2D(latitude: endLat, longitude: endLng)
                    endMarker.title = "Stop \(markerIndex)"
                    endMarker.icon = self.createNumberedMarkerIcon(number: markerIndex)
                    endMarker.map = self.mapView
                    self.allMarkers.append(endMarker)
                    markerIndex += 1
                }

                // Decode the polyline points
                let path = GMSPath(fromEncodedPath: points)

                // Remove existing polyline from the map if it exists
                self.polyline?.map = nil

                // Create a new GMSPolyline and add it to the map
                let newPolyline = GMSPolyline(path: path)
                newPolyline.strokeColor = #colorLiteral(red: 0.9921568627, green: 0.9607843137, blue: 0.6901960784, alpha: 1)
                newPolyline.strokeWidth = 5
                newPolyline.map = self.mapView
                self.polyline = newPolyline

                let bounds = GMSCoordinateBounds(path: path!)
                let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
                self.mapView.animate(with: update)

            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

   



        // Function to create numbered marker icons with square backgrounds
//        func createNumberedMarkerIcon(number: Int) -> UIImage? {
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//            label.backgroundColor = .white
//            label.textColor = .black
//            label.textAlignment = .center
//            label.text = "\(number)"
//            label.layer.borderColor = UIColor.black.cgColor
//            label.layer.borderWidth = 2
//            label.layer.cornerRadius = 5
//            label.layer.masksToBounds = true
//            
//            UIGraphicsBeginImageContextWithOptions(label.frame.size, false, 0)
//            guard let context = UIGraphicsGetCurrentContext() else { return nil }
//            label.layer.render(in: context)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            
//            return image
//        }


        // Function to create numbered marker icons with square backgrounds
        func createNumberedMarkerIcon(number: Int) -> UIImage? {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            label.backgroundColor = .white
            label.textColor = .black
            label.textAlignment = .center
            label.text = "\(number)"
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 2
            label.layer.cornerRadius = 5
            label.layer.masksToBounds = true
            
            UIGraphicsBeginImageContextWithOptions(label.frame.size, false, 0)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            label.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }


        // Function to create numbered marker icons with square backgrounds
//        func createNumberedMarkerIcon(number: Int) -> UIImage? {
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//            label.backgroundColor = .white
//            label.textColor = .black
//            label.textAlignment = .center
//            label.text = "\(number)"
//            label.layer.borderColor = UIColor.black.cgColor
//            label.layer.borderWidth = 2
//            label.layer.cornerRadius = 5
//            label.layer.masksToBounds = true
//            
//            UIGraphicsBeginImageContextWithOptions(label.frame.size, false, 0)
//            guard let context = UIGraphicsGetCurrentContext() else { return nil }
//            label.layer.render(in: context)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            
//            return image
//        }

}
