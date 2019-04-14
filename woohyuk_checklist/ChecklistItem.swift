//
//  ChecklistItem.swift
//  woohyuk_checklist
//
//  Created by user on 12/04/2019.
//  Copyright © 2019 woohyuk. All rights reserved.
//

import Foundation
class ChecklistItem:NSObject{
    var text=""
    var checked = false
    func toggleChecked(){
        checked = !checked
    }
}
