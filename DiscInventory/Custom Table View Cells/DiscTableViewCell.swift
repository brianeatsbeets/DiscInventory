//
//  DiscTableViewCell.swift
//  DiscInventory
//
//  Created by Aguirre, Brian P. on 3/11/22.
//

// MARK: - Imported libraries

import UIKit

// MARK: - Main class

// This class/table view cell provides a cell that displays data for a specific disc
class DiscTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: DiscCellDelegate?
    
    // IBOutlets
    
    @IBOutlet var discColorView: UIView!
    @IBOutlet var discImageView: UIImageView!
    @IBOutlet var discNameLabel: UILabel!
    @IBOutlet var discAttributesRowOneLabel: UILabel!
    @IBOutlet var discAttributesRowTwoLabel: UILabel!
    @IBOutlet var inBagButton: UIButton!
    
    // MARK: - Utility functions
    
    func configure(withViewModel discViewModel: DiscViewModel, delegate: DiscCellDelegate) {
        self.delegate = delegate
        
        // Round the color image view corners
        discColorView.layer.cornerRadius = discColorView.frame.width / 2
        discColorView.clipsToBounds = true
        discColorView.backgroundColor = discViewModel.color
        
        // Round the disc image view corners
        discImageView.layer.cornerRadius = discImageView.frame.width / 2
        discImageView.clipsToBounds = true
        discImageView.image = discViewModel.image

        discNameLabel.text = discViewModel.name
        discAttributesRowOneLabel.text = discViewModel.manufacturer + " | " + discViewModel.plastic + " | " + discViewModel.formattedWeight + "g"
        discAttributesRowTwoLabel.text = discViewModel.type.rawValue + " - " + discViewModel.formattedSpeed + " | " + discViewModel.formattedGlide + " | " + discViewModel.formattedTurn + " | " + discViewModel.formattedFade
        inBagButton.isSelected = discViewModel.inBag
    }
    
    @IBAction func inBagButtonTapped() {
        delegate?.inBagToggled(sender: self)
    }
}
