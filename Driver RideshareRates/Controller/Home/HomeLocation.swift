//
//  HomeLocation.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit
import CoreLocation
import Alamofire
import GoogleMaps
import GooglePlaces

extension HomeViewController {
    //MARK:- set up loaction
    func setUpLocation(){
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.activityType = CLActivityType.automotiveNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        marker.map = nil
     //   addCurrentLocationMarker()
    }
    //MARK:- routing line api
//    func routingLines(origin: String,destination: String){
//      let googleapi =  "AIzaSyByga05rgV6dTqTnpBcR0HFiSbWoSxp_3s"
//
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(googleapi)"
//
//        AF.request(url).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                if let JSON = value as? [String: Any] {
//                    let routes = JSON["routes"] as! NSArray
//                    for route in routes
//                    {
//                        let values = route as! NSDictionary
//                        
//                        let routeOverviewPolyline = values["overview_polyline"] as! NSDictionary
//                        let path = GMSPath.init(fromEncodedPath: routeOverviewPolyline["points"] as! String)
//                        
//                        let polyline = GMSPolyline(path: path)
//                        polyline.strokeColor = .blue
//                        polyline.strokeWidth = 2.0
//                        polyline.map = self.mapView //where mapView is your @IBOutlet which is in GMSMapView!
//                    }
//                }
//            case .failure(let error): break
//            // error handling
//                self.showAlert("Driver RideshareRates", message: "\(String(describing: error.errorDescription))")
//
//            }
//        }
//    }
    
    //MARK:- draw poly line google api
//    func getPolylineRoute(source: String,destination: String){
//        let googleapi =  "AIzaSyD2w35227g2Onbc_NcurCxO2yIOUpGFk-Y"
//
//        Indicator.shared.showProgressView(self.view)
//
//            let config = URLSessionConfiguration.default
//            let session = URLSession(configuration: config)
//
//            let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(destination)&mode=driving&key=\(googleapi)")
//
//        let task = session.dataTask(with: url!, completionHandler: {
//                (data, response, error) in
//                if error != nil {
//                    print(error!.localizedDescription)
//                    Indicator.shared.hideProgressView()
//
//                }
//                else {
//                    do {
//                        if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
//
//                            guard let routes = json["routes"] as? NSArray else {
//                                DispatchQueue.main.async {
//                                    Indicator.shared.hideProgressView()
//                                }
//                                return
//                            }
//
//                            if (routes.count > 0) {
//                                let overview_polyline = routes[0] as? NSDictionary
//                                let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
//
//                                let points = dictPolyline?.object(forKey: "points") as? String
//
//                                self.showPath(polyStr: points!)
//
//                                DispatchQueue.main.async {
//                                    Indicator.shared.hideProgressView()
//                                    let lat = kPickLat.toDouble()
//                                    let lon = kPickLong.toDouble()
//                                    let firstCoordinates = CLLocationCoordinate2D(latitude: Double((kPickLat as NSString).doubleValue), longitude: Double((kPickLong as NSString).doubleValue))
//                                    let droplat = kDropLat.toDouble()
//                                    let droplon = kDropLong.toDouble()
//                                    let secondCoordinates = CLLocationCoordinate2D(latitude:droplat!
//                                                            , longitude:droplon!)
//
//
//                                    let bounds = GMSCoordinateBounds(coordinate:  firstCoordinates, coordinate: secondCoordinates)
//                                    let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 170, left: 30, bottom: 30, right: 30))
//                                    self.mapView!.moveCamera(update)
//                                }
//                            }
//                            else {
//                                DispatchQueue.main.async {
//                                    Indicator.shared.hideProgressView()
//                                }
//                            }
//                        }
//                    }
//                    catch {
//                        print("error in JSONSerialization")
//                        DispatchQueue.main.async {
//                            Indicator.shared.hideProgressView()
//                        }
//                    }
//                }
//            })
//            task.resume()
//        }

