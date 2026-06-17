//
//  GameOfThrowsUITests.swift
//  GameOfThrowsUITests
//
//  Created by Gareth on 7/1/16.
//
//

import XCTest

class GameOfThrowsUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    func testApplicationLaunches() {
        XCTAssertTrue(app.exists)
    }
}
