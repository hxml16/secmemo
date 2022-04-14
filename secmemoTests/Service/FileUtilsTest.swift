//
//  FirstTest.swift
//  secmemoTests
//
//  Created by heximal on 06.03.2022.
//

import XCTest
@testable import secmemo

class FiltUtilsTest: XCTestCase {
    private let testFileStorage = FileStorageImpl()
    private var testFilePath: String!
    private let tempFileName = "_12456qwertyPOCQ"
    private let textFileContent = "Hello World"

    override func setUpWithError() throws {
        testFilePath = testFileStorage.rootDirPath.appendingPathComponent(tempFileName)
    }

    override func tearDownWithError() throws {
        testFileStorage.removeItem(path: testFilePath)
        testFilePath = nil
    }

    func testReadWriteFile() throws {
        let fileSaved = testFileStorage.saveTextItem(at: testFilePath, text: textFileContent)
        let savedContent = testFileStorage.readTextItem(at: testFilePath)

        XCTAssertTrue(fileSaved)
        XCTAssertEqual(textFileContent, savedContent)
    }

    func testWriteRemoveExistsFile() throws {
        let fileSaved = testFileStorage.saveTextItem(at: testFilePath, text: textFileContent)
        let fileExistsAfterSave = testFileStorage.itemExists(at: testFilePath)

        XCTAssertTrue(fileSaved)
        XCTAssertTrue(fileExistsAfterSave)
        
        testFileStorage.removeItem(path: testFilePath)
        let fileExistsAfterRemove = testFileStorage.itemExists(at: testFilePath)

        XCTAssertFalse(fileExistsAfterRemove)
    }
}
