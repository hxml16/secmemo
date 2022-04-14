//
//  LocationUtilsTests.swift
//  secmemoTests
//
//  Created by heximal on 01.03.2022.
//

import XCTest
@testable import secmemo

class LocationUtilsTests: XCTestCase {
    let testCorrectLocationStrings1 = "51.178838, -1.826252"
    let testCorrectLocationStrings2 = "51,178838 -1,826252"
    let testWrongLocationStrings1 = "asd"
    let testWrongLocationStrings2 = "200, 300"
    let testWrongLocationStrings3 = "-200, -300"
    let testWrongLocationStrings4 = "-200, 300"
    let testWrongLocationStrings5 = "200, -300"

    func testParseLocationsRoutine() throws {
        XCTAssertNotNil(LocationUtils.parseCoordString(testCorrectLocationStrings1))
        XCTAssertNotNil(LocationUtils.parseCoordString(testCorrectLocationStrings2))
    
        XCTAssertNil(LocationUtils.parseCoordString(testWrongLocationStrings1))
        XCTAssertNil(LocationUtils.parseCoordString(testWrongLocationStrings2))
        XCTAssertNil(LocationUtils.parseCoordString(testWrongLocationStrings3))
        XCTAssertNil(LocationUtils.parseCoordString(testWrongLocationStrings4))
        XCTAssertNil(LocationUtils.parseCoordString(testWrongLocationStrings5))
    }
}
