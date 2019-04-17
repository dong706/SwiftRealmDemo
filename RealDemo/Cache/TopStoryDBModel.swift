//
//  TopStoryDBModel.swift
//  RealDemo
//
//  Created by edz on 2019/4/17.
//  Copyright © 2019年 edz. All rights reserved.
//

import UIKit

import RealmSwift
class TopStoryDBModel: Object {
    @objc dynamic var id:Int = 0
    @objc dynamic var type:Int = 0
    @objc dynamic var ga_prefix:Int = 0
    @objc dynamic var images = ""
    @objc dynamic var title = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
