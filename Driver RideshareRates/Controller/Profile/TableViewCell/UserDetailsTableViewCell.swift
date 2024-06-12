//
//  UserDetailsTableViewCell.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit

protocol UserDetailsTableViewCellDelegate : AnyObject {
    func inputEdit(flag : Bool,with name: String?, phone: String?, for cell: UserDetailsTableViewCell)
}

class UserDetailsTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    
    @IBOutlet weak var userProfileImg: SetImageView!
    @IBOutlet weak var name_txtField: SetTextField!
    @IBOutlet weak var email_txtField: SetTextField!
    @IBOutlet weak var mobileNo_txtField: SetTextField!
    @IBOutlet weak var tapProfileImg_btn: UIButton!
    weak var textFieldDelegate: UserDetailsTableViewCellDelegate?

    
    //MARK:- Default Func
    override func awakeFromNib() {
        super.awakeFromNib()
        email_txtField.isUserInteractionEnabled = false

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension UserDetailsTableViewCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.inputEdit(flag: true, with: self.name_txtField.text, phone: self.mobileNo_txtField.text, for: self)
    }
}
