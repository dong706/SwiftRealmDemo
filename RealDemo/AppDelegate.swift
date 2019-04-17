//
//  AppDelegate.swift
//  RealDemo
//
//  Created by edz on 2019/4/16.
//  Copyright © 2019年 edz. All rights reserved.
//

import UIKit
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var realm_version = 1

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configRealm()
        
        return true
    }

    func configRealm() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            encryptionKey: Data(bytes: []), //设置加密key
            schemaVersion: UInt64(realm_version), //数据库版本号 如果数据库因为表字段修改crash 只需要realm_version 加 1 就可以了，比如realm_version = 1， 升级之后设为2即可，系统会自动迁移添加删除字段，不能设置比当前小的数据，否则会一直crash
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                  
                }
        },shouldCompactOnLaunch: { totalBytes, usedBytes in //压缩数据库
            let oneHundredMB = 100 * 1024 * 1024
            return (totalBytes > oneHundredMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
        })
        do {
            _ = try Realm()
        } catch _ {
            
        }
    }


}

