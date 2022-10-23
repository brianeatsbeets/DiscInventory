//
//  DiscTableViewController.swift
//  DiscInventory
//
//  Created by Aguirre, Brian P. on 3/8/22.
//

// MARK: - Imported libraries

import UIKit

// MARK: - Protocols

// This protocol allows conformers to be notified of when the 'In Bag' button is tapped on a DiscTableViewCell
protocol DiscCellDelegate: AnyObject {
    func inBagToggled(sender: DiscTableViewCell)
}

// This protocol allows conformers to remove discs
protocol RemoveDiscDelegate: AnyObject {
    func remove(disc: Disc)
}

// MARK: - Main class

// This class/table view controller provides a table view that displays disc detail cells
class DiscTableViewController: UITableViewController {
    
    // MARK: Properties
    
    let discTableViewModel = DiscTableViewModel()
    private lazy var dataSource = createDataSource()
    
    // MARK: View life cycle functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        tableView.dataSource = dataSource
        
        discTableViewModel.loadDiscs()
        
        updateTableView(animated: true)
    }
    
    // MARK: - Navigation
    
    // Create and return a DiscDetailTableViewController for a new disc or loaded with data for the selected disc
    @IBSegueAction func editDisc(_ coder: NSCoder, sender: Any?) -> DiscDetailTableViewController? {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let discToEdit = dataSource.itemIdentifier(for: indexPath) {
            return DiscDetailTableViewController(coder: coder, discViewModel: DiscViewModel(disc: discToEdit))
        } else {
            return DiscDetailTableViewController(coder: coder, discViewModel: nil)
        }
    }
    
    // Handle the incoming data being passed back from DiscDetailTableViewController, if any
    @IBAction func unwindToDiscList(segue: UIStoryboardSegue) {
        guard segue.identifier == discTableViewModel.unwindIdentifier else { return }
        let sourceViewController = segue.source as!
           DiscDetailTableViewController
        
        // Check to see if we're updating an existing disc or adding a new one
        if let discViewModel = sourceViewController.discViewModel {
            if let indexOfExistingDisc = tableView.indexPathForSelectedRow {
                // Update existing row
                discTableViewModel.updateDisc(at: indexOfExistingDisc.row, with: discViewModel.discForModel())
            } else {
                // Add new row
                discTableViewModel.addDisc(discViewModel.discForModel())
            }
        }
        
        updateTableView(animated: true)
        
        discTableViewModel.saveDiscs()
    }
}

// MARK: - Extensions

// This extension conforms to the DiscCellDelegate protocol in order to update the model when the 'In Bag' button is pressed
extension DiscTableViewController: DiscCellDelegate {
    func inBagToggled(sender: DiscTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            discTableViewModel.toggleInBag(atRow: indexPath.row)
            updateTableView(animated: false)
        }
    }
}

// This extention houses table view management functions using the diffable data source API and conforms to the RemoveDiscDelegate protocol
extension DiscTableViewController: RemoveDiscDelegate {
    
    // Create the the data source and specify what to do with a provided cell
    private func createDataSource() -> DeletableRowTableViewDiffableDataSource {
        
        return DeletableRowTableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, disc in
            
            // Configure the cell
            let cell = tableView.dequeueReusableCell(withIdentifier: self.discTableViewModel.cellIdentifier, for: indexPath) as! DiscTableViewCell
            
            cell.configure(withViewModel: DiscViewModel(disc: disc), delegate: self)

            return cell
        }
    }
    
    // Apply a snapshot with updated disc data
    func updateTableView(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Disc>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(discTableViewModel.discs)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    // Apply a snapshot with removed disc data
    func remove(disc: Disc) {
        
        // Remove disc from discs array
        discTableViewModel.removeDisc(disc)
        
        // Remove disc from the snapshot and apply it
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([disc])
        dataSource.apply(snapshot, animatingDifferences: true)
        
        discTableViewModel.saveDiscs()
    }
}

// MARK: - Enums

// This enum declares table view sections
private enum Section: CaseIterable {
    case one
}

// MARK: - Other classes

// This class defines a UITableViewDiffableDataSource subclass that enables swipe-to-delete
private class DeletableRowTableViewDiffableDataSource: UITableViewDiffableDataSource<Section, Disc> {
    
    // MARK: - Class properties
    
    // Delegate to update data model
    weak var delegate: RemoveDiscDelegate?
    
    // MARK: - Utility functions
    
    // Allow the table view to be edited
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Allow table view rows to be deleted
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let discToDelete = itemIdentifier(for: indexPath) {
            delegate?.remove(disc: discToDelete)
        }
    }
}
