//
//  ContactDetailViewController.swift
//  ContactListCK
//
//  Created by Jack Knight on 3/1/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var contact: Contact? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        nameTextField.layer.cornerRadius = 15
        nameTextField.layer.borderWidth = 2.0
        nameTextField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        phoneNumberTextField.layer.cornerRadius = 15
        phoneNumberTextField.layer.borderWidth = 2.0
        phoneNumberTextField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        emailTextField.layer.cornerRadius = 15
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    // MARK: - Setup
    
    func updateViews() {
        if let contact = contact {
            nameTextField.text = contact.name
            phoneNumberTextField.text = contact.phoneNumber
            emailTextField.text = contact.email
            navigationItem.title = contact.name
        } else {
            navigationItem.title = "New Contact"
            nameTextField.text = ""
            phoneNumberTextField.text = ""
            emailTextField.text = ""
        }
    }
    

    @IBAction func saveButtonTapped(_ sender: Any) {
        if nameTextField.text == "" {
            presentEmptyNameAlert()
        } else {
            guard let name = nameTextField.text,
                let phoneNumber = phoneNumberTextField.text,
                let email = emailTextField.text else { return }
            
            if let contact = contact {
                ContactController.shared.update(contact: contact, with: name, phoneNumber: phoneNumber, email: email) { (success) in
                    if success {
                        print("✅ Success updating entry for \(contact.name)! 😁")
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        print("❌ Failed to update entry. 😢")
                    }
                }
            } else {
                ContactController.shared.createContact(with: name, phoneNumber: phoneNumber, email: email) { (success) in
                    if success {
                        print("✅ Success adding new entry! 😁")
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        print("❌ Failed to add new entry. 😢")
                    }
                }
            }
        }
    }
    
    func presentEmptyNameAlert() {
        let emptyNameAlertController = UIAlertController(title: "Oops!", message: "Name Field is Required", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        emptyNameAlertController.addAction(okayAction)
        self.present(emptyNameAlertController, animated: true)
    }
    
    // MARK: - TextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
            navigationItem.title = nameTextField.text
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = nameTextField.text
    }
    

}




