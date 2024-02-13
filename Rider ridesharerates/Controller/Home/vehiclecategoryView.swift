//
//  vehiclecategoryView.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//


import UIKit

protocol RideStart{
    func RideStart(button:String?)
}

class vehiclecategoryView: UIViewController {
    
    @IBOutlet var mbackButton: UIButton!
    @IBOutlet var mMinB: UIButton!
    @IBOutlet var mViewHeight: NSLayoutConstraint!
    @IBOutlet var mTableV: UITableView!
    
    //   var allData: [Category] = []
    var delegate : RideStart?
    var allData = [VechileData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        vehicleTypeId = ""
        mTableV.reloadData()
        // Do any additional setup after loading the view.
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
        if mMinB.currentImage == UIImage(systemName: "minus.square.fill"){
           // popupheight = "half"
            mViewHeight.constant = 200
            mMinB.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right.circle.fill"), for: .normal)
        }else{
           // popupheight = "full"
            mViewHeight.constant = 500
            mMinB.setImage(UIImage(systemName: "minus.square.fill"), for: .normal)
        }
    }
    
    @IBAction func closeBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.RideStart(button: "close")
        })
      //  self.dismiss(animated: true, completion: nil)
    }
    @IBAction func mBAckBTN(_ sender: Any) {
     //   self.dismiss(animated: true, completion: nil)
        
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
