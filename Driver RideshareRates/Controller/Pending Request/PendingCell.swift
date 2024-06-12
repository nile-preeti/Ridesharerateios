//
//  PendingCell.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit

class PendingCell: UITableViewCell {
    @IBOutlet weak var fromAddressLbl: UILabel!
    @IBOutlet weak var toAddressLbl: UILabel!
//    @IBOutlet weak var totalDistanceLbl: UILabel!
//    @IBOutlet weak var totalFareLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
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
