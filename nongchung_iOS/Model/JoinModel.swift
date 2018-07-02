//
//  JoinModel.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class JoinModel : NetworkModel{
    
    func duplicateEmailModel(email: String) {
        
        let URL = "\(baseURL)/api/dup-email"
        let body : [String:String] = [
            "email": email
        ]
        
        Alamofire.request(
            URL,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: nil
            ).responseObject{
                (response:DataResponse<DuplicateVO>) in
                switch response.result {
                case .success:
                    guard let responseMessage = response.result.value else{
                        self.view.networkFailed()
                        return
                    }
                    if responseMessage.message == "duplication" {
                        self.view.networkResult(resultData: "중복된 이메일 입니다.", code: "duplication")
                    }
                    else if responseMessage.message == "available" {
                        self.view.networkResult(resultData: "사용 가능한 이메일 입니다.", code: "available")
                    }
                    
                    
                case .failure(let err):
                    print(err)
                    self.view.networkFailed()
                }
        }
    }
    
    func duplicateNicknameModel(nickname: String) {
        
        let URL = "\(baseURL)/api/dup-nickname"
        let body : [String:String] = [
            "nickname": nickname
        ]
        
        Alamofire.request(
            URL,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: nil
            ).responseObject{
                (response:DataResponse<DuplicateVO>) in
                switch response.result {
                case .success:
                    guard let responseMessage = response.result.value else{
                        self.view.networkFailed()
                        return
                    }
                    if responseMessage.message == "duplication" {
                        self.view.networkResult(resultData: "중복된 닉네임 입니다.", code: "duplication")
                    }
                    else if responseMessage.message == "available" {
                        self.view.networkResult(resultData: "사용 가능한 낙네임 입니다.", code: "available")
                    }
                    
                    
                case .failure(let err):
                    print(err)
                    self.view.networkFailed()
                }
        }
    }
    
    func joinModel(email: String, password: String, nickname: String, name: String, sex: Int, handphone: String, birth: String) {
        
        let URL = "\(baseURL)/api/signup"
        let body : [String:Any] = [
            "email": email,
            "password": password,
            "nickname": nickname,
            "name": name,
            "sex": sex,
            "handphone": handphone,
            "birth": birth
        ]
        
        Alamofire.request(
            URL,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: nil
            ).responseObject{
                (response:DataResponse<DuplicateVO>) in
                switch response.result {
                case .success:
                    guard let responseMessage = response.result.value else{
                        self.view.networkFailed()
                        return
                    }
                    if responseMessage.message == "Success To Sign Up" {
                        self.view.networkResult(resultData: "Success Sign Up", code: "Success To Sign Up")
                    }
                    else if responseMessage.message == "Null Value" {
                        self.view.networkResult(resultData: "400ERROR", code: "2")
                    }
                    else if responseMessage.message == "Internal Server Error"{
                        self.view.networkResult(resultData: "500ERROR", code: "3")
                    }
                    
                case .failure(let err):
                    print(err)
                    self.view.networkFailed()
                }
        }
    }
}
