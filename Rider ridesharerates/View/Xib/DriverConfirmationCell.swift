//
//  DriverConfirmationCell.swift
//  Rider ridesharerates
//
//  Created by malika on 27/09/23.
//

import UIKit

class DriverConfirmationCell: UITableViewCell {
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet weak var waitingBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var modalLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var imageVw: UIImageView!
    //MARK:- Default Func
    var timer: Timer?
    var time = 1.0
    var elapsedTime: TimeInterval = 0
    let totalTime: TimeInterval = 120
   
    var progress = 0.0
    override func awakeFromNib() {
        super.awakeFromNib()
        waitingBtn.layer.borderWidth = 1
        
        waitingBtn.layer.borderColor = #colorLiteral(red: 0.9921568627, green: 0.9607843137, blue: 0.6901960784, alpha: 1)
        progressBar.progressTintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        progressBar.progress = Float(progress)
        startProgressBar()
    }
    //MARK:- Default Func
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func startProgressBar() {
       
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgressBar() {
        elapsedTime += 1
        let progress = Float(elapsedTime / totalTime)
        progressBar.progress = progress
        
        if elapsedTime >= totalTime {
            timer?.invalidate()
          //  self.cancelRideStatus(rideId: kRideId)
            // Progress bar completed, you can perform any additional actions here
        }
    }
    
}
