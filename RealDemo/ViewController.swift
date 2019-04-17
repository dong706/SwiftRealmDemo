//
//  ViewController.swift
//  RealDemo
//
//  Created by edz on 2019/4/16.
//  Copyright © 2019年 edz. All rights reserved.
//

import UIKit
import RealmSwift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 150, height: 50))
        btn.backgroundColor = UIColor.red
        btn.setTitle("请求网络数据", for: .normal)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(getNetworkBtnDidClick), for: .touchUpInside)
      
        let btn1 = UIButton(frame: CGRect(x: 100, y: 200, width: 150, height: 50))
        btn1.backgroundColor = UIColor.red
        btn1.setTitle("取本地数据", for: .normal)
        view.addSubview(btn1)
        btn1.addTarget(self, action: #selector(getLocalBtnDidClick), for: .touchUpInside)
        
    }
    
    func sendRequest() {
        let param = [String:Any]()
        NetworkingTool.instance.sendRequest1(path: "4/news/latest", parameters: param, StoryModel.self, success: { (datas) in
            if let model = datas {
                let story = model.stories
                let topStories = model.top_stories
                TopStoriesDao.instance.saveTopStoriesToDB(topStories: topStories)
                StoryDao.instance.saveStoryToDB(stories: story)
                
            }
        }) { (error) in
            
        }
    }
    
    @objc func getNetworkBtnDidClick() {
        self.sendRequest()
    }
    
    @objc func getLocalBtnDidClick() {
        TopStoriesDao.instance.getAllStories { (models) in
            for i in models {
                print("Local topStory model title \(i.title)")
            }
        }
        
        StoryDao.instance.getAllStories { (models) in
            for i in models {
                print("Local story model title \(i.title)")
            }
        }
    }
}

