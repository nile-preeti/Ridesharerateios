//
//  vehiclecategoryView.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
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
protocol RideStart{
    func RideStart(button:String?)
}

class vehiclecategoryView: UIViewController {
    
    @IBOutlet var mbackButton: UIButton!
    @IBOutlet var mMinB: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet var mViewHeight: NSLayoutConstraint!
    @IBOutlet var mTableV: UITableView!
    var locationManager = CLLocationManager()

    //   var allData: [Category] = []
    var delegate : RideStart?
    var allData = [VechileData]()
    var polyline: GMSPolyline?
    var dMarker = GMSMarker()
    override func viewDidLoad() {
        super.viewDidLoad()
        vehicleTypeId = ""
        mTableV.reloadData()
        applyMapStyle()
        // Do any additional setup after loading the view.
        currentlocation()
        self.routingLines(origin: kCurrentLocaLatLongTap ,destination: kDestinationLatLongTap)
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
    
    func routingLines(origin: String,destination: String){
        print("PICK UP LAT LONG======\(origin)")
        print("DROP LAT LONG======\(destination)")
            let googleapi = "AIzaSyABQXS9DNSgpuGVZnC5bwfpj1mrl4dd4Z8"
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&alternativeRoute=true&key=\(googleapi)"
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
                          let legs = route["legs"] as? [[String: Any]],
                                         let leg = legs.first,
                                         let distance = leg["distance"] as? [String: Any],
                          let distanceValue = distance["value"] as? Int,
                          let duration = leg["duration"] as? [String: Any],
                          let durationValue = duration["value"] as? Int,
                          let startLocation = leg["start_location"] as? [String: Any],
                                           let startLat = startLocation["lat"] as? CLLocationDegrees,
                                           let startLng = startLocation["lng"] as? CLLocationDegrees,
                                           let endLocation = leg["end_location"] as? [String: Any],
                                           let endLat = endLocation["lat"] as? CLLocationDegrees,
                                           let endLng = endLocation["lng"] as? CLLocationDegrees
                         //   print(distanceValue)
                            
                            
                    else {
                        // Handle parsing error or invalid response
                        return
                    }
                    print(distanceValue)
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
                    
                    let pickupMarker = GMSMarker()
                               pickupMarker.position = CLLocationCoordinate2D(latitude: startLat, longitude: startLng)
                               pickupMarker.title = "origin"
                    pickupMarker.icon = GMSMarker.markerImage(with: .blue)
                   // pickupMarker.icon = UIImage(named: "custom_blue_marker") // Replace with your image name

                               pickupMarker.map = self.mapView
                               
                              
                    // Add marker for drop location
                              
                    let dropMarker = GMSMarker()
                               dropMarker.position = CLLocationCoordinate2D(latitude: endLat, longitude: endLng)
                               dropMarker.title = "destination"
                    
                               dropMarker.map = self.mapView
                case .failure(let error):
                   
                    print("Error: \(error)")
                }
            }
    }
    // Helper function to create a colored UIImage
    func createColoredIcon(color: UIColor) -> UIImage? {
        let markerSize = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(markerSize, false, 0)
        color.setFill()
        let rect = CGRect(x: 0, y: 0, width: markerSize.width, height: markerSize.height)
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
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
    @IBAction func mRidenowBTN(_ sender: Any) {
        if vehicleTypeId != "" {
            self.dismiss(animated: true, completion: {
                self.delegate?.RideStart(button: "ridenow")
            })
        }else{
            self.showAlert("Rider RideshareRates", message: "Please select service")
        }
        
    }
    @IBAction func mMinBTN(_ sender: Any) {
        if mMinB.currentImage == UIImage(named: "minus-cirlce"){
           // popupheight = "half"
            mViewHeight.constant = 200
            mMinB.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right.circle.fill"), for: .normal)
        }else{
           // popupheight = "full"
            mViewHeight.constant = 500
            mMinB.setImage(UIImage(named: "minus-cirlce"), for: .normal)
        }
    }
    
    @IBAction func closeBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.RideStart(button: "close")
        })
      //  self.dismiss(animated: true, completion: nil)
    }
    @IBAction func mBAckBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
}
extension vehiclecategoryView:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return allData.count
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            if tableView == mTableV{
                headerView.textLabel?.textColor = .white
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0 // Set the desired height for your section header here.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allData[section].vehicles!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSectionsTableViewCellID", for: indexPath) as? HomeSectionsTableViewCell else {
            return UITableViewCell()
        }
        let vehicle = allData[indexPath.section].vehicles![indexPath.row]
        cell.mLBL.text = vehicle.vhicle_name
        cell.mRate.text = "$" + vehicle.totalAmount!
        cell.carImageView.sd_setImage(with:URL(string: vehicle.vehicle_image ?? "" ), placeholderImage: UIImage(named: ""), completed: nil)
        
        if vehicleTypeId == vehicle.vehicle_id ?? ""  {
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = #colorLiteral(red: 0.9921568627, green: 0.9607843137, blue: 0.6901960784, alpha: 1)
        }else{
            cell.layer.borderWidth = 0.0
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let vehicle = allData[indexPath.section].vehicles![indexPath.row]
        vehicleTypeId = vehicle.vehicle_id ?? ""
        holdAmount = vehicle.hold_amount ?? ""
        rideAmount = vehicle.totalAmount ?? ""
        mTableV.reloadData()
        
    }
  
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allData[section].category_name
    }
}

extension vehiclecategoryView : CLLocationManagerDelegate{
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
