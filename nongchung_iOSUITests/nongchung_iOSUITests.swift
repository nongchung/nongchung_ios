//
//  nongchung_iOSUITests.swift
//  nongchung_iOSUITests
//
//  Created by 갓거 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import XCTest

class nongchung_iOSUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    func testSnapshot(){
        let app = XCUIApplication()
        let tabbarsQuery = app.tabBars
        
        snapshot("0_Launch")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
