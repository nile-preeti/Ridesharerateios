//
//  AcceptedReqTableViewCell.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit

class AcceptedReqTableViewCell: UITableViewCell {
    
    //MARK:- OUTLETS
    @IBOutlet weak var pickUpAddress_lbl: UILabel!
    
    @IBOutlet weak var dropAddress_lbl: UILabel!
    
    @IBOutlet weak var time_lbl: UILabel!
    @IBOutlet weak var amount_lbl: UILabel!

    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var driverName_lbl: UILabel!
    
    @IBOutlet weak var startRide: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var trackBtn: UIButton!
    
  //  @IBOutlet weak var startRecordingBtn: UIButton!
    @IBOutlet weak var navigateBtn: UIButton!
    @IBOutlet weak var completeRideBtn: UIButton!
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var CompleteRideView: UIStackView!
    
    var callCheckBox : ((IndexPath) -> Void)?
    var index = IndexPath()

    //MARK:- Default Func
    override func awakeFromNib() {
        super.awakeFromNib()
        showStackView(show: false)
        // Initialization code
    }
    @IBAction func completeBtnAction(_ sender: Any) {
        callCheckBox?(self.index)
      }
    func configure(indexPath:IndexPath){
          self.index = indexPath
      }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK:- stack view
    func showStackView(show: Bool) {
        if show {
            CompleteRideView.isHidden = false
            mainStackView.isHidden = true
            CompleteRideView.isHidden = !show
//            startRide.isUserInteractionEnabled = false
//            callBtn.isUserInteractionEnabled = false
//            trackBtn.isUserInteractionEnabled = false

        } else {
            CompleteRideView.isHidden = true
            mainStackView.isHidden = false
            CompleteRideView.isHidden = !show
        }
    }
}
