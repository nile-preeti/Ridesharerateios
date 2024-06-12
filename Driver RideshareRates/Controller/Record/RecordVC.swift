//
//  RecordVC.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit

class RecordVC: UIViewController {
    @IBOutlet var recordingTimeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "Record "
        // Do any additional setup after loading the view.
    }
    
    @IBAction func playBtnAction(_ sender: Any) {
    }
    @IBAction func recordBtnAction(_ sender: Any) {
    }
}
