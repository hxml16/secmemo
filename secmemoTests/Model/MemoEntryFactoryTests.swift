//
//  MemoEntryFactoryTests.swift
//  secmemoTests
//
//  Created by heximal on 16.03.2022.
//

import XCTest
@testable import secmemo

class MemoEntryFactoryTests: XCTestCase {
    private let testHash = "EAD2C0D3-B00C-4021-976C-A1EDE38AA5A3"
    
    func testCreateMemoEntryWithType() throws {
        let memoEntryTypesToTest: [MemoEntryType] = [.text, .location, .image, .imageCollection]
        for entryType in memoEntryTypesToTest {
            let entry = MemoEntryFactory.memoEntry(with: entryType)
            XCTAssertEqual(entryType, entry.type)
        }
    }
    
    func testCreateTextMemoEntry() throws {
        let textMemoEntryDict = memoDict(entryType: .text)
        let textEntry = MemoEntryFactory.memoEntry(with: textMemoEntryDict)
        
        XCTAssertEqual(textEntry.type, MemoEntryType.text)
        XCTAssertEqual(textEntry.hash, testHash)
    }
    
    func testCreateLocationMemoEntry() throws {
        let locationMemoEntryDict = memoDict(entryType: .location)
        let locationEntry = MemoEntryFactory.memoEntry(with: locationMemoEntryDict)
        
        XCTAssertEqual(locationEntry.type, MemoEntryType.location)
        XCTAssertEqual(locationEntry.hash, testHash)
    }
    
    func testCreateImageMemoEntry() throws {
        let imageMemoEntryDict = memoDict(entryType: .image)
        let imageEntry = MemoEntryFactory.memoEntry(with: imageMemoEntryDict)
        
        XCTAssertEqual(imageEntry.type, MemoEntryType.image)
        XCTAssertEqual(imageEntry.hash, testHash)
    }
    
    func testCreateImageCollectionMemoEntry() throws {
        let imageCollectionMemoEntryDict = memoDict(entryType: .imageCollection)
        let imageCollectionEntry = MemoEntryFactory.memoEntry(with: imageCollectionMemoEntryDict)
        
        XCTAssertEqual(imageCollectionEntry.type, MemoEntryType.imageCollection)
        XCTAssertEqual(imageCollectionEntry.hash, testHash)
    }
    
    func memoDict(entryType: MemoEntryType) -> [String: Any] {
        let memoDict: [String: Any] = [
            "type": entryType.rawValue,
            "hash": testHash
        ]
        return memoDict
    }
}
