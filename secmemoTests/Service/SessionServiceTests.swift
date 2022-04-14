//
//  SessionServiceTests.swift
//  secmemoTests
//
//  Created by heximal on 10.02.2022.
//

import XCTest
@testable import secmemo

class SessionServiceTests: XCTestCase {
    let testFakeMemosCount = 2
    let testPincodesCreated = true
    let testSecurityPincode = "1111"
    let testEmergencyPincode = "2222"
    // Fake memos.json contains 2 memos
    let testMemoJsonContents = "{\"memos\":[{\"createdAt\":1648675027,\"updatedAt\":1648675662,\"id\":1,\"title\":\"2\"}, {\"createdAt\":1648675027,\"updatedAt\":1648675662,\"id\":2,\"title\":\"2\"}],\"lastId\":2}"

    func testServiceRoutines() throws {
        let dataStorage = FileStorageMock()
        // Simulate stored memos.json
        let _ = dataStorage.saveTextItem(at: "/data/memos.json", text: testMemoJsonContents)

        let dataProvider = DataProviderImpl(dataStorage: dataStorage)
        // After dataProvide instantiated it must contain 2 items
        XCTAssertEqual(dataProvider.memoCount, testFakeMemosCount)

        let settingsService = SettingsServiceMock()
        let sessionService = SessionServiceImpl(settingService: settingsService, dataProvider: dataProvider)
        
        // Checks if following property values properly stored in SettingsConstants
        // when assigned from outside
        sessionService.pincodesCreated = true
        sessionService.securityPincode = testSecurityPincode
        sessionService.emergencyPincode = testEmergencyPincode

        XCTAssertEqual(sessionService.pincodesCreated, true)
        XCTAssertEqual(sessionService.securityPincode, testSecurityPincode)
        XCTAssertEqual(sessionService.emergencyPincode, testEmergencyPincode)
        // Setting up securityPincode and emergencyPincode must affect
        // securityPincodeEnabled and emergencyPincodeEnabled settings as well
        XCTAssertTrue(settingsService.securityPincodeEnabled)
        XCTAssertTrue(settingsService.emergencyPincodeEnabled)

        // Checks if root dir exists after emergeny code entered
        sessionService.didInputEmergencyPincode { confirmed in
            XCTAssertEqual(dataProvider.memoCount, 0)
        }
        // After dataProvide.didInputEmergencyPincode it must contain 0 items
    }
}
