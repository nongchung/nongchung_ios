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
                            self.view.networkResult(resultData: token, code: "success")
                        }
                    }
                    else {
                        self.view.networkResult(resultData: "error", code: "fail")
                    }
                    
                    
                case .failure(let err):
                    print(err)
                    self.view.networkFailed()
                }
        }
    }
}
