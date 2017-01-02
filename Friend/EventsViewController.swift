//
//  EventsViewController.swift
//  Pods
//
//  Created by Minh Tran on 1/1/17.
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var uid:String = ""
    
    let root = FIRDatabase.database().reference()

    @IBAction func logout(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        uid = (FIRAuth.auth()?.currentUser?.uid)!
        // Query list of user's friends
        queryFriends()
    }
    func queryFriends() {
        let users = root.child("users/uid")
        let friends =
    }
    
    // MARK: - UITableViewDataSource
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return nil
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
