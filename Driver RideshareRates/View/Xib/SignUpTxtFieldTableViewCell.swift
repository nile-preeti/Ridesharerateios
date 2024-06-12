//
//  SignUpTxtFieldTableViewCell.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit
@objc protocol TableViewDelegate: NSObjectProtocol{
    func afterClickingReturnInTextField(cell: SignUpTxtFieldTableViewCell)
}
class SignUpTxtFieldTableViewCell: UITableViewCell,UITextFieldDelegate {

    //MARK:- OUTLETS
    
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var email_txtField: UITextField!
    @IBOutlet weak var password_txtField: SetTextField!
    @IBOutlet weak var cnfPass_txtField: SetTextField!
    @IBOutlet weak var mobile_txtField: SetTextField!
    @IBOutlet weak var selectVehcileMake_txtField: SetTextField!
    @IBOutlet weak var notKnow_txtField: SetTextField!
    @IBOutlet weak var selectVehicleYear_txtField: SetTextField!
    @IBOutlet weak var notKnow2_txtField: SetTextField!
    @IBOutlet weak var vehicleNo_txtField: SetTextField!
    @IBOutlet weak var vehicleColor_txtField: SetTextField!
    
    weak var tableViewDelegate: TableViewDelegate?

    //MARK:- Default Func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var validateTxtField : (Bool)-> Bool = {_ in
    
        return true
    }
       @IBAction func tapHerre(_ sender: UITextField) {
           tableViewDelegate?.responds(to: #selector(TableViewDelegate.afterClickingReturnInTextField(cell:)))
           tableViewDelegate?.afterClickingReturnInTextField(cell: self)
       }
       // UITextField Defaults delegates
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        name_txtField.resignFirstResponder()
        email_txtField.resignFirstResponder()
           return true
       }
    //MARK:- UITextField Defaults delegates
       func textFieldDidEndEditing(_ textField: UITextField) {
        name_txtField = textField
        email_txtField = textField
       }
}
