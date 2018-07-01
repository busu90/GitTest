//
//  UtilTests.swift
//  GitTestTests
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import XCTest
@testable import GitTest

class UtilTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_get_next_page_url_actual_format() {
        let link = "<https://api.github.com/search/repositories?q=created%3A%3E2017-05-17&sort=stars&order=desc&page=1>; rel=\"prev\", <https://api.github.com/search/repositories?q=created%3A%3E2017-05-17&sort=stars&order=desc&page=3>; rel=\"next\", <https://api.github.com/search/repositories?q=created%3A%3E2017-05-17&sort=stars&order=desc&page=34>; rel=\"last\", <https://api.github.com/search/repositories?q=created%3A%3E2017-05-17&sort=stars&order=desc&page=1>; rel=\"first\""
        XCTAssertEqual("https://api.github.com/search/repositories?q=created%3A%3E2017-05-17&sort=stars&order=desc&page=3", Util.getNextPageUri(fromHeaderString: link))
    }
    
    func test_get_star_string_hundreds() {
        let link = 245
        XCTAssertEqual("245", Util.getStarString(forStars: link))
    }
    func test_get_star_string_thousands() {
        let link = 23456
        XCTAssertEqual("23k", Util.getStarString(forStars: link))
    }
    func test_get_star_string_milions() {
        let link = 97450453
        XCTAssertEqual("97m", Util.getStarString(forStars: link))
    }
    
}
