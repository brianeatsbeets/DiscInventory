//
//  DiscViewModelTests.swift
//  DiscInventoryTests
//
//  Created by Aguirre, Brian P. on 10/15/22.
//

// MARK: - Imported frameworks

import XCTest
@testable import DiscInventory

// MARK: - Main class

// This test class contains tests for the DiscViewModel view model functions
final class DiscViewModelTests: XCTestCase {
    
    // MARK: - Properties

    var sut: DiscViewModel!
    let disc = Disc(name: "Aviar", color: .black, type: .putter, manufacturer: "Innova", plastic: "DX", weightInGrams: 175, speed: 2, glide: 3, turn: 0, fade: 1, condition: .great, notes: "", inBag: true)
    
    // MARK: - Life cycle functions
    
    // Initialize the SUT
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DiscViewModel(disc: disc)
    }
    
    // Deinitialize the SUT
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    // Test the loading of discs from file into the model
    func testInit() {
        // Given - DiscViewModel was initialized
        
        // When - N/A
        
        // Then
        XCTAssertEqual(sut.disc, disc, "Result does not match provided disc")
    }
    
    // Test the discStatFormattedString function
    func testDiscStatFormattedString() {
        // Given
        let wholeNumber: Float = 5
        let singleDecimalPlaceNumber: Float = 5.5
        let multipleDecimalPlaceNumber: Float = 5.2247
        
        // When
        let formattedWholeNumber = wholeNumber.discStatFormattedString()
        let formattedSingleDecimalPlaceNumber = singleDecimalPlaceNumber.discStatFormattedString()
        let formattedMultipleDecimalPlaceNumber = multipleDecimalPlaceNumber.discStatFormattedString()
        
        // Then
        XCTAssertEqual(formattedWholeNumber, "5", "Result is not a whole number")
        XCTAssertEqual(formattedSingleDecimalPlaceNumber, "5.5", "Result is not rounded to the nearest single decimal place")
        XCTAssertEqual(formattedMultipleDecimalPlaceNumber, "5.2", "Result is not rounded to the nearest second decimal place")
    }
    
    // Test the getters of the DiscViewModel properties
    func testDiscViewModelPropertyGetters() {
        // Given - DiscViewModel was initialized
        
        // When - N/A
        
        // Then
        XCTAssertEqual(sut.name, disc.name, "Result does not match provided name")
        XCTAssertEqual(sut.color, disc.color, "Result does not match provided color")
        XCTAssertEqual(sut.imageData, disc.imageData, "Result does not match provided image data")
        XCTAssertEqual(sut.image, disc.imageData != nil ? UIImage(data: disc.imageData!) : nil, "Result does not match provided image")
        XCTAssertEqual(sut.type, disc.type, "Result does not match provided type")
        XCTAssertEqual(sut.manufacturer, disc.manufacturer, "Result does not match provided manufacturer")
        XCTAssertEqual(sut.plastic, disc.plastic, "Result does not match provided plastic")
        XCTAssertEqual(sut.weight, disc.weightInGrams, "Result does not match provided weight")
        XCTAssertEqual(sut.speed, disc.speed, "Result does not match provided speed")
        XCTAssertEqual(sut.glide, disc.glide, "Result does not match provided glide")
        XCTAssertEqual(sut.turn, disc.turn, "Result does not match provided turn")
        XCTAssertEqual(sut.fade, disc.fade, "Result does not match provided fade")
        XCTAssertEqual(sut.condition, disc.condition, "Result does not match provided condition")
        XCTAssertEqual(sut.notes, disc.notes, "Result does not match provided notes")
        XCTAssertEqual(sut.inBag, disc.inBag, "Result does not match provided inBag value")
    }
    
    // Test the setters of the DiscViewModel properties
    func testDiscViewModelPropertySetters() {
        // Given - DiscViewModel was initialized
        let testImage = UIImage(systemName: "opticaldisc")!
        let testImageData = testImage.jpegData(compressionQuality: 0.9)
        let testCompressedImage = UIImage(data: testImageData!)
        
        // When
        sut.name = "Buzzz"
        sut.color = .green
        sut.imageData = testImageData
        sut.image = testImage
        sut.type = .midrange
        sut.manufacturer = "Discraft"
        sut.plastic = "ESP"
        sut.weight = 180
        sut.speed = 5
        sut.glide = 4
        sut.turn = -1
        sut.fade = 1
        sut.condition = .fair
        sut.notes = "Test note"
        sut.inBag = false
        
        // Then
        XCTAssertEqual(sut.name, "Buzzz", "Result does not match updated name")
        XCTAssertEqual(sut.color, .green, "Result does not match updated color")
        XCTAssertEqual(sut.imageData, testImageData, "Result does not match updated image data")
        
        // Need to compare the image data rather than the image object itself
        // The image objects are just pointers to a memory location, and because these are two uniquely generated image objects and not references to each other, a comparison would always return not equal
        XCTAssertEqual(sut.image?.pngData(), testCompressedImage?.pngData(), "Result does not match updated image")
        
        XCTAssertEqual(sut.type, .midrange, "Result does not match updated type")
        XCTAssertEqual(sut.manufacturer, "Discraft", "Result does not match updated manufacturer")
        XCTAssertEqual(sut.plastic, "ESP", "Result does not match updated plastic")
        XCTAssertEqual(sut.weight, 180, "Result does not match updated weight")
        XCTAssertEqual(sut.speed, 5, "Result does not match updated speed")
        XCTAssertEqual(sut.glide, 4, "Result does not match updated glide")
        XCTAssertEqual(sut.turn, -1, "Result does not match updated turn")
        XCTAssertEqual(sut.fade, 1, "Result does not match updated fade")
        XCTAssertEqual(sut.condition, .fair, "Result does not match updated condition")
        XCTAssertEqual(sut.notes, "Test note", "Result does not match updated note")
        XCTAssertEqual(sut.inBag, false, "Result does not match updated inBag value")
    }

}
