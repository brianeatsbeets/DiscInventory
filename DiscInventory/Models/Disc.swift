//
//  Disc.swift
//  DiscInventory
//
//  Created by Aguirre, Brian P. on 3/8/22.
//

// MARK: - Imported libraries

import UIKit

// MARK: - Main class

// This struct provides a custom object to contain disc information
struct Disc: Hashable, Codable {
    
    // MARK: - Properties
    
    var id = UUID()
    var name: String
    @CodableColor var color: UIColor
    var imageData: Data?
    var type: DiscType
    var manufacturer: String
    var plastic: String
    var weightInGrams: Float
    var speed: Float
    var glide: Float
    var turn: Float
    var fade: Float
    var condition: Condition
    var notes: String
    var inBag: Bool
    
    // Define archival directory
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("discs").appendingPathExtension("plist")
    
    // MARK: - Utility functions
    
    // Load disc collection
    static func loadDiscs() -> [Disc]? {
        guard let codedDiscs = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Disc>.self, from: codedDiscs)
    }
    
    // Save disc collection
    static func saveDiscs(_ discs: [Disc]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedDiscs = try? propertyListEncoder.encode(discs)
        try? codedDiscs?.write(to: archiveURL, options: .noFileProtection)
    }
}

// MARK: Enums

// This enum provides a collection of disc types
enum DiscType: String, Codable, CaseIterable {
    case putter = "Putter"
    case midrange = "Midrange"
    case fairway = "Fairway"
    case distance = "Distance"
    
    // Return the index of a given option in the allCases array
    func getIndex() -> Self.AllCases.Index {
        return Self.allCases.firstIndex(of: self)!
    }
}

// This enum provides a collection of disc conditions
enum Condition: String, Codable, CaseIterable {
    case great = "Great"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    
    // Return the index of a given option in the allCases array
    func getIndex() -> Self.AllCases.Index {
        return Self.allCases.firstIndex(of: self)!
    }
}

// MARK: - CodableColor data structures

// This property wrapper contains the manual encoding implementation for UIColor, which keeps the Disc struct free from Codable clutter (CodingKeys enum, etc.)
// Via vadian on https://stackoverflow.com/questions/50928153/make-uicolor-codable
@propertyWrapper
struct CodableColor {
    var wrappedValue: UIColor
}

// Codable conformance is placed in an extension to keep the UIColor class functionality intact
extension CodableColor: Codable, Hashable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        guard let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid color"
            )
        }
        wrappedValue = color
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let data = try NSKeyedArchiver.archivedData(withRootObject: wrappedValue, requiringSecureCoding: true)
        try container.encode(data)
    }
}