    //MARK:- show path 
        func showPath(polyStr :String){
            let path = GMSPath(fromEncodedPath: polyStr)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 3.0
            polyline.strokeColor = UIColor.red
            polyline.map = mapView // Your map view
        }
//
}
//MARK:- Get User Location
extension HomeViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        locManager.stopUpdatingLocation()
//        locManager.delegate = nil
        
        let location = locations.last! as CLLocation
        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
        NSUSERDEFAULT.setValue("\(myLocation.latitude)", forKey: kCurrentLat)
        NSUSERDEFAULT.setValue("\(myLocation.longitude)", forKey: kCurrentLong)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [self] (placemark, error) in
            if error == nil{
                if ((placemark?.count ?? 0) > 0){
                    let placemark = placemark?.first
                    print(placemark?.locality as Any)
                  //  self.pickUpAddress_lbl.text = placemark?.subLocality ?? ""
                    currentLocation = locations.last
                    kCurrentLocaLatLong = "\(myLocation.latitude)" + "," + "\(myLocation.longitude)"
                    kCurrentLocaLat   = "\(myLocation.latitude)"
                    kCurrentLocaLong = "\(myLocation.longitude)"
                    self.convertLatLongToAddress(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }
            }
        }
        if self.update == true{
            let camera = GMSCameraPosition.camera(withLatitude: myLocation.latitude, longitude: myLocation.longitude, zoom: 18.0)
            self.mapView.camera = camera
            self.mapView.isMyLocationEnabled = false
            self.mapView.settings.myLocationButton = false
            // Creates a marker in the center of the map.
            marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let puppyGif = UIImage(named: "car")
            let imageView = UIImageView(image: puppyGif)
            imageView.frame = CGRect(x: 0, y: 0, width: 85, height: 60)
            marker = GMSMarker(position: location.coordinate)
            marker.iconView = imageView
            marker.map = mapView
            marker.rotation = locationManager.location?.course ?? 0
         //   marker.title = "Sydney"
         //   marker.snippet = "Australia"
          //  marker.map = self.mapView
            
            self.update = false
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
           let heading = newHeading.trueHeading
           let accuracy = newHeading.headingAccuracy
        self.bearing = heading
        self.bearingAccuracy = accuracy
           print("Bearing: \(heading), Bearing Accuracy: \(accuracy)")
       }
    
     func convertLatLongToAddress(latitude:Double, longitude:Double) {
       //  locationPickUpEditStatus = true

         let geoCoder = CLGeocoder()
         let location = CLLocation(latitude: latitude, longitude: longitude)
         geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

             var placeMark: CLPlacemark!
             placeMark = placemarks?[0]

             if placeMark != nil {
                 var addressString : String = ""
                 if (placeMark.subThoroughfare != nil) {
                     addressString = addressString + placeMark.subThoroughfare! + ", "
                 }
                 if placeMark.thoroughfare != nil {
                     addressString = addressString + placeMark.thoroughfare! + ", "
                 }
                 if placeMark.subLocality != nil {
                     addressString = addressString + placeMark.subLocality! + ", "
                 }
                 if placeMark.locality != nil {
                     addressString = addressString + placeMark.locality! + ", "
                 }
                 if placeMark.country != nil {
                     addressString = addressString + placeMark.country! + ", "
                 }
                 if placeMark.postalCode != nil {
                     addressString = addressString + placeMark.postalCode! + " "
                 }
                 print(addressString)
                // self.pickUpAddress_lbl.text =  addressString
//                 self.getNearbyDrivers()
//                 kCurrentAddressMarker = addressString
                 print(placeMark.country as Any)
                 print(placeMark.locality as Any)
                 print(placeMark.subLocality as Any)
                 print(placeMark.thoroughfare as Any)
                 print(placeMark.postalCode as Any)
                 print(placeMark.subThoroughfare as Any)
                 
                 print("CURRENT ADDRESS IS HERE==\(addressString)")
               //  self.pickUpAddress_lbl.text = addressString
                 DcurrentLocation = addressString
                 
                 
                 // labelText gives you the address of the place
             }
         })
     }
}


