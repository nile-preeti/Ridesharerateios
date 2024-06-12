//
//  PaymentButtonVCCell.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import UIKit

class PaymentButtonVCCell: UITableViewCell {
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var addCardBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
