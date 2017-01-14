//
//  QRCodeViewController.swift
//  Friend
//
//  Created by Minh Tran on 1/13/17.
//  Copyright © 2017 Minh. All rights reserved.
//

import UIKit
import QRCode
import FirebaseAuth

class QRCodeViewController: UIViewController {

    @IBOutlet weak var code: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        var qrCode = QRCode(uid)
        qrCode?.size = CGSize(width: 343, height: 343)
        code.image = qrCode?.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
