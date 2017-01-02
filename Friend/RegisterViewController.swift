//
//  RegisterViewController.swift
//  
//
//  Created by Minh Tran on 1/1/17.
//
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    
    @IBAction func createAccount(_ sender: Any) {
        if validFields() {
        FIRAuth.auth()!.createUser(withEmail: email.text!, password: password.text!) { user, error in
            if error == nil {
                FIRAuth.auth()!.signIn(withEmail: self.email.text!, password: self.password.text!)
            }
        }}
    }
    func validFields() -> Bool {
        if password.text! == "" {return false}
        if passwordConfirm.text! == "" {return false}
        if password.text! != passwordConfirm.text {return false}
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.email.delegate = self
        self.password.delegate = self
        self.passwordConfirm.delegate = self
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
