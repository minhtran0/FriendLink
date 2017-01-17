//
//  NewEventFormViewController.swift
//  
//
//  Created by Minh Tran on 1/16/17.
//
//

import UIKit
import Eureka
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth

class NewEventFormViewController: FormViewController {
    
    let root = FIRDatabase.database().reference()
    var uid:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        uid = (FIRAuth.auth()?.currentUser?.uid)!
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addEvent))

        
        form = Section("")
            +++ Section("")
            <<< TextRow("Title") {
                $0.title = "Title"
                $0.placeholder = "Title"
            }
            +++ Section("")
            <<< DateTimeInlineRow("Starts") {
                $0.title = $0.tag
                $0.value = Date().addingTimeInterval(60*60*24)
                }
                .onChange { [weak self] row in
                    let endRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Ends")
                    if row.value?.compare(endRow.value!) == .orderedDescending {
                        endRow.value = Date(timeInterval: 60*60*24, since: row.value!)
                        endRow.cell!.backgroundColor = .white
                        endRow.updateCell()
                    }
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        cell.datePicker.datePickerMode = .dateAndTime
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
            
            <<< DateTimeInlineRow("Ends"){
                $0.title = $0.tag
                $0.value = Date().addingTimeInterval(60*60*25)
                }
                .onChange { [weak self] row in
                    let startRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Starts")
                    if row.value?.compare(startRow.value!) == .orderedAscending {
                        row.cell!.backgroundColor = .red
                    }
                    else{
                        row.cell!.backgroundColor = .white
                    }
                    row.updateCell()
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        cell.datePicker.datePickerMode = .dateAndTime
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
            +++ Section("")
            <<< TextAreaRow("Text") {
                $0.placeholder = "Text"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
        }
    }
    func addEvent() {
        let path = "posts/post_id"
        print("HI++++")
        let title = form.rowBy(tag: "Title")?.baseValue
        let text = form.rowBy(tag: "Text")?.baseValue
        print("OK=====")
        let startDate = form.rowBy(tag: "Starts")?.baseValue
        let endDate = form.rowBy(tag: "Ends")?.baseValue
        print(startDate)
        
        if title as? String != "" {
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.short
            formatter.timeStyle = .short
            let startdateString = formatter.string(from: (startDate as? Date)!)
            let enddateString = formatter.string(from: (endDate as? Date)!)
            let currdateString = formatter.string(from: Date())
            
            var event = [String:Any]()
            event["post_title"] = title as? String
            event["post_message"] = text as? String
            event["activity_time"] = startdateString
            event["post_time"] = currdateString
            event["author_uid"] = uid
            event["author_name"] = "Visitor"
            event["companion"] = [uid:["name":"Visitor"]]
            event["pending"] = ["0":["name":"0"]]
            
            let eventsRef = root.child(path)
            let ref = eventsRef.childByAutoId()
            ref.setValue(event)
        }
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
