//
//  PaymentHistoryViewControllerCell.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit

class PaymentHistoryViewControllerCell: UITableViewCell {
    @IBOutlet weak var pickUpAddress_lbl: UILabel!
    @IBOutlet weak var dropAddress_lbl: UILabel!
    @IBOutlet weak var driverName_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var amount_lbl: UILabel!
    @IBOutlet weak var distance_lbl: UILabel!

    @IBOutlet weak var mTipAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //MARK:- default 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
