//
//  MemoHeaderTests.swift
//  secmemoTests
//
//  Created by heximal on 16.03.2022.
//

import XCTest
@testable import secmemo

class MemoHeaderTests: XCTestCase {
    private var sutMemoHeader: MemoHeader!
    private let testMemoId = 16
    private let testMemoTitle = "Test title"
    private let testMemoTimestamp = 1646595309

    override func setUpWithError() throws {
        sutMemoHeader = MemoHeader(id: testMemoId, title: testMemoTitle)
    }

    override func tearDownWithError() throws {
        sutMemoHeader = nil
    }

    func testCreateMemoHeader() throws {
        XCTAssertEqual(sutMemoHeader.id, testMemoId)
        XCTAssertEqual(sutMemoHeader.title, testMemoTitle)
    }

    func testMemoHeaderInitTimestamps() throws {
        XCTAssertEqual(sutMemoHeader.createdAt, 0)
        XCTAssertEqual(sutMemoHeader.updatedAt, 0)
        
        sutMemoHeader.initTimeStamps()
        
        XCTAssert(sutMemoHeader.updatedAt > 0)
        XCTAssert(sutMemoHeader.createdAt > 0)
    }

    func testMemoHeaderUpdateTimestamps() throws {
        XCTAssertEqual(sutMemoHeader.createdAt, 0)
        XCTAssertEqual(sutMemoHeader.updatedAt, 0)
        
        sutMemoHeader.updateCreated()
        sutMemoHeader.updateUpdated()

        XCTAssert(sutMemoHeader.updatedAt > 0)
        XCTAssert(sutMemoHeader.createdAt > 0)
    }
    
    func testMemoHeaderAsDictIsCorrect() throws {
        XCTAssertEqual(sutMemoHeader.createdAt, 0)
        XCTAssertEqual(sutMemoHeader.updatedAt, 0)
        sutMemoHeader.initTimeStamps()

        let dict = sutMemoHeader.dict
        
        if let id = dict["id"] as? Int {
            XCTAssertEqual(id, testMemoId)
        } else {
            XCTAssert(false, "updatedAt expected to be not null and of Int type")
        }

        if let title = dict["title"] as? String {
            XCTAssertEqual(title, testMemoTitle)
        } else {
            XCTAssert(false, "updatedAt expected to be not null and  of String type")
        }

        if let createdAt = dict["createdAt"] as? Int {
            XCTAssert(createdAt > 0)
        } else {
            XCTAssert(false, "updatedAt expected to be not null and  of Int type")
        }

        if let updatedAt = dict["updatedAt"] as? Int {
            XCTAssert(updatedAt > 0)
        } else {
            XCTAssert(false, "updatedAt expected to be not null and  of Int type")
        }
    }
    
    func testMemoHeaderFromDictIsCorrect() throws {
        let memoHeaderDict: [String: Any] = [
            "id": testMemoId,
            "title": testMemoTitle,
            "createdAt": testMemoTimestamp,
            "updatedAt": testMemoTimestamp
        ]
        let memoHeader = MemoHeader.memoHeader(from: memoHeaderDict)
        if let memoHeader = memoHeader {
            XCTAssertEqual(memoHeader.id, testMemoId)
            XCTAssertEqual(memoHeader.title, testMemoTitle)
            XCTAssertEqual(memoHeader.createdAt, testMemoTimestamp)
            XCTAssertEqual(memoHeader.updatedAt, testMemoTimestamp)
        } else {
            XCTAssert(false, "memoHeader expected to be not null")
        }
    }
}
