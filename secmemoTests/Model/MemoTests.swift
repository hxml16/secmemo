//
//  MemoTests.swift
//  secmemoTests
//
//  Created by heximal on 16.03.2022.
//

import XCTest
@testable import secmemo

// Class for testing Memo model entity
class MemoTests: XCTestCase {
    private let testMemoId = 16
    private let testMemoTitle = "Test title"
    private let testMemoTimestamp = 1646595309

    func testMemoCreateFromIdAndTitle() throws {
        let memo = Memo.memo(id: testMemoId, title: testMemoTitle)
        if let header = memo.header {
            XCTAssertEqual(header.id, testMemoId)
            XCTAssertEqual(header.title, testMemoTitle)
        } else {
            XCTAssert(false, "memo.header expected to be not nil")
        }
    }

    // Checks if Memo entity instantiates
    // properly from deserialized dictionary
    func testMemoFromDictIsCorrect() throws {
        let memoDict = generateTestMemoDict()
        if let memo = Memo.memo(from: memoDict) {
            XCTAssertNotNil(memo.header)
            XCTAssertGreaterThan(memo.entriesCount, 0)
            
            //Checks if Memo proxy properties match the same in MemoHeader
            XCTAssertEqual(memo.id, memo.header?.id)
            XCTAssertEqual(memo.title, memo.header?.title)
            XCTAssertEqual(memo.updatedAt, memo.header?.updatedAt)
            XCTAssertEqual(memo.createdAt, memo.header?.createdAt)
        } else {
            XCTAssert(false, "memo expected to be not nil")
        }
    }

    // Checks if Memo entity serializes
    // properly into dictionary
    func testMemoAsDictIsCorrect() throws {
        let memoDict = generateTestMemoDict()
        if let memo = Memo.memo(from: memoDict) {
            let dictToTest = memo.dict
            XCTAssertNotNil(dictToTest["header"])
            XCTAssertNotNil(dictToTest["entries"])
        } else {
            XCTAssert(false, "memo expected to be not nil")
        }
    }

    private func generateTestMemoDict() -> [String: Any] {
        let memoHeaderDict: [String: Any] = [
            "id": testMemoId,
            "title": testMemoTitle,
            "createdAt": testMemoTimestamp,
            "updatedAt": testMemoTimestamp
        ]
        
        let entries: [[String: Any]] = [
            [
              "type": 0,
              "hash": "DB3CA0E0-D399-4F48-A1FD-3C86EABE1770"
            ],
            [
              "type": 1,
              "hash": "EAD2C0D3-B00C-4021-976C-A1EDE38AA5A3"
            ],
            [
              "hash": "415AB57B-2F19-409F-AFB2-0F7B22A9441B",
              "type": 2
            ],
            [
              "hash": "CDB7A886-D76D-4665-BE0A-AE3E64A2E277",
              "type": 4,
              "entries": [
                [
                  "hashThumbnail": "81342ABE-7105-4E07-80E7-0050658B5A94",
                  "type": 3,
                  "hash": "035D18D8-F7C9-4303-8DC0-F8F9146A6948"
                ]
              ]
            ]
        ]
        let memoDict: [String: Any] = [
            "header": memoHeaderDict,
            "entries": entries
        ]
        return memoDict
    }
}
