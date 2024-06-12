//
//  TipPopupVC.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//


import UIKit

protocol tipPopup{
    func tip(amount : String?)
}
class TipPopupVC: UIViewController {

    @IBOutlet weak var mTextFLD: UITextField!
    var delegate : tipPopup?
    override func viewDidLoad() {
        super.viewDidLoad()
        mTextFLD.setLeftPaddingPoints(40)
        mTextFLD.layer.borderWidth = 1
        mTextFLD.layer.borderColor = #colorLiteral(red: 0.9921568627, green: 0.9607843137, blue: 0.6901960784, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func mSkipBTN(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
   
    @IBAction func mDoneBTN(_ sender: Any) {
        if mTextFLD.text != ""{
            self.dismiss(animated: true, completion: {
                self.delegate?.tip(amount: self.mTextFLD.text)
            })
        }else{
            self.showAlert("Rider RideshareRates", message: "Please enter tip amount")
        }
        
    }
    
}
