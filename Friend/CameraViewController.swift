//
//  CameraViewController.swift
//  
//
//  Created by Minh Tran on 1/7/17.
//
//

import UIKit
import AVFoundation
import Fusuma

class CameraViewController: UIViewController, FusumaDelegate {
    
    let fusuma = FusumaViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fusuma.delegate = self
        fusuma.hasVideo = true // If you want to let the users allow to use video.
        self.tabBarController?.tabBar.isHidden = true
        self.present(fusuma, animated: true, completion: nil)
        
    }
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage) {
        let readableObject = image as? AVMetadataMachineReadableCodeObject
        let data = readableObject?.stringValue;
        
        
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(_ image: UIImage) {    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
