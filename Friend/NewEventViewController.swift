//
//  NewEventViewController.swift
//  Friend
//
//  Created by Minh Tran on 1/4/17.
//  Copyright © 2017 Minh. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let yourImage = UIImage(named: "new_event_back.jpg")
        let imageview = UIImageView(image: yourImage)
        self.view.addSubview(imageview)

        // Do any additional setup after loading the view.
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
