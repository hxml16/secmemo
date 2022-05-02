//
//  MemoEntriesTests.swift
//  secmemoTests
//
//  Created by heximal on 16.03.2022.
//

import XCTest
@testable import secmemo
import CoreLocation

// Class for testing all kind of MemoEntry entities
// (text, location, image, imageCollection)
class MemoEntriesTests: XCTestCase {
    struct MockSize: Equatable {
        var width: Int = 0
        var height: Int = 0
        
        static func ==(var1: MockSize, var2: MockSize) -> Bool {
            return var1.width == var2.width && var1.height == var2.height
        }
        
        static func mockSize(with cgSize: CGSize) -> MockSize {
            var size = MockSize()
            size.width = Int(round(cgSize.width))
            size.height = Int(round(cgSize.height))
            return size
        }
    }
    
    private let testText1 = "Hello World"
    private let testText2 = "World Hello"
    private let testHash1 = "EAD2C0D3-B00C-4021-976C-A1EDE38AA5A3"
    private let testHash2 = "E38AA5A3-4021-976C-B00C-A1EDEAD2C0D3"
    private let testHash3 = "A1EDE3EA-4021-B00C-976C-D2C0D38AA5A3"
    private let testHash4 = "4021976C-A5A3-DE34-B00C-A1EDEAD2C0D3"
    private let testHash5 = "2C0D38AA-4021-B00C-976C-D5A3A1EDE3EA"
    private let testHash6 = "A5A3DE34-4021-976C-B00C-A1EDEAD2C0D3"


    private let testMemoId = 16
    private let testImageName = "testImage320x240"
    private var dataProviderMock: DataProvider!
    
    override func setUpWithError() throws {
        dataProviderMock = DataProviderMock()
    }

    override func tearDownWithError() throws {
        dataProviderMock = nil
    }

    func testMemoDataEntry() throws {
        let dataToTest1 = testText1.data(using: .utf8)!
        let dataToTest2 = testText2.data(using: .utf8)!
        let dataEntry = MemoDataEntry(data: dataToTest1, hash: testHash1, memoId: testMemoId)

        XCTAssertEqual(testMemoId, dataEntry.memoId)
        XCTAssertEqual(testHash1, dataEntry.hash)
        XCTAssertEqual(dataToTest1, dataEntry.data)
        dataEntry.data = dataToTest2
        XCTAssertEqual(dataToTest2, dataEntry.data)
    }

    func testMemoTextEntry() throws {
        let dataToTest1 = testText1.data(using: .utf8)!
        let textEntry = MemoTextEntry()
        textEntry.data = dataToTest1

        XCTAssertEqual(testText1, textEntry.text)
    }
    
    // Checks instatiating imageEntry from UIImage (aka new imageEntry)
    func testMemoImageEntryFromUIImage() throws {
        let testMemo = Memo.memo(id: testMemoId, title: testText1)
        // testImage must be linked to project fot test to succeed
        let testImage = UIImage(named: testImageName)!
        let imageEntry = MemoImageEntry.imageEntry(with: testImage, memo: testMemo)
        let koef = GlobalConstants.imageEntryThumbnailSize.height / testImage.size.height
        let haulThumbnailSize = CGSize(width: testImage.size.width * koef, height: testImage.size.height * koef)
        
        XCTAssertNotNil(imageEntry.originalImage)
        if let thumbnailImage = imageEntry.thumbnailImage {
            // check if thunbnail image is scaled properly
            XCTAssertEqual(MockSize.mockSize(with: haulThumbnailSize), MockSize.mockSize(with: thumbnailImage.size))
        } else {
            XCTAssert(false, "thumbnailImage excpected to be not nil")
        }
    }

    // Checks instatiating imageEntry from unserialized data
    func testMemoImageEntryFromDict() throws {
        let dict: [String: Any] = [
            "hash": testHash1,
            "hashThumbnail": testHash2
        ]
        if let testImageEntry = MemoImageEntry.imageEntry(with: dict, memoId: testMemoId) {
            XCTAssertEqual(testImageEntry.hash, testHash1)
            XCTAssertEqual(testImageEntry.hashThumbnail, testHash2)
        } else {
            XCTAssert(false, "checkImageEntry excpected to be not nil")
        }
    }

