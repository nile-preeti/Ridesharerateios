//
//  RideDetailsViewController.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//


import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import  Alamofire

class RideDetailsViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var distance_lbl: UILabel!
    @IBOutlet weak var ride_status_lbl: UILabel!
    
    @IBOutlet var mBGView: UIView!
    @IBOutlet weak var dateAndTime_lbl: UILabel!
    @IBOutlet weak var amount_lbl: UILabel!
    @IBOutlet weak var pickUpAddress_lbl: UILabel!
    @IBOutlet weak var dropAddress_lbl: UILabel!
    @IBOutlet weak var yourRideWith_lbl: UILabel!
    @IBOutlet weak var paymentStatus_lbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    var kDestinationLatLongTap = ""
    var kCurrentLocaLatLongTap = ""
    
    //MARK:- Variables
    
    var ridesStatusData : RidesData?
    
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "Ride Details"
        mBGView.layer.cornerRadius = 15
        applyMapStyle()
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
        } catch {
            print("Error loading map style: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.setNavButton()
        self.navigationController?.isNavigationBarHidden = false
        self.setData()
    }
    func setNavButton(){
        
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = .black

        
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func tapNavButton(){
        
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
    //MARK:- User Defined Func
    
    func setData(){
        
        self.dateAndTime_lbl.text = self.ridesStatusData?.time ?? ""
        self.amount_lbl.text = "$" + (self.ridesStatusData?.amount ?? "")
        self.pickUpAddress_lbl.text = self.ridesStatusData?.pickupAdress ?? ""
        self.dropAddress_lbl.text = self.ridesStatusData?.dropAddress ?? ""
        self.paymentStatus_lbl.text = self.ridesStatusData?.paymentStatus ?? ""
        self.yourRideWith_lbl.text = self.ridesStatusData?.driver_lastname ?? "Boss"
        self.distance_lbl.text = (self.ridesStatusData?.distance ?? "") +  " miles"
        self.ride_status_lbl.text = self.ridesStatusData?.status ?? ""
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let lattitude : Double = Double("\(self.ridesStatusData?.pickupLat ?? "")")!
            let longi : Double = Double("\(self.ridesStatusData?.pickupLong ?? "")")!
            
            let camera = GMSCameraPosition.camera(withLatitude:lattitude, longitude:longi, zoom: 18.0)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longi)
            self.mapView.delegate = self
            marker.isDraggable = true
            marker.map = self.mapView
            self.reverseGeocoding(marker: marker)
            self.mapView.animate(to: camera)
        })
    }
}

extension RideDetailsViewController : GMSMapViewDelegate{
    
    //Mark: Reverse GeoCoding
    func reverseGeocoding(marker: GMSMarker) {
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                print("Response Reverse Geocoding is = \(address)")
                print("Response Reverse Geocoding is = \(lines)")
                let lattitude : Double = Double("\(self.ridesStatusData?.dropLat ?? "")")!
                let longi : Double = Double("\(self.ridesStatusData?.dropLong ?? "")")!
                
                self.kCurrentLocaLatLongTap =   "\(self.ridesStatusData?.pickupLat ?? "")" + "," + "\(self.ridesStatusData?.pickupLong ?? "")"
                
                
                
                currentAddress = lines.joined(separator: "\n")
                self.kDestinationLatLongTap =   "\(lattitude)" + "," + "\(longi)"
                marker.title = currentAddress
                
                marker.map = self.mapView
                if self.kCurrentLocaLatLongTap != "" && self.kDestinationLatLongTap != ""{
                 //   self.routingLines(origin: self.kCurrentLocaLatLongTap,destination: self.kDestinationLatLongTap)
                }
            }
        }
    }
    
    //MARK:- drawing routing line
//    func routingLines(origin: String,destination: String){
//        print("PICK UP LAT LONG======\(origin)")
//        print("DROP LAT LONG======\(destination)")
//        
//        let googleapi = "AIzaSyABQXS9DNSgpuGVZnC5bwfpj1mrl4dd4Z8"
//        
//        
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(googleapi)"
//        AF.request(url).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                if let JSON = value as? [String: Any] {
//                    let routes = JSON["routes"] as! NSArray
//                    for route in routes
//                    {
//                        let pathv : NSArray = routes.value(forKey: "overview_polyline") as! NSArray
//                        let paths : NSArray = pathv.value(forKey: "points") as! NSArray
//                        let newPath = GMSPath.init(fromEncodedPath: paths[0] as! String)
//                        
//                        let polyLine = GMSPolyline(path: newPath)
//                        polyLine.strokeWidth = 5
//                        polyLine.strokeColor =  #colorLiteral(red: 0.9942796826, green: 0.9596012235, blue: 0.6591211557, alpha: 1)
//                        let ThemeOrange = GMSStrokeStyle.solidColor( #colorLiteral(red: 0.9942796826, green: 0.9596012235, blue: 0.6591211557, alpha: 1))
//                        let OrangeToBlue = GMSStrokeStyle.gradient(from:  #colorLiteral(red: 0.9942796826, green: 0.9596012235, blue: 0.6591211557, alpha: 1), to:  #colorLiteral(red: 0.9942796826, green: 0.9596012235, blue: 0.6591211557, alpha: 1))
//                        polyLine.spans = [GMSStyleSpan(style: ThemeOrange),
//                                          GMSStyleSpan(style: ThemeOrange),
//                                          GMSStyleSpan(style: OrangeToBlue)]
//                        let bounds = GMSCoordinateBounds(path:newPath! )
//                        
//                        self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 7.0))
//                        polyLine.map = self.mapView
//                    }
//                }
//            case .failure(let error): break
//                self.showAlert("Rider RideshareRates", message: "\(String(describing: error.errorDescription))")
//            }
//        }
//    }
}
