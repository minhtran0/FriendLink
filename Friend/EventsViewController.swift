//
//  EventsViewController.swift
//  Pods
//
//  Created by Minh Tran on 1/1/17.
//
//

import UIKit
import FirebaseAuth
import Firebase

class EventsViewController: UIViewController {

    @IBAction func logout(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