    // Checks imageEntry save and load routines
    func testMemoImageEntrySaveData() throws {
        let testMemo = Memo.memo(id: testMemoId, title: testText1)
        // testImage must be linked to project fot test to succeed
        let testImage = UIImage(named: testImageName)!
        let imageEntry = MemoImageEntry.imageEntry(with: testImage, memo: testMemo)
        let hash1 = imageEntry.hash
        let hash2 = imageEntry.hashThumbnail
        
        // save image data
        imageEntry.save(dataProvider: dataProviderMock)
        
        // and then check if data saved properly
        let dict: [String: Any] = [
            "hash": hash1,
            "hashThumbnail": hash2
        ]

        if let checkImageEntry = MemoImageEntry.imageEntry(with: dict, memoId: testMemoId) {
            checkImageEntry.preloadImages(dataProvider: dataProviderMock)
            XCTAssertNotNil(checkImageEntry.originalImage)
            XCTAssertNotNil(checkImageEntry.thumbnailImage)
        } else {
            XCTAssert(false, "checkImageEntry excpected to be not nil")
        }
    }
    
    func testMemoImageCollectionEntry() throws {
        let dict1: [String: Any] = [
            "hash": testHash1,
            "hashThumbnail": testHash2
        ]

        let dict2: [String: Any] = [
            "hash": testHash3,
            "hashThumbnail": testHash4
        ]
        let entries = [dict1, dict2]
        let entriesDict = ["entries": entries]

        let imageCollectionEntry = MemoImageCollectionEntry()
        // Checks if image collection is populating properly with given entriesDict
        // image colelction must contain 2 elements after that
        imageCollectionEntry.unpackEntries(from: entriesDict)
                
        XCTAssertEqual(imageCollectionEntry.count, entries.count)
        
        let dict3: [String: Any] = [
            "hash": testHash5,
            "hashThumbnail": testHash6
        ]
        let imageEntry = MemoImageEntry.imageEntry(with: dict3, memoId: testMemoId)!
        let countBeforeAdd = imageCollectionEntry.count
        // Checks addEntry routine. Image collection
        // must contain 3 elements after that
        imageCollectionEntry.addEntry(imageEntry: imageEntry)
        XCTAssertEqual(imageCollectionEntry.count, countBeforeAdd + 1)

        // Checks image collection data serialization
        let dict = imageCollectionEntry.dict
        if let entries = dict["entries"] as? [[String: Any]] {
            XCTAssertEqual(imageCollectionEntry.count, entries.count)
        } else {
            XCTAssert(false, "entries attribute excpected to be array of [String: Any]")
        }
        let countBeforeRemove = imageCollectionEntry.count
        // Checks removeEntry routine. Image collection
        // must contain 2 elements after that again
        imageCollectionEntry.removeEntry(imageEntry: imageEntry)
        XCTAssertEqual(imageCollectionEntry.count, countBeforeRemove - 1)
    }
    
    func testMemoLocationEntry() throws {
        // when location entry is just instantiated
        // it must not contain a coordinate
        let locationEntry1 = MemoLocationEntry()
        XCTAssertFalse(locationEntry1.isSet)

        let testCoordinate = CLLocationCoordinate2D(latitude: 51.178838, longitude: -1.826252)
        locationEntry1.coordinate = testCoordinate
        
        // once coordinate property is assigned
        // data propery must contain non-nil value
        // and isSet must return true
        XCTAssertNotNil(locationEntry1.data)
        XCTAssertTrue(locationEntry1.isSet)

        // when data property is assigned with String
        // containing valid human-readable coordinate
        // coordinate propery must contain valid GPS coordinate
        // and isSet propery must contain true
        let locationEntry2 = MemoLocationEntry()
        let coordinateString = "51.178838, -1.826252"
        let coordinateData = coordinateString.data(using: .utf8)!
        locationEntry2.data = coordinateData
        XCTAssertTrue(locationEntry2.isSet)
    }
    
    // Checks if memo entries properly saved and removed in data storage
    func testSaveRemoveEntry() {
        let dataStorage = FileStorageMock()
        let dataProvider = DataProviderImpl(dataStorage: dataStorage)
        let dataEntry = MemoEntryFactory.memoEntry(with: .text) as! MemoTextEntry
        dataEntry.memoId = testMemoId
        dataEntry.text = testText1
        let _ = dataProvider.save(entry: dataEntry)
        
        dataEntry.text = nil
        dataProvider.preloadMemoEntry(entry: dataEntry)
        
        XCTAssertNotNil(dataEntry.text)

        dataProvider.remove(entry: dataEntry)
        dataEntry.text = nil
        dataProvider.preloadMemoEntry(entry: dataEntry)

        XCTAssertNil(dataEntry.text)
    }
}
