//
//  StoryDao.swift
//  RealDemo
//
//  Created by edz on 2019/4/17.
//  Copyright © 2019年 edz. All rights reserved.
//

import UIKit
import RealmSwift

class StoryDao: NSObject {
    static let instance = StoryDao()
    //更新操作 没有主键，去重
    private let queue = DispatchQueue.init(label: "jm.realm.saveStory")
    func saveStoryToDB(story:StoryModel) {
        queue.async {
            let realm = try! Realm()
            let results = realm.objects(StoryDBModel.self).filter("id = \(story.id)")
            if(results.count == 0){
                try! realm.write {
                    let storyDBModel = StoryDBModel()
                    storyDBModel.id = story.id
                    storyDBModel.ga_prefix = story.ga_prefix
                    storyDBModel.type = story.type
                    storyDBModel.title = story.title
                    storyDBModel.images = story.images
                    realm.add(storyDBModel)
                }
            } else {
                try! realm.write {
                    if let storyDBModel = results.first {
                        storyDBModel.id = story.id
                        storyDBModel.ga_prefix = story.ga_prefix
                        storyDBModel.type = story.type
                        storyDBModel.title = story.title
                        storyDBModel.images = story.images
                    }
                }
            }
        }
    }
    
    //不去重直接存一条数据
    func saveStoryToDB1(story:StoryModel) {
        queue.async {
            let realm = try! Realm()
            try! realm.write {
                let storyDBModel = StoryDBModel()
                storyDBModel.id = story.id
                storyDBModel.ga_prefix = story.ga_prefix
                storyDBModel.type = story.type
                storyDBModel.title = story.title
                storyDBModel.images = story.images
                realm.add(storyDBModel)
            }
        }
    }
    
    //没有设置主键，直接添加数据
    func saveStoryToDB(stories:[StoryModel]) {
        queue.async {
            let realm = try! Realm()
            try! realm.write {
                for story in stories {
                    print("save story title \(story.title)")
                    let storyDBModel = StoryDBModel()
                    storyDBModel.id = story.id
                    storyDBModel.ga_prefix = story.ga_prefix
                    storyDBModel.type = story.type
                    storyDBModel.title = story.title
                    storyDBModel.images = story.images
                    realm.add(storyDBModel)
                }
            }
        }
    }
    
    //MARK 获取所有数据
    func getAllStories(result:@escaping([StoryModel])->()) {
        let realm = try! Realm()
        let results = realm.objects(StoryDBModel.self)
        var array:[StoryModel] = []
        if(results.count > 0){
            for storyDBModel in results {
                let story = StoryModel()
                story.id = storyDBModel.id
                story.ga_prefix = storyDBModel.ga_prefix
                story.type = storyDBModel.type
                story.title = storyDBModel.title
                story.images = storyDBModel.images
                array.append(story)
            }
        }
        result(array)
    }
    
}
