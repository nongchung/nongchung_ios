//
//  HeartService.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 4..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

struct HeartService : APIService {
    static func heartInit(completion: @escaping ([Heart])->Void) {
        let URL = url("/api/bookmark")
        let token = UserDefaults.standard.string(forKey: "token")
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["token" : token!]).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()
                    
                    do {
                        let heartData = try decoder.decode(HeartData.self, from: value)
                        
                        if heartData.message == "Success" {
                            completion(heartData.bmList)
                        }
                        
                    } catch {
                        
                    }
                    //////////////////
                }
                
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    
    static func likeDeleteNetworking(nhIdx: Int, completion: @escaping ()->Void) {
        let URL = url("/api/bookmark")
        
        let userdefault = UserDefaults.standard
        guard let token = userdefault.string(forKey: "token") else { return }
        let body: [String : Int] = [
            "nhIdx" : nhIdx]
        
        Alamofire.request(URL, method: .delete, parameters: body, encoding: JSONEncoding.default, headers: ["token" : token]).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let message = JSON(value)["message"].string
                    
                    if message == "Success to Delete" {
                        completion()
                    }
                }
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
        
        
    }
    
    
    static func likeAddNetworking(nhIdx: Int, completion: @escaping ()->Void) {
        let URL = url("/api/bookmark")
        
        let userdefault = UserDefaults.standard
        guard let token = userdefault.string(forKey: "token") else { return }
        let body: [String : Int] = [
            "nhIdx" : nhIdx]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ["token" : token]).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let message = JSON(value)["message"].string
                    
                    if message == "Success to Add" {
                        completion()
                    }
                }
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
        
        
    }
    
    
    
}
