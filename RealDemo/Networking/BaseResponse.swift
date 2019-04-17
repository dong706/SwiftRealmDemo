//
//  BaseResponse.swift
//  NetWorkingTool
//
//  Created by edz on 2019/4/15.
//  Copyright © 2019年 edz. All rights reserved.
//

import UIKit
import HandyJSON
class BaseResponse<T:HandyJSON>:HandyJSON {
    var date:Int = 0
    var stories = [T]()
    var top_stories = [T]()
    public required init() {
        
    }
}

class RGEmptyModel: HandyJSON {
    public required init(){}
}

class StoryModel: HandyJSON {
    var type :Int = 0
    var images :String = ""
    var id :Int = 0
    var ga_prefix :Int = 0
    var title :String = ""
    public required init(){}
}

