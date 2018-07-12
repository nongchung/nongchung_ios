//
//  QnaData.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 10..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation

public class QnAData {
    public var title: String
    public var contents: [AnswerData]?
    
    init(title: String, contents: [AnswerData]?) {
        self.title = title
        self.contents = contents
    }
}

public class AnswerData {
    public var content: String
    
    init(content: String) {
        self.content = content
    }
}
