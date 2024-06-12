//
//  LaunchVC.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit
import AVKit

class LaunchVC: UIViewController {
    
    @IBOutlet var mVideoV: UIView!
   // var avPlayer: AVPlayer!
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Path to the local video file
        let videoPath = Bundle.main.path(forResource: "intorrideshare", ofType: "mp4")
        let videoURL = URL(fileURLWithPath: videoPath!)
        
        // Create an AVPlayerItem
        let playerItem = AVPlayerItem(url: videoURL)
        
        // Create an AVPlayer with the AVPlayerItem
        player = AVPlayer(playerItem: playerItem)
        
        // Create an AVPlayerLayer and add it to the view's layer
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer!)
        
        // Play the video
        player?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        // Observe the AVPlayerItemDidPlayToEndTime notification
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
    }
    @objc func appDidEnterBackground() {
           // Pause the video when the app enters the background
           player?.pause()
       }

       @objc func appWillEnterForeground() {
           // Resume the video when the app comes back to the foreground
           player?.play()
       }

       // ... your existing code ...
       
       deinit {
           // Remove observers when the view controller is deallocated
           NotificationCenter.default.removeObserver(self)
       }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update the frame of the AVPlayerLayer when the view's bounds change
        playerLayer?.frame = view.bounds
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    
    @objc func videoDidFinishPlaying(_ notification: Notification) {
        // Remove the observer for the AVPlayerItemDidPlayToEndTime notification
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        
        
        let transition: CATransition = CATransition()
        transition.duration = 2.0
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: nil)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
         //   self.navigationController?.pushViewController(vc, animated: false)
        
        //     self.navigationController?.pushViewController(viewController, animated: false)
        //   navigationController?.pushViewController(vc, animated: true)
       
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}
