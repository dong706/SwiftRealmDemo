//
//  TopStoriesDao.swift
//  RealDemo
//
//  Created by edz on 2019/4/17.
//  Copyright © 2019年 edz. All rights reserved.
//

import UIKit
import RealmSwift

class TopStoriesDao: NSObject {
    static let instance = TopStoriesDao()
    private let queue = DispatchQueue.init(label: "jm.realm.saveTopStory")
    //MARK 有主键更新数据
    func saveTopStoryToDB(topStory:StoryModel) -> Void{
        queue.async {
            let realm = try! Realm()
            try! realm.write {
                realm.add(self.getTopStoryDBModel(story: topStory), update: true)
            }
        }
        
    }
    
    //MARK 添加多条数据
    func saveTopStoriesToDB(topStories:[StoryModel]) {
        queue.async {
            let realm = try! Realm()
            try! realm.write {
                for story in topStories {
                    if let topStoryDBModel = realm.object(ofType: TopStoryDBModel.self, forPrimaryKey: story.id) {
                        print("update topStory title \(story.title)")
                        topStoryDBModel.ga_prefix = story.ga_prefix
                        topStoryDBModel.type = story.type
                        topStoryDBModel.title = story.title
                        topStoryDBModel.images = story.images
                        realm.add(topStoryDBModel, update: true)
                    } else {
                        print("save topStory title \(story.title)")
                        realm.add(self.getTopStoryDBModel(story: story), update: true)
                    }
                    
                }
            }
        }
    }
    
    //MARK 获取一条数据
    func getTopStore(id:Int) -> StoryModel?{
        let realm = try! Realm()
        let results = realm.objects(TopStoryDBModel.self).filter("id = \(id)")
        if(results.count > 0){
            if let storyDBModel = results.first {
                return self.getTopStoryModel(storyDBModel: storyDBModel)
            }
        }
        return nil
    }
    
    //MARK 获取所有数据
    func getAllStories(result:@escaping([StoryModel])->()) {
        let realm = try! Realm()
        let results = realm.objects(TopStoryDBModel.self)
        var array:[StoryModel] = []
        if(results.count > 0){
            for storyDBModel in results {
                 array.append(self.getTopStoryModel(storyDBModel: storyDBModel))
            }
        }
        result(array)
    }
    
    //数据手动分页
    func getStories(count:Int,id:Int,result:@escaping([StoryModel])->()) {
        let realm = try! Realm()
        let results = realm.objects(TopStoryDBModel.self)
        var array:[StoryModel] = []
        if(results.count > 0){
            if id == 0 {
                for i in 0..<count {
                    if i + i > results.count {
                        break
                    }
                    let storyDBModel = results[i]
                    array.append(self.getTopStoryModel(storyDBModel: storyDBModel))
                }
            } else {
                var storyIndex = 0
                for (index,storyDBModel) in results.enumerated() {
                    if storyDBModel.id == id {
                        storyIndex = index
                        break
                    }
                }
                
                if storyIndex == 0 {
                    //表里面没有这条数据，返回空
                } else {
                    for  i in storyIndex..<(storyIndex + count) {
                        if i + i > results.count {
                            break
                        }
                        let storyDBModel = results[i]
                        let story = self.getTopStoryModel(storyDBModel: storyDBModel)
                        array.append(story)
                    }
                }
            }
        }
        result(array)
    }
    
    //MARK 更新整个模型
    func updateStore(story:StoryModel) {
        self.saveTopStoryToDB(topStory: story)
    }
    
    //MARK 更新某个字段
    func updateStore(id:Int,title:String) {
        let realm = try! Realm()
        let results = realm.objects(TopStoryDBModel.self).filter("id = \(id)")
        if(results.count > 0){
            if let storyDBModel = results.first {
                storyDBModel.title = title
            }
        }
    }
    
    //MARK 删除一条数据
    func deleteStory(id:Int) {
        let realm = try! Realm()
        let results = realm.objects(TopStoryDBModel.self).filter("id = \(id)")
        if(results.count > 0){
            try! realm.write {
                realm.delete(results)
            }
        }
    }
    
    //删除多条数据
    func deleteAllStory() {
        let realm = try! Realm()
        let results = realm.objects(TopStoryDBModel.self)
        if(results.count > 0){
            try! realm.write {
                realm.delete(results)
            }
        }
    }
}

extension TopStoriesDao {
    func getTopStoryModel(storyDBModel:TopStoryDBModel) ->StoryModel {
        let story = StoryModel()
        story.id = storyDBModel.id
        story.ga_prefix = storyDBModel.ga_prefix
        story.type = storyDBModel.type
        story.title = storyDBModel.title
        story.images = storyDBModel.images
        return story
    }
    
    func getTopStoryDBModel(story:StoryModel) ->TopStoryDBModel {
        let topStoryDBModel = TopStoryDBModel()
        topStoryDBModel.id = story.id
        topStoryDBModel.ga_prefix = story.ga_prefix
        topStoryDBModel.type = story.type
        topStoryDBModel.title = story.title
        topStoryDBModel.images = story.images
        return topStoryDBModel
    }
}
