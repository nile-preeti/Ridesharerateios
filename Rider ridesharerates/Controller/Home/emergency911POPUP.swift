//
//  emergency911POPUP.swift
//  Rider ridesharerates
//
//  Created by malika on 30/04/24.
//

import UIKit
import CoreTelephony
class emergency911POPUP: UIViewController {

    @IBOutlet  var currentloc : UILabel!
    @IBOutlet weak var swipetocallbtn: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  arrowImageView.alpha = 0
                
        currentloc.text = NSUSERDEFAULT.value(forKey: kpCurrentAdd) as! String
       // ("\(place.formattedAddress!)", forKey: kCurrentAddress)
        
                // Add pan gesture recognizer to the button
                let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipetocallbtn.addGestureRecognizer(swipeGestureRecognizer)

       // let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
      //  swipetocallbtn.addGestureRecognizer(swipeGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @objc func handleSwipeGesture(_ sender: UIPanGestureRecognizer) {
           if sender.state == .changed {
               let translation = sender.translation(in: view)
               // Check if the swipe is towards the right
               if translation.x > 0 {
                   // Show the arrow icon
                   UIView.animate(withDuration: 0.3) {
                       self.arrowImageView.alpha = 1
                   }
                   
                   // Move the arrow icon along with the swipe
                   let xOffset = min(translation.x, 50) // Adjust the maximum offset as needed
                   arrowImageView.transform = CGAffineTransform(translationX: xOffset, y: 0)
               }
           } else if sender.state == .ended {
               let translation = sender.translation(in: view)
               // Check if the swipe is towards the right and passed a certain threshold
               if translation.x > 50 {
                   // Perform call action
                   makeCall()
               }
               
               // Reset arrow icon position and hide it
//               UIView.animate(withDuration: 0.3) {
//                   self.arrowImageView.alpha = 0
//                   self.arrowImageView.transform = .identity
//               }
           }
       }
       
      
  
       // Make a call
       func makeCall() {
           if let url = URL(string: "tel://911") {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
       }
    
    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: true)
      //  self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
