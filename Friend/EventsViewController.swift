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
import MGSwipeTableCell
import ChameleonFramework

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    let root = FIRDatabase.database().reference()
    var uid:String = ""
    var friendList = [String]()
    var events = [Event]()

    @IBAction func logout(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableview.delegate = self
        tableview.dataSource = self
        
        uid = (FIRAuth.auth()?.currentUser?.uid)!
        // Query list of user's friends
        getFriendList(completion: {result->() in
            self.friendList = result
            self.friendList.append(self.uid)
            print("============")
            print(self.friendList)
            self.pullEvents(completion: {result2->() in
                self.events = result2
                print("-=-=-=-=-=-=-=-")
                print(self.events)
                self.tableview.reloadData()
            })
        })
    }
    func pullEvents(completion:@escaping ([Event])->()) {
        for friend_uid in friendList {
            eventsQuery(friend_uid: friend_uid, completion: {result->() in
                self.events += result
                completion(self.events)
            })
        }
    }
    func eventsQuery(friend_uid: String, completion:@escaping ([Event])->()) {
        let path = "posts/post_id"
        let eventsRef = root.child(path)
        var eventsTemp = [Event]()
        eventsRef.queryOrdered(byChild: "sender_uid").queryEqual(toValue: friend_uid).observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                eventsTemp.append(Event(
                    event_id: child.key,
                    text: ((child.value as? NSDictionary)?["post_message"] as? String)!,
                    type: "dining",
                    host: friend_uid,
                    post_time: ((child.value as? NSDictionary)?["post_time"] as? String)!,
                    isInterested: false, // change these values later
                    isHost: false
                ))
            }
            completion(eventsTemp)
        })
    }
    func getFriendList(completion:@escaping ([String])->()) {
        let path = "users/uid/"+uid+"/friends"
        let friends = root.child(path)
        friends.queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            var friendListTemp = [String]()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                friendListTemp.append((child.value! as? String)!)
            }
            completion(friendListTemp)
        })
    }
    
    // MARK: - UITableViewDataSource
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return events.count+1
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cellIdentifier = "AddEventCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UITableViewCell
            return cell
        }
        
        let cellIdentifier = "EventsTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EventsTableViewCell
        
        // Fetches the appropriate event for the data source layout.
        let curr = events[indexPath.row-1]
        
        // Configure the cell
        cell.event_text.text = curr.text
        cell.name.text = curr.host
        cell.post_time.text = curr.post_time
        
        cell.rightButtons = [MGSwipeButton(title: "Interested", backgroundColor: UIColor.blue.flatten(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
                // Send host a notification that user is interested
                self.markInterest(event_id: self.events[indexPath.row-1].event_id) {_ in
                    
                }
                return true
            })
            ,MGSwipeButton(title: "Chat",backgroundColor: UIColor.green.flatten(), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                // Segue user to chatroom
                return true
            })]
        cell.rightSwipeSettings.transition = MGSwipeTransition.border

        
        return cell
    }
    func markInterest(event_id: String, completion:@escaping (Bool)->()) {
        // Add a pending user
        let path = "posts/post_id/\(event_id)/pending"
        let ref = root.child(path)
        let pending = [uid:["name":"Visitor"]]
        ref.setValue(pending)
        
        // Notifiy host that a user is interested
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        } else {
            return UITableViewAutomaticDimension
        }
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
