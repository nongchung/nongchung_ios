//
//  NoticeData.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 5..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation

public class NoticeData {
    
    public var title: String
    public var contents: [ContentData]?
    
    init(title: String, contents: [ContentData]?) {
        self.title = title
        self.contents = contents
    }
}

public class ContentData {
    public var content: String
    
    init(content: String) {
        self.content = content
    }
}
