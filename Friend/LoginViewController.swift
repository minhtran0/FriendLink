//
//  LoginViewController.swift
//  Friend
//
//  Created by Minh Tran on 12/27/16.
//  Copyright © 2016 Minh. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBAction func signinUser(_ sender: Any) {
        if email.text! != "" && password.text! != "" {
            FIRAuth.auth()!.signIn(withEmail: email.text!, password: self.password.text!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.email.delegate = self
        self.password.delegate = self
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        }
    }
    
    // MARK: - UITextfieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationvc = segue.destination
        if let vc = destinationvc as? RegisterViewController {
            if let identifier = segue.identifier {
                
            }
        }
    }
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    

}
