//
//  NetworkCallback.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

protocol NetworkCallback {
    
    func networkResult(resultData:Any, code:String)
    func networkFailed()
    
}
