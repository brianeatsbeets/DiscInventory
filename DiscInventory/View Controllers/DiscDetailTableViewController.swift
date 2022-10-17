//
//  DiscDetailTableViewController.swift
//  DiscInventory
//
//  Created by Aguirre, Brian P. on 3/9/22.
//

// TODO: Allow manual adjustment of disc image to fit into frame

// MARK: - Imported libraries

import UIKit

// MARK: - Main class

// This class/table view controller provides a table view that displays editable information for a specific disc
class DiscDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var discViewModel: DiscViewModel?
    let utilityTextViewModel = UtilityTextViewModel()
    
    var requiredTextFields = [UITextField]()
    var polarityToolbarTextFields = [UITextField]()
    var activeTextField = UITextField()
    
    let colorPicker = UIColorPickerViewController()
    
    // IBOutlets
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var discColorView: UIView!
    @IBOutlet var discImageView: UIImageView!
    @IBOutlet var typeSegmentedControl: UISegmentedControl!
    @IBOutlet var manufacturerTextField: UITextField!
    @IBOutlet var plasticTextField: UITextField!
    @IBOutlet var speedTextField: UITextField!
    @IBOutlet var glideTextField: UITextField!
    @IBOutlet var turnTextField: UITextField!
    @IBOutlet var fadeTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var conditionSegmentedControl: UISegmentedControl!
    @IBOutlet var notesTextField: UITextField!
    @IBOutlet var inBagSegmentedControl: UISegmentedControl!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    init?(coder: NSCoder, discViewModel: DiscViewModel?) {
        self.discViewModel = discViewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure UIColorPicker
        colorPicker.delegate = self
        colorPicker.supportsAlpha = false
        
        // Compile UITextField arrays for bulk manipulation
        requiredTextFields = [nameTextField, manufacturerTextField, plasticTextField, speedTextField, glideTextField, turnTextField, fadeTextField, weightTextField]
        polarityToolbarTextFields = [speedTextField, glideTextField, turnTextField, fadeTextField]
        
        initializeTextFieldToolbars()
        
        // Round image view corners
        discImageView.layer.cornerRadius = discImageView.frame.width / 2
        discImageView.clipsToBounds = true
        
        updateView()
        updateSaveButtonState()
    }
    
    // MARK: - Utility functions
    
    // Create, configure, and assign UIToolbars
    func initializeTextFieldToolbars() {
        
        let polarityDoneButton = UIBarButtonItem(title: utilityTextViewModel.doneButtonTitle, style: .done, target: self, action: #selector(toolbarDoneButtonTapped))
        let polarityButton = UIBarButtonItem(title: utilityTextViewModel.polarityButtonTitle, style: .plain, target: self, action: #selector(toolbarPolarityButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let polarityToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 35)) // Using initializer with frame silences some constraint warnings; toolbar is sized appropriately below down using .sizeToFit()
        polarityToolbar.items = [polarityButton, flexSpace, polarityDoneButton]
        polarityToolbar.sizeToFit()
        
        for textField in polarityToolbarTextFields {
            textField.inputAccessoryView = polarityToolbar
            textField.delegate = self
        }
        
        let doneButton = UIBarButtonItem(title: utilityTextViewModel.doneButtonTitle, style: .done, target: self, action: #selector(toolbarDoneButtonTapped))
        
        let doneToolbar = UIToolbar()
        doneToolbar.items = [flexSpace, doneButton]
        doneToolbar.sizeToFit()
        
        weightTextField.inputAccessoryView = doneToolbar
    }
    
    // Load disc data if editing a disc
    func updateView() {
        guard let discViewModel = discViewModel else { return }
        
        navigationItem.title = utilityTextViewModel.editDiscNavigationTitle
        updateDiscColor()
        updateDiscImage()
        nameTextField.text = discViewModel.name
        typeSegmentedControl.selectedSegmentIndex = discViewModel.type.getIndex()
        manufacturerTextField.text = discViewModel.manufacturer
        plasticTextField.text = discViewModel.plastic
        speedTextField.text = discViewModel.formattedSpeed
        glideTextField.text = discViewModel.formattedGlide
        turnTextField.text = discViewModel.formattedTurn
        fadeTextField.text = discViewModel.formattedFade
        weightTextField.text = discViewModel.formattedWeight
        conditionSegmentedControl.selectedSegmentIndex = discViewModel.condition.getIndex()
        notesTextField.text = discViewModel.notes
        inBagSegmentedControl.selectedSegmentIndex = discViewModel.inBag ? 0 : 1
    }
    
    // Toggle save button interatability based on textField validation
    func updateSaveButtonState() {
        var shouldEnableSaveButton = true
        for textField in requiredTextFields {
            if textField.text!.isEmpty {
                shouldEnableSaveButton = false
            }
        }
        
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    // Load disc color and set UIColorPicker default color
    func updateDiscColor() {
        if let discViewModel = discViewModel {
            discColorView.backgroundColor = discViewModel.color
            colorPicker.selectedColor = discViewModel.color
        } else {
            discColorView.backgroundColor = .white
            colorPicker.selectedColor = .white
        }
    }
    
    // Load disc image
    func updateDiscImage() {
        if let discViewModel = discViewModel, discViewModel.image != nil {
            discImageView.image = discViewModel.image
        } else {
            discImageView.image = nil
        }
    }
    
    // Create and present UIImagePicker for disc image selection
    @IBAction func updateDiscImageButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Add camera action if available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: utilityTextViewModel.cameraActionTitle, style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        // Add photo library action if available
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: utilityTextViewModel.photoLibraryActionTitle, style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        // Add cancel action
        let cancelAction = UIAlertAction(title: utilityTextViewModel.cancelActionTitle, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Clear the disc image
    @IBAction func clearDiscImageButtonTapped(_ sender: Any) {
        discImageView.image = nil
    }
    
    // Present the UIColorPicker for disc color selection
    @IBAction func updateDiscColorButtonTapped(_ sender: Any) {
        present(colorPicker, animated: true, completion: nil)
    }
    
    // MARK: - TextField functions
    
    // Update the save button interactability based on textField validation
    // TODO: only allow input of up to one decimal place
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // Dismiss keyboard when done key is pressed
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // Dismiss keyboard when toolbar done button is tapped
    @objc func toolbarDoneButtonTapped() {
        view.endEditing(true)
    }
    
    // Toggle polarity of textField when toolbar polarity button is tapped
    @objc func toolbarPolarityButtonTapped() {
        let textField = activeTextField
        if textField.text?.first == "-" {
            textField.text?.remove(at: textField.text!.startIndex)
        } else {
            textField.text = "-" + textField.text!
        }
    }
    
    // MARK: - Navigation
    
    // Edit/create and save the disc object, then navigate back to DiscTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        if discViewModel != nil {
            discViewModel!.name = nameTextField.text!
            discViewModel!.color = discColorView.backgroundColor!
            discViewModel!.imageData = discImageView.image?.jpegData(compressionQuality: 0.9) ?? nil
            discViewModel!.type = DiscType.allCases[typeSegmentedControl.selectedSegmentIndex]
            discViewModel!.manufacturer = manufacturerTextField.text!
            discViewModel!.plastic = plasticTextField.text!
            discViewModel!.speed = Float(speedTextField.text!) ?? 0
            discViewModel!.glide = Float(glideTextField.text!) ?? 0
            discViewModel!.turn = Float(turnTextField.text!) ?? 0
            discViewModel!.fade = Float(fadeTextField.text!) ?? 0
            discViewModel!.weight = Float(weightTextField.text!) ?? 0
            discViewModel!.condition = Condition.allCases[conditionSegmentedControl.selectedSegmentIndex]
            discViewModel!.notes = notesTextField.text ?? ""
            discViewModel!.inBag = inBagSegmentedControl.selectedSegmentIndex == 0
        } else {
            let name = nameTextField.text!
            let color = discColorView.backgroundColor!
            let imageData = discImageView.image?.jpegData(compressionQuality: 0.9) ?? nil
            let type = DiscType.allCases[typeSegmentedControl.selectedSegmentIndex]
            let manufacturer = manufacturerTextField.text!
            let plastic = plasticTextField.text!
            let speed = Float(speedTextField.text!) ?? 0
            let glide = Float(glideTextField.text!) ?? 0
            let turn = Float(turnTextField.text!) ?? 0
            let fade = Float(fadeTextField.text!) ?? 0
            let weight = Float(weightTextField.text!) ?? 0
            let condition = Condition.allCases[conditionSegmentedControl.selectedSegmentIndex]
            let notes = notesTextField.text ?? ""
            let inBag = inBagSegmentedControl.selectedSegmentIndex == 0
            
            discViewModel = DiscViewModel(disc: Disc(name: name, color: color, imageData: imageData, type: type, manufacturer: manufacturer, plastic: plastic, weightInGrams: weight, speed: speed, glide: glide, turn: turn, fade: fade, condition: condition, notes: notes, inBag: inBag))
        }
    }
}
    
// MARK: - Extensions

// This extension conforms to the UIImagePickerControllerDelegate and UINavigationControllerDelegate protocols to allow the user to assign an image to a disc
extension DiscDetailTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Set the disc image to the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        discImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    // Dismiss the UIImagePicker when cancel is pressed
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// This extension conforms to the UIColorPickerViewControllerDelegate protocol to allow the user to assign a color to a disc
extension DiscDetailTableViewController: UIColorPickerViewControllerDelegate {
    
    // Set the disc color to the selected color upon exit
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.discColorView.backgroundColor = viewController.selectedColor
    }
}

// This extension conforms to the UITextFieldDelegate protocol to be aware of the text field that is currently being edited
extension DiscDetailTableViewController: UITextFieldDelegate {
    
    // Set the active textField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}
