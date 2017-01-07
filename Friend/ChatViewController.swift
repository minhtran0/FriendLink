//
//  ChatViewController.swift
//  Friend
//
//  Created by Minh Tran on 1/4/17.
//  Copyright © 2017 Minh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    let root = FIRDatabase.database().reference()
    var messages = [JSQMessage]()
    var messageRef: FIRDatabaseReference?
    
    var post_id: String = "eiwogeiwogh"
    var chat_room: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.senderId = FIRAuth.auth()?.currentUser?.uid
        self.senderDisplayName = "michael"

        // Do any additional setup after loading the view.
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero

        // Find post id and observe for new messages
        findChatRoom(completion: {result->() in
            self.chat_room = result
            self.observeMessages()
        })
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef?.childByAutoId()
        let messageItem = [
            "sender_uid": senderId!,
            "sender_name": senderDisplayName!,
            "text": text!,
            "send_time": NSDate() as? String,
            ]
        
        itemRef?.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
    }
    
    private func observeMessages() {
        let path = "messages/chat_room/\(chat_room)/message_id"
        messageRef = root.child(path)
        let messageQuery = messageRef?.queryLimited(toLast:25)
        var newMessageRefHandle = messageQuery?.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! NSDictionary
            if let id = messageData["sender_uid"] as! String!, let name = messageData["sender_name"] as! String!, let text = messageData["text"] as! String!, text.characters.count > 0 {
                self.addMessage(withId: id, name: name, text: text)
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
    }
    
    func findChatRoom(completion:@escaping (String)->()) {
        let path = "messages/chat_room"
        let chatRef = root.child(path)
        chatRef.queryOrdered(byChild: "post_id").queryEqual(toValue: post_id).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                print(child.key)
                completion(child.key)
                break
            }
        })

    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    // Setting up bubbles for chat
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    // Removing Avatars
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    // Override message text color
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
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
