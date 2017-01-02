//
//  Event.swift
//  Friend
//
//  Created by Minh Tran on 1/2/17.
//  Copyright © 2017 Minh. All rights reserved.
//

import Foundation

struct Event {
    var event_id: String
    var text: String
    var type: String
    var host: String
    var post_time: String
    
    init(event_id:String, text:String, type:String, host:String, post_time:String) {
        self.event_id = event_id
        self.text = text
        self.type = type
        self.host = host
        self.post_time = post_time
    }
}
