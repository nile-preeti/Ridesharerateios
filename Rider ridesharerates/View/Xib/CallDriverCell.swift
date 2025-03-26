//
//  CallDriverCell.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import UIKit

class CallDriverCell: UITableViewCell {
    @IBOutlet var mcalldriverLBL: UILabel!
    
    @IBOutlet var mStackview: UIStackView!
    @IBOutlet weak var mPopupMinMaxPopup: UIButton!
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var driverImageView: UIImageView!

    @IBOutlet weak var mPopupVieww: UIView!
    @IBOutlet weak var mViewHeight: NSLayoutConstraint!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var driverRatingLabel: UILabel!
    @IBOutlet weak var callDriverBtn: UIButton!
    @IBOutlet weak var cancelDriverBtn: UIButton!

    @IBOutlet var mAddSTopBTN: UIButton!
    @IBOutlet weak var mUserNAme: UILabel!
    //MARK:- Default Func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.driverImageView.layer.borderWidth = 2
        self.driverImageView.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0.5333333333, blue: 0.3411764706, alpha: 1)
        self.vehicleImageView.layer.borderWidth = 2
        self.vehicleImageView.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0.5333333333, blue: 0.3411764706, alpha: 1)
        
        self.mcalldriverLBL.layer.borderWidth = 1.5
        self.mcalldriverLBL.layer.borderColor = #colorLiteral(red: 1, green: 0.7921568627, blue: 0.1568627451, alpha: 1)
        self.mcalldriverLBL.layer.cornerRadius = 6
        
        driverNameLabel.layer.shadowColor = UIColor.black.cgColor  // Shadow color
           driverNameLabel.layer.shadowOpacity = 1.5                 // Shadow opacity (0.0 to 1.0)
           driverNameLabel.layer.shadowOffset = CGSize(width: 2, height: 2) // Shadow offset (width and height)
           driverNameLabel.layer.shadowRadius = 6                   // Shadow blur radius
           driverNameLabel.layer.masksToBounds = false
        mUserNAme.layer.shadowColor = UIColor.black.cgColor  // Shadow color
        mUserNAme.layer.shadowOpacity = 1.5                  // Shadow opacity (0.0 to 1.0)
        mUserNAme.layer.shadowOffset = CGSize(width: 2, height: 2) // Shadow offset (width and height)
        mUserNAme.layer.shadowRadius = 6                    // Shadow blur radius
        mUserNAme.layer.masksToBounds = false
        // Initialization code
    }
    //MARK:- Default Func
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
