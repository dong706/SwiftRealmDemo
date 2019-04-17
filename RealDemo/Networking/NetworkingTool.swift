//
//  NetworkingTool.swift
//  NetWorkingTool
//
//  Created by edz on 2019/4/15.
//  Copyright © 2019年 edz. All rights reserved.
//

import UIKit
import HandyJSON
import Alamofire

class NetworkingTool: NSObject {
    static let instance = NetworkingTool()
    private var host = "http://news-at.zhihu.com/api/"
    private var heade: [String : String] =  ["Content-Type":"application/x-www-form-urlencoded"]
    
    func sendRequest<T:HandyJSON>(path:String,parameters:[String:Any],method:HTTPMethod = .get ,_ type:T.Type, success:@escaping(_ response:[T]?)->(),failture:@escaping(_ error:Error)->()) {
        let url = host + path
        Alamofire.request(url, method: method, parameters: parameters, headers: heade).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value {
                    let dict = value as! [String:Any]
                    let responseModel = JSONDeserializer<BaseResponse<T>>.deserializeFrom(dict: dict)
                    let model = responseModel?.stories
                    success(model)
                }
            case .failure(let error):
                failture(error)
            }
        }
    }
    
    func sendRequest1<T:HandyJSON>(path:String,parameters:[String:Any],method:HTTPMethod = .get ,_ type:T.Type, success:@escaping(_ response:BaseResponse<T>?)->(),failture:@escaping(_ error:Error)->()) {
        let url = host + path
        Alamofire.request(url, method: method, parameters: parameters, headers: heade).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value {
                    let dict = value as! [String:Any]
                    let responseModel = JSONDeserializer<BaseResponse<T>>.deserializeFrom(dict: dict)
                    success(responseModel)
                }
            case .failure(let error):
                failture(error)
            }
        }
    }
}
