//
//  TouchBistroChallengeTests.swift
//  TouchBistroChallengeTests
//
//  Created by Joseph Crozier on 2019-06-25.
//  Copyright © 2019 Joe Crozier. All rights reserved.
//

import XCTest
@testable import Challenge

class TouchBistroChallengeTests: XCTestCase {

    override func setUp() {
        do {
            try MenuManager.shared.clearMenu()
        } catch {
            XCTFail("Error occurred clearing menu")
        }
    }

    func testDefaultMenu() {
        MenuManager.shared.prepopulateMenu()
        let result = MenuManager.shared.menuGroups()
        XCTAssertNil(result.error, "Menu loading error was not nil")
        XCTAssert(result.groups!.count == 3, "Incorrect number of group")
        result.groups!.forEach{ XCTAssert($0.items?.count == 3, "Incorrect number of items")}
    }
    
    func testAddGroup() {
        let result = MenuManager.shared.menuGroups()
        XCTAssert(result.groups!.count == 0, "Incorrect number of groups")
        let addResult = MenuManager.shared.addGroup(name: "Group 1", imageUrl: URL(string: "https://i.imgur.com/Jfbg8uD.png")!)
        XCTAssertNil(addResult.error, "Error thrown in adding group")
        XCTAssertTrue(addResult.success)
        let newGroupsResult = MenuManager.shared.menuGroups()
        XCTAssert(newGroupsResult.groups!.count == 1, "Incorrect number of groups")
        let group = newGroupsResult.groups![0]
        XCTAssert(group.name == "Group 1", "Incorrect name for Group")
        XCTAssert(group.imageUrl?.absoluteString == "https://i.imgur.com/Jfbg8uD.png", "Incorrect imageUrl for Group")
    }
    
    func testDeleteGroup() {
        let result = MenuManager.shared.menuGroups()
        XCTAssert(result.groups!.count == 0, "Incorrect number of groups")
        let addResult = MenuManager.shared.addGroup(name: "Group 1", imageUrl: URL(string: "https://i.imgur.com/Jfbg8uD.png")!)
        XCTAssertNil(addResult.error, "Error thrown in adding group")
        XCTAssertTrue(addResult.success)
        let newGroupsResult = MenuManager.shared.menuGroups()
        XCTAssert(newGroupsResult.groups!.count == 1, "Incorrect number of groups")
        let group = newGroupsResult.groups![0]
        let deleteResult = MenuManager.shared.delete(group: group)
        XCTAssertNil(deleteResult.error, "Error thrown in deleting group")
        XCTAssertTrue(deleteResult.success)
        let deletedGroupsResult = MenuManager.shared.menuGroups()
        XCTAssert(deletedGroupsResult.groups!.count == 0, "Incorrect number of groups")
    }

}
