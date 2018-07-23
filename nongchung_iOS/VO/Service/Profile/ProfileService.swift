//
//  ProfileService.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 3..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

struct ProfileService : APIService {
    static func profileInit(completion: @escaping ([Profile])->Void) {
        let URL = url("/api/mypage")
        let userdefault = UserDefaults.standard
        guard let token = userdefault.string(forKey: "token") else { return }
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["token" : token]).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()
                    
                    do {
                        let profileData = try decoder.decode(ProfileData.self, from: value)
                        
                        if profileData.message == "success to show mypage" {
                            completion(profileData.data)
                            print(profileData.data)
                        }
                        
                    } catch {
                        
                    }
                }
                
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    
    
    static func editProfileImage(image: UIImage, completion: @escaping ()->Void) {
        let URL = url("/api/mypage/photo")
        let userdefault = UserDefaults.standard
        guard let token = userdefault.string(forKey: "token") else {return}
        let photoData = UIImageJPEGRepresentation(image, 0.3)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(photoData!, withName: "image", fileName: "photo.jpg" ,mimeType: "image/jpeg")
        }, to: URL, method: .put, headers: ["token" : token])
        { (encodingResult) in
            switch encodingResult {
                
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseData( completionHandler: { (res) in
                    switch res.result{
                    case .success:
                        if let value = res.result.value {
                            let message = JSON(value)["mesaage"].string
                            
                            if message == "success To change photo"{
                                completion()
                            } else if message == "Null value" {
                            } else if message == "token error" {
                            }
                        }
                        break
                        
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                    
                })
                
            case .failure(let err):
                print(err.localizedDescription)
                
            }
        }
    }
    
    

    
    static func editPassword(password: String, newpw:String, completion: @escaping (String)->Void) {
        let userdefault = UserDefaults.standard
        guard let token = userdefault.string(forKey: "token") else { return }
        let body: [String: String] = [
            "password" : password,
            "newpw" : newpw
        ]
        let URL = url("/api/mypage/password")
        
        Alamofire.request(URL, method: .put, parameters: body, encoding: JSONEncoding.default, headers: ["token" : token]).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let message = JSON(value)["message"].string
                    
                    if message == "Success To change PW" {
                        completion("Success To change PW")
                    } else if message == "fail To change PW from client" {
                        completion("fail To change PW from client")
                    }
                }
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    
    static func editNickname(nickname: String, completion: @escaping (String)->Void) {
        let userdefault = UserDefaults.standard
        guard let token = userdefault.string(forKey: "token") else { return }
        let body: [String: String] = [
            "nickname" : nickname
        ]
        let URL = url("/api/mypage/nickname")
        
        Alamofire.request(URL, method: .put, parameters: body, encoding: JSONEncoding.default, headers: ["token" : token]).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let message = JSON(value)["message"].string
                    
                    if message == "Success to change nickname" {
                        completion("Success to change nickname")
                    } else if message == "duplicate nickname" {
                        completion("duplicate nickname")
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



