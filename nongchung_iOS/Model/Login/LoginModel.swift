//
//  LoginModel.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class LoginModel : NetworkModel{
    
    func login(email: String, password: String) {
        
        let URL = "\(baseURL)/api/signin"
        let body : [String:String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(
            URL,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: nil
            ).responseObject{
                (response:DataResponse<LoginVO>) in
                switch response.result {
                case .success:
                    guard let responseMessage = response.result.value else{
                        self.view.networkFailed()
                        return
                    }
                    if responseMessage.message == "Success To Sign In" {
                        if let token = responseMessage.token{
                            self.view.networkResult(resultData: token, code: "Success To Sign In")
                        }
                    }
                    else if responseMessage.message == "Null Value" {
                        self.view.networkResult(resultData: "400ERR", code: "Null Value")
                    }
                    else if responseMessage.message == "Internal Server Error"{
                        self.view.networkResult(resultData: "500ERR", code: "Internal Server Error")
                    }
                    else if responseMessage.message == "Fail To Sign In"{
                        self.view.networkResult(resultData: "아이디 또는 패스워드를 확인해주세요.", code: "Fail To Sign In")
                    }
                    
                case .failure(let err):
                    print(err)
                    self.view.networkFailed()
                }
        }
    }
}

