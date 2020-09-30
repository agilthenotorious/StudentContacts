//
//  EditViewController.swift
//  Students
//
//  Created by Agil Madinali on 9/20/20.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var smallCameraButton: UIButton!
    
    weak var updateDelegate: UpdateStudentProtocol?
    var activeTextField: UITextField?
    var infoArray = [(title: String, info: String, type: TextFieldType)]()
    var student: StudentInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableData()
    }
    
    @IBAction func addProfilePhoto(_ sender: UIButton) {
        self.showImagePickerControllerActionSheet()
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        self.showImagePickerControllerActionSheet()
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        if let isValidFirstName = student?.firstName.isValidName(),
           let isValidLastName = student?.lastName.isValidName(),
           let isValidNumber = student?.phoneNumber.isValidPhoneNumber(),
           let isValidEmail = student?.email.isValidEmail() {
            
            if !isValidFirstName {
                self.showAlert(title: "First Name", message: "Invalid entry: First name should contain letters and is between 3 and 25 letters.")
            } else if !isValidLastName {
                self.showAlert(title: "Last Name", message: "Invalid entry: Last name should contain letters and is between 3 and 25 letters.")
            } else if !isValidNumber {
                self.showAlert(title: "Phone Number", message: "Invalid entry: Phone number should contain numbers and is between 8 and 12 digits.")
            } else if !isValidEmail {
                self.showAlert(title: "Email", message: "Invalid entry: Please enter a valid email.")
            } else {
                self.profileImageView.image = student?.image
                self.updateDelegate?.updateStudent(student: student, at: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setupUI() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.height/2
        self.profileImageView.layer.borderWidth = 1.0
        self.profileImageView.layer.borderColor = UIColor.systemGray.cgColor
        self.smallCameraButton.layer.cornerRadius = self.smallCameraButton.bounds.width/2
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func setupTableData() {
        if let currentStudent = self.student {
            if let image = currentStudent.image {
                self.profileImageView.image = image
            }
            else {
                self.profileImageView.image = UIImage(named: "userprofile")
            }
            self.infoArray.append(("First Name", currentStudent.firstName, type: TextFieldType.firstName))
            self.infoArray.append(("Last Name", currentStudent.lastName, type: TextFieldType.lastName))
            self.infoArray.append(("number", currentStudent.phoneNumber, type: TextFieldType.phone))
            self.infoArray.append(("email", currentStudent.email, type: TextFieldType.email))
            self.title = "Edit Student"
        }
        else {
            self.infoArray.append(("First Name", "", type: TextFieldType.firstName))
            self.infoArray.append(("Last Name", "", type: TextFieldType.lastName))
            self.infoArray.append(("number", "", type: TextFieldType.phone))
            self.infoArray.append(("email", "", type: TextFieldType.email))
            self.title = "Add Student"
            self.student = StudentInfo(firstName: "", lastName: "", phoneNumber: "", email: "", image: nil)
        }
        
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
    }
    
    @objc func dismissKeyboard() {
        self.tableView.contentOffset = .zero
        self.activeTextField = nil
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if let textField = self.activeTextField,
               let tableViewRect = textField.superview?.superview?.frame {
                
                self.tableView.contentInset = UIEdgeInsets(top: self.tableView.contentInset.top, left: 0, bottom: keyboardSize.height, right: 0)
                self.tableView.scrollRectToVisible(tableViewRect, animated: true)
            }
        }
    }
}

extension EditViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let editCell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewCell", for: indexPath) as? EditTableViewCell else { fatalError("Cell cannot be dequeued!")}
        
        let fieldType = self.infoArray[indexPath.row].type
        editCell.editValueTextField.fieldType = fieldType
        editCell.editDelegate = self
        editCell.editValueTextField.delegate = self
        editCell.editValueTextField.keyboardType = .default
        editCell.editValueTextField.clearButtonMode = .whileEditing
        editCell.editValueTextField.autocapitalizationType = .words
        editCell.editValueTextField.accessibilityIdentifier = "name"
        
        switch fieldType {
        case .firstName:
            editCell.editValueTextField.text = self.student?.firstName
        case .lastName:
            editCell.editValueTextField.text = self.student?.lastName
        case .email:
            editCell.editValueTextField.keyboardType = .emailAddress
            editCell.editValueTextField.autocapitalizationType = .none
            editCell.editValueTextField.accessibilityIdentifier = "email"
            editCell.editValueTextField.text = self.student?.email
        case .phone:
            editCell.editValueTextField.keyboardType = .phonePad
            editCell.editValueTextField.accessibilityIdentifier = "phone"
            editCell.editValueTextField.text = self.student?.phoneNumber
        }
        
        editCell.editKeyLabel.text = self.infoArray[indexPath.row].title
        return editCell
    }
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        let alert = UIAlertController(title: "Choose an image", message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Choose from library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take photo", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraAction.isEnabled = false
        }
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.profileImageView.image = editedImage
            self.student?.image = editedImage
        }
        else if let originalImage = info[.originalImage] as? UIImage {
            self.profileImageView.image = originalImage
            self.student?.image = originalImage
        }
        else {
            self.profileImageView.image = UIImage(named: "userprofile")
            self.student?.image = UIImage(named: "userprofile")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditViewController: EditDelegate {    
    
    func modifiedTextField(_ textField: CustomTextField) {
        guard let text = textField.text else { return }
        
        switch textField.fieldType {
        case .firstName:
            self.student?.firstName = text
        case .lastName:
            self.student?.lastName = text
        case .email:
            self.student?.email = text
        case .phone:
            self.student?.phoneNumber = text
        case .none:
            break
        }
    }
}

extension EditViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.lowerBound+1 == range.upperBound { return true }
        
        if textField.accessibilityIdentifier == "name" {
            if textField.text?.count ?? 0 >= 25 { return false }
            
        } else if textField.accessibilityIdentifier == "phone" {
            if textField.text?.count ?? 0 >= 12 { return false }
            if string != "+" && Int(string) == nil { return false }
            
        } else if textField.accessibilityIdentifier == "email" {
            if string == " " || textField.text?.count ?? 0 >= 60 && range.upperBound < 61 { return false }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
}
