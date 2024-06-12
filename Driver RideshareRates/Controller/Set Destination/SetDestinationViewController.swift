//
//  SetDestinationViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit
import GoogleMaps
import GooglePlaces

class SetDestinationViewController: UIViewController {

    //MARK:- OUTLETS
    
    @IBOutlet weak var dropAddress_lbl: UILabel!

    //MAKR:- Variables
    var kDestinationLat = ""
    var kDestinationLong = ""
    var dropLat = ""
    var dropLong = ""
    var dropAddress = ""
    let conn = webservices()

    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavButton()
        
    }
    
    @IBAction func tapDestinationLoaction_btn(_ sender: Any) {
        self.autocompleteClicked()
    }
    //MARK:- Auto Complete API
    // Present the Autocomplete view controller when the button is pressed.
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.primaryTextColor = UIColor.lightGray
        autocompleteController.primaryTextHighlightColor = UIColor.white
        autocompleteController.secondaryTextColor = UIColor.white
        autocompleteController.tableCellSeparatorColor = UIColor.lightGray
        autocompleteController.tableCellBackgroundColor = UIColor.lightBlackThemeColor()
        
        let searchBarTextAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white, NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(UInt(GMSPlaceField.name.rawValue)))
       // autocompleteController.placeFields = fields
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Set Destination"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
      //  self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)

    }
    func setNavButton(){
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
        //let appearance = UINavigationBarAppearance()
       // appearance.configureWithOpaqueBackground()
       // appearance.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
      //  self.navigationController?.navigationBar.standardAppearance = appearance
     //   self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
    }
    @objc func tapNavButton(){
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
}

//MARK:- Google Places Delegate
extension SetDestinationViewController: GMSAutocompleteViewControllerDelegate {
    func GetPlaceDataByPlaceID(pPlaceID: String) {
        let placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID(pPlaceID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                print("Place ID latitude:-  \(place.coordinate.latitude)")
                print("Place ID longitude:- \(place.coordinate.longitude)")
                self.kDestinationLat = "\(place.coordinate.latitude)"
                self.kDestinationLong = "\(place.coordinate.longitude)"
             //  self.getAddressFromLatLon(pdblLatitude: "\(place.coordinate.latitude)" ,withLongitude: "\(place.coordinate.longitude)")
            } else {
                print("No place details for \(pPlaceID)")
            }
        })
    }
    

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        let fields: GMSPlaceField = GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
//                                                    UInt(GMSPlaceField.placeID.rawValue) |
//                                                    UInt(GMSPlaceField.coordinate.rawValue) |
//                                                    GMSPlaceField.addressComponents.rawValue |
//                                                    GMSPlaceField.formattedAddress.rawValue)
//        //   autocompleteController.placeFields = fields
//        viewController.placeFields = fields
//        print("Place name: \(place.name ?? "")")
//        print("Place ID: \(place.placeID ?? "")")
//        print("Place Latitude: \(place.coordinate.latitude)")
//        print("Place Longitude: \(place.coordinate.longitude)")
//        print("Place attributions: \(String(describing: place.attributions))")
//        GetPlaceDataByPlaceID(pPlaceID: place.placeID ?? "")
//        print("Drop Lat : \(place.coordinate.latitude)")
//        self.dropLat = String(describing: place.coordinate.latitude)
//        self.dropLong = String(describing: place.coordinate.longitude)
//        self.dropAddress = place.name ?? ""
//        self.dropAddress_lbl.text = place.name ?? ""
//        destinationUpdateApi()
//        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
//    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
//        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//        let lat: Double = Double("\(pdblLatitude)")!
//        let lon: Double = Double("\(pdblLongitude)")!
//        let ceo: CLGeocoder = CLGeocoder()
//        center.latitude = lat
//        center.longitude = lon
//
//        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//        ceo.reverseGeocodeLocation(loc, completionHandler:
//                                    {(placemarks, error) in
//                                        if (error != nil)
//                                        {
//                                            self.showAlert("Driver RideshareRates", message: error!.localizedDescription)
//                                        }
//                                        let pm = placemarks! as [CLPlacemark]
//
//                                        if pm.count > 0 {
//                                            let pm = placemarks![0]
//                                            var addressString : String = ""
//                                            if pm.subLocality != nil {
//                                                addressString = addressString + pm.subLocality! + ", "
//                                            }
//                                            if pm.thoroughfare != nil {
//                                                addressString = addressString + pm.thoroughfare! + ", "
//                                            }
//                                            if pm.locality != nil {
//                                                addressString = addressString + pm.locality! + ", "
//                                            }
//                                            if pm.administrativeArea != nil {
//                                                addressString = addressString + pm.administrativeArea! + " "
//                                            }
//                                            if pm.country != nil {
//                                                addressString = addressString + pm.country! + ", "
//                                            }
//                                            if pm.postalCode != nil {
//                                                addressString = addressString + pm.postalCode! + " "
//                                            }
//                                            print(addressString)
//                                            self.dropAddress_lbl.text = addressString
//                                        }
//                                    })
//    }
}

//MARK:- Web Api
extension SetDestinationViewController{
    func destinationUpdateApi(){
        let param = ["destination_lat": dropLat,"destination_long": dropLong ] as [String : Any]
        print(param)
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "set_destination_location", params: param,authRequired: true) { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                let msg = (value["message"] as? String ?? "")
                if ((value["status"] as? Int ?? 0) == 1){
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.showAlert("Driver RideshareRates", message: msg)
                }
            }
        }
    }
}
