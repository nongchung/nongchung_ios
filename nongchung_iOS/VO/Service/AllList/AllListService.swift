//
//  AllListService.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 11..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit


struct AllListService : APIService {
    //MARK: 인기 농활 모두보기 - 로그인 했을 경우
    static func popListLoginInit(idx: Int, completion: @escaping (Int, [AllListDataVO])->Void) {
        let URL = url("/api/home/more/morePopul?idx=\(idx)")
        let token = UserDefaults.standard.string(forKey: "token")

        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["token" : token!]).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()
                    do {
                        let allListData = try decoder.decode(AllListVO.self, from: value)
                        if allListData.message == "Success To Get Data" {
                            completion(allListData.isEnd!, allListData.data!)
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
    
    //MARK: 인기 농활 모두보기 - 로그인 안 했을 경우
    static func popListInit(idx: Int, completion: @escaping (Int, [AllListDataVO])->Void) {
        let URL = url("/api/home/more/morePopul?idx=\(idx)")
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()
                    
                    do {
                        let allListData = try decoder.decode(AllListVO.self, from: value)
                        if allListData.message == "Success To Get Data" {
                            completion(allListData.isEnd!, allListData.data!)
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
    
    //MARK: 새로운 농활 모두보기 - 로그인 했을 경우
    static func newListLoginInit(idx: Int, completion: @escaping (Int, [AllListDataVO])->Void) {
        let URL = url("/api/home/more/moreNew?idx=\(idx)")
        let token = UserDefaults.standard.string(forKey: "token")

        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["token" : token!]).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()
                    do {
                        let allListData = try decoder.decode(AllListVO.self, from: value)
                        if allListData.message == "Success To Get Data" {
                            completion(allListData.isEnd!, allListData.data!)
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
    
    //MARK: 새로운 농활 모두보기 - 로그인 안 했을 경우
    static func newListInit(idx: Int, completion: @escaping (Int, [AllListDataVO])->Void) {

        let URL = url("/api/home/more/moreNew?idx=\(idx)")
        let encodedURL = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(encodedURL!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in

            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()

                    do {

                        let allListData = try decoder.decode(AllListVO.self, from: value)
                        if allListData.message == "Success To Get Data" {

                            completion(allListData.isEnd!, allListData.data!)
                        }
                        
                    } catch {

                        print(error.localizedDescription)
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
    
}
