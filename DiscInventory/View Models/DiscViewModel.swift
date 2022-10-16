//
//  DiscViewModel.swift
//  DiscInventory
//
//  Created by Aguirre, Brian P. on 10/13/22.
//

// MARK: - Imported libraries

import UIKit.UIImage

// MARK: - Main struct

// This struct represents a view model for DiscTableViewCell
struct DiscViewModel {
    
    // MARK: Properties
    
    var disc: Disc
    
    var name: String {
        get {
            disc.name
        }
        set (newValue) {
            disc.name = newValue
        }
    }
    var color: UIColor {
        get {
            disc.color
        }
        set (newValue) {
            disc.color = newValue
        }
    }
    var imageData: Data? {
        get {
            disc.imageData
        }
        set (newValue) {
            disc.imageData = newValue
        }
    }
    var image: UIImage? {
        get {
            disc.imageData != nil ? UIImage(data: disc.imageData!) : nil
        }
        set (newValue) {
            disc.imageData = newValue?.jpegData(compressionQuality: 0.9)
        }
    }
    var type: DiscType {
        get {
            disc.type
        }
        set (newValue) {
            disc.type = newValue
        }
    }
    var manufacturer: String {
        get {
            disc.manufacturer
        }
        set (newValue) {
            disc.manufacturer = newValue
        }
    }
    var plastic: String {
        get {
            disc.plastic
        }
        set (newValue) {
            disc.plastic = newValue
        }
    }
    var weight: Float {
        get {
            disc.weightInGrams
        }
        set (newValue) {
            disc.weightInGrams = newValue
        }
    }
    var speed: Float {
        get {
            disc.speed
        }
        set (newValue) {
            disc.speed = newValue
        }
    }
    var glide: Float {
        get {
            disc.glide
        }
        set (newValue) {
            disc.glide = newValue
        }
    }
    var turn: Float {
        get {
            disc.turn
        }
        set (newValue) {
            disc.turn = newValue
        }
    }
    var fade: Float {
        get {
            disc.fade
        }
        set (newValue) {
            disc.fade = newValue
        }
    }
    var condition: Condition {
        get {
            disc.condition
        }
        set (newValue) {
            disc.condition = newValue
        }
    }
    var notes: String {
        get {
            disc.notes
        }
        set (newValue) {
            disc.notes = newValue
        }
    }
    var inBag: Bool {
        get {
            disc.inBag
        }
        set (newValue) {
            disc.inBag = newValue
        }
    }
    var formattedWeight: String {
        get {
            disc.weightInGrams.discStatFormattedString()
        }
    }
    var formattedSpeed: String {
        get {
            disc.speed.discStatFormattedString()
        }
    }
    var formattedGlide: String {
        get {
            disc.glide.discStatFormattedString()
        }
    }
    var formattedTurn: String {
        get {
            disc.turn.discStatFormattedString()
        }
    }
    var formattedFade: String {
        get {
            disc.fade.discStatFormattedString()
        }
    }
    
    // MARK: - Initializers
    
    init(disc: Disc) {
        self.disc = disc
    }
}

// MARK: - Utility extensions

// This extension houses a function to convert a float into a formatted string
extension Float {
    
    // Convert Float to String and remove decimal value if it is a whole number
    func discStatFormattedString() -> String {
        // Check of the decimal value is zero by comparing the absolute value to the rounded-down absolute value
        if abs(self) == abs(self).rounded(.down) {
            return String(format: "%.0f", self)
        } else {
            return String(format: "%.01f", self)
        }
    }
}
