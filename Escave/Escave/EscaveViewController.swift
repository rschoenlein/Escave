//
//  ViewController.swift
//  Escave
//
//  Created by Ryan Schoenlein on 5/15/19.
//  Copyright © 2019 Ryan Schoenlein. All rights reserved.
//

import UIKit
import os.log

//class inherits from UIViewController, UITextFieldDelegate(delegate = object that acts in coordination with another object)
class EscaveViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    //MARK: Properties
    //store references to ojects on storyboard
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    //variable of type Hunt (defined in Hunt.swift)
    var hunt: Hunt?
    
    //called when app is first loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Handle the text field’s user input through delegate(object acting in coordination with another object) callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Hunt.
        if let hunt = hunt {
            navigationItem.title = hunt.name
            nameTextField.text = hunt.name
            photoImageView.image = hunt.photo
            ratingControl.rating = hunt.rating
        }
        
        // Enable the Save button only if the text field has a valid Hunt name.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    //Delegate: design pattern to communicate between two objects often an object back to its owner
    //in this case the UITextField is communicating with the Escave view controller
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    //called when user taps image pickers cancel button
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    //called when user selects an image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    //Functions that define navigation between views
    //IBAction attribute means function is an action connected to storyboard
    //sender refers to object responsible for sending action
    
    //cancels editing of hunt item, navigates back to UITableView
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddHuntMode = presentingViewController is UINavigationController
        
        if isPresentingInAddHuntMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The HuntViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the hunt to be passed to HuntTableViewController after the unwind segue.
        hunt = Hunt(name: name, photo: photo, rating: rating)
    }
    
    //MARK: Actions
    //IBAction attribute means function is an action connected to storyboard
    //sender refers to object responsible for sending action
    
    //Called on tap action
    //selects image from library and applies it to hunt item
    @IBAction func seleectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    //enable or disable save button state depending on if text is entered into text field
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
