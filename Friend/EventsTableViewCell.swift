//
//  EventsTableViewCell.swift
//  Pods
//
//  Created by Minh Tran on 1/1/17.
//
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var event_text: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var post_time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
