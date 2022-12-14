//
//  DiscViewModelTests.swift
//  DiscInventoryTests
//
//  Created by Aguirre, Brian P. on 10/14/22.
//

// MARK: - Imported frameworks

import XCTest
@testable import DiscInventory

// MARK: - Main class

// This test class contains tests for the DiscTableViewModel view model functions
final class DiscTableViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: DiscTableViewModel!
    
    // MARK: - Life cycle functions
    
    // Initialize the SUT
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DiscTableViewModel()
    }
    
    // Deinitialize the SUT
    override func tearDownWithError() throws {
        Disc.saveDiscs([])
        sut = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    // Test the loading of discs from file into the model
    func testLoadDiscs() {
        // Given
        let disc = createAvairDisc()
        Disc.saveDiscs([disc])
        
        // When
        sut.loadDiscs()
        
        // Then
        XCTAssertEqual(sut.discs, [disc], "Result does not match provided disc array")
        XCTAssertEqual(sut.discs.count, 1, "Result does not match expected number of discs")
    }
    
    // Test updating a disc
    func testUpdateDisc() {
        // Given
        let disc = createAvairDisc()
        sut.discs = [disc]
        
        // When
        let newDisc = createWraithDisc()
        sut.updateDisc(at: 0, with: newDisc)
        
        // Then
        XCTAssertEqual(sut.discs, [newDisc], "Result does not match updated disc")
        XCTAssertEqual(sut.discs.count, 1, "Result does not match expected number of discs")
    }
    
    // Test adding a disc
    func testAddDisc() {
        // Given
        let disc = createAvairDisc()
        sut.discs = [disc]
        
        // When
        let newDisc = createWraithDisc()
        sut.addDisc(newDisc)
        
        // Then
        XCTAssertEqual(sut.discs, [disc, newDisc], "Result does not match disc array with added disc")
        XCTAssertEqual(sut.discs.count, 2, "Result does not match expected number of discs")
    }
    
    // Test removing a disc
    func testRemoveDisc() {
        // Given
        let discOne = createAvairDisc()
        let discTwo = createWraithDisc()
        sut.discs = [discOne, discTwo]
        
        // When
        sut.removeDisc(discOne)
        
        // Then
        XCTAssertEqual(sut.discs, [discTwo], "Result does not match disc array with removed disc")
        XCTAssertEqual(sut.discs.count, 1, "Result does not match expected number of discs")
    }
    
    // Test togging a disc's 'In Bag' value
    func testToggleInBag() {
        // Given
        let disc = createAvairDisc()
        sut.discs = [disc]
        
        // When
        sut.toggleInBag(atRow: 0)
        
        // Then
        XCTAssertFalse(sut.discs[0].inBag, "Result does not match expected boolean value")
    }
    
    // TODO: Test writing to file system?
    //    // Test saving discs
    //    func testSaveDiscs() {
    //        // Given
    //        let discOne = Disc(name: "Aviar", color: .black, type: .putter, manufacturer: "Innova", plastic: "DX", weightInGrams: 175, speed: 2, glide: 3, turn: 0, fade: 1, condition: .great, notes: "", inBag: true)
    //        let discTwo = Disc(name: "Wraith", color: .white, type: .distance, manufacturer: "Innova", plastic: "Champion", weightInGrams: 171, speed: 11, glide: 5, turn: -3, fade: 3, condition: .good, notes: "Favorite disc", inBag: true)
    //        sut.discs = [discOne, discTwo]
    //
    //        // When
    //        sut.saveDiscs()
    //
    //        // Then
    //
    //    }
        
    //MARK: - Helper functions
    
    // Create and return a test disc
    func createAvairDisc() -> Disc {
        return Disc(name: "Aviar", color: .black, type: .putter, manufacturer: "Innova", plastic: "DX", weightInGrams: 175, speed: 2, glide: 3, turn: 0, fade: 1, condition: .great, notes: "", inBag: true)
    }
    
    // Create and return a different test disc
    func createWraithDisc() -> Disc {
        return Disc(name: "Wraith", color: .white, type: .distance, manufacturer: "Innova", plastic: "Champion", weightInGrams: 171, speed: 11, glide: 5, turn: -3, fade: 3, condition: .good, notes: "Favorite disc", inBag: true)
    }
    
}
