//
//  PaymentDetailVC.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import  Alamofire
class PaymentDetailVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var dateAndTime_lbl: UILabel!
    @IBOutlet weak var amount_lbl: UILabel!
    @IBOutlet weak var pickUpAddress_lbl: UILabel!
    @IBOutlet weak var dropAddress_lbl: UILabel!
    @IBOutlet weak var yourRideWith_lbl: UILabel!
    @IBOutlet weak var totalDistnace: UILabel!
    @IBOutlet weak var paymentStatus_lbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    var kDestinationLatLongTap = ""
    var kCurrentLocaLatLongTap = ""

    var ridesStatusData : PaymentHistoryModal?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
      //  self.navigationItem.title = "Ride Details"
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)

        
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
        self.navigationController?.isNavigationBarHidden = false
        self.setData()
    }
    //MARK:-  set data
    func setData(){
        self.dateAndTime_lbl.text = self.ridesStatusData?.time ?? ""
        self.amount_lbl.text = "Total Amount : $" + (self.ridesStatusData?.payout_amount ?? "")
        self.pickUpAddress_lbl.text = self.ridesStatusData?.pickup_adress ?? ""
        self.dropAddress_lbl.text = self.ridesStatusData?.drop_address ?? ""
        self.yourRideWith_lbl.text = "Your ride was with " + (self.ridesStatusData?.driver_name ?? "")
        self.totalDistnace.text = "Total Distance Covered  :" + (self.ridesStatusData?.distance ?? "") + "  Miles"
        self.paymentStatus_lbl.text = "Payment Status  :  " + (self.ridesStatusData?.payment_status ?? "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let lattitude : Double = Double("\(self.ridesStatusData?.pickup_lat ?? "")")!
            let longi : Double = Double("\(self.ridesStatusData?.pickup_long ?? "")")!
            
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
extension PaymentDetailVC : GMSMapViewDelegate{
    
    //Mark: Reverse GeoCoding
    func reverseGeocoding(marker: GMSMarker) {
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                print("Response is = \(address)")
                print("Response is = \(lines)")
                let lattitude : Double = Double("\(self.ridesStatusData?.drop_lat ?? "")")!
                let longi : Double = Double("\(self.ridesStatusData?.drop_long ?? "")")!
                self.kCurrentLocaLatLongTap =   "\(self.ridesStatusData?.pickup_lat ?? "")" + "," + "\(self.ridesStatusData?.pickup_long ?? "")"
                
                
                currentAddress = lines.joined(separator: "\n")
                self.kDestinationLatLongTap =   "\(lattitude)" + "," + "\(longi)"
                marker.title = currentAddress
                marker.map = self.mapView
                if self.kCurrentLocaLatLongTap != "" && self.kDestinationLatLongTap != ""{
                  //  self.routingLines(origin: self.kCurrentLocaLatLongTap,destination: self.kDestinationLatLongTap)
                }
            }
        }
    }
    //MARK:-  routing line draw
//    func routingLines(origin: String,destination: String){
//        print("PICK UP LAT LONG======\(origin)")
//        print("DROP LAT LONG======\(destination)")
//        
//        let googleapi =  "AIzaSyByga05rgV6dTqTnpBcR0HFiSbWoSxp_3s"
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
//                        let polyLine = GMSPolyline(path: newPath)
//                        polyLine.strokeWidth = 5
//                        polyLine.strokeColor =  .black
//                        let ThemeOrange = GMSStrokeStyle.solidColor( .blue)
//                        let OrangeToBlue = GMSStrokeStyle.gradient(from:  .blue, to:  .blue)
//                        polyLine.spans = [GMSStyleSpan(style: ThemeOrange),
//                                          GMSStyleSpan(style: ThemeOrange),
//                                          GMSStyleSpan(style: OrangeToBlue)]
//                        let bounds = GMSCoordinateBounds(path:newPath! )
//                        self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 7.0))
//                        polyLine.map = self.mapView
//                    }
//                }
//            case .failure(let error): break
//                self.showAlert("Driver RideshareRates", message: "\(String(describing: error.errorDescription))")
//            }
//        }
//    }
}
