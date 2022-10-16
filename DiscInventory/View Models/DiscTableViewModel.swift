//
//  DiscTableViewModel.swift
//  DiscInventory
//
//  Created by Aguirre, Brian P. on 10/13/22.
//

// MARK: - Main class

// This class represents a view model for DiscTableViewController
class DiscTableViewModel {
    
    // MARK: Properties
    
    var discs = [Disc]()
    let unwindIdentifier = "saveUnwind"
    let cellIdentifier = "DiscCell"
    
    // MARK: - Utility functions
    
    // Load the disc data into the model
    func loadDiscs() {
        if let savedDiscs = Disc.loadDiscs() {
            discs = savedDiscs
        } else {
            print("No discs to load from storage")
        }
        
        // Dummy disc data
//        discs = [
//            Disc(name: "Leopard3", color: .red, type: .fairway, manufacturer: "Innova", plastic: "GStar", weightInGrams: 171.5, speed: 7, glide: 5, turn: -2, fade: 1, condition: .great, notes: "", inBag: true),
//            Disc(name: "Wraith", color: .gray, type: .distance, manufacturer: "Innova", plastic: "Star", weightInGrams: 171, speed: 11, glide: 5, turn: -1, fade: 3, condition: .good, notes: "Found in river", inBag: true)]
    }
    
    // Update disc data in the discs array at a given index
    func updateDisc(at index: Int, with disc: Disc) {
        discs[index] = disc
    }
    
    // Add a disc to the discs array
    func addDisc(_ disc: Disc) {
        discs.append(disc)
    }
    
    // Remove a disc from the discs array
    func removeDisc(_ disc: Disc) {
        discs = discs.filter { $0 != disc }
    }
    
    // Save disc data to storage
    func saveDiscs() {
        Disc.saveDiscs(discs)
    }
    
    // Toggle the 'In Bag' property on a disc at a given index
    func toggleInBag(atRow row: Int) {
        discs[row].inBag.toggle()
        saveDiscs()
    }
}
