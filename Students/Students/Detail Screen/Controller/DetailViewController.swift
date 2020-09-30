//
//  DetailViewController.swift
//  Students
//
//  Created by Agil Madinali on 9/20/20.
//
import MessageUI
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailStudentName: UILabel!
    
    var student: StudentInfo?
    var studentIndex: (section:String, row:Int)?
    var infoList: [(title: String, info: String, type: ProfileButtonType)] = []
    var detailKeyValueArray = [FillDetailTVC]()
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard MFMessageComposeViewController.canSendText() else {
            self.showAlert(title: "Sorry", message: "Message cannot be sent.")
            return
        }
        if let phone = self.student?.phoneNumber {
            let messageComposer = MFMessageComposeViewController()
            messageComposer.messageComposeDelegate = self
            messageComposer.recipients = [phone]
            self.present(messageComposer, animated: true, completion: nil)
        }
    }
    
    @IBAction func call(_ sender: UIButton) {
        if let phone = self.student?.phoneNumber {
            if let url = URL(string: "tel://+\(phone)"),
            UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            else {
                self.showAlert(title: "Sorry", message: "Call cannot be made.")
            }
        }
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            self.showAlert(title: "Sorry", message: "Email cannot be sent.")
            return
        }
        if let email = self.student?.email {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients([email])
            self.present(mailComposer, animated: true, completion: nil)
        }
    }
    
    @IBAction func edit(_ sender: Any) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Student Details"
        setupUI()
        setupInfo()
    }
    
    func setupUI() {
        detailImageView.layer.cornerRadius = self.detailImageView.bounds.width/2
        detailImageView.layer.borderWidth = 1.0
        detailImageView.layer.borderColor = UIColor.systemGray2.cgColor
    }
        
    func setupInfo() {
        if let studentInstance = self.student {
            self.detailKeyValueArray.append(FillDetailTVC(key: "mobile", value:String(studentInstance.phoneNumber)))
            self.detailKeyValueArray.append(FillDetailTVC(key: "email", value: studentInstance.email))
            
            self.detailStudentName.text = "\(studentInstance.firstName) \(studentInstance.lastName)"
            if let image = studentInstance.image {
                self.detailImageView.image = image
            }
            else {
                self.detailImageView.image = UIImage(named: "userprofile")
            }
        }
        
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let editVC = segue.destination as? EditViewController else { return }
        
        editVC.student = student
        editVC.updateDelegate = self
    }
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailKeyValueArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailCell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else { fatalError("Cell cannot be dequeued!") }
        
        detailCell.detailKeyLabel.text = detailKeyValueArray[indexPath.row].key
        detailCell.detailValueLabel.text = detailKeyValueArray[indexPath.row].value
        return detailCell
    }
}

extension DetailViewController: UpdateStudentProtocol {
    
    func updateStudent(student: StudentInfo?, at index: (section:String, row:Int)?) {
        if let studentInstance = student {
            self.student = studentInstance
            self.detailStudentName.text = "\(studentInstance.firstName) \(studentInstance.lastName)"
            self.detailImageView.image = studentInstance.image
            
            for (index, item) in self.infoList.enumerated() {
                if item.type == .phone {
                    self.infoList[index].info = studentInstance.phoneNumber
                } else if item.type == .email {
                    self.infoList[index].info = studentInstance.email
                }
            }
            
            if let index = self.studentIndex,
                let listVC = self.navigationController?.viewControllers[0] as? ViewController {
                listVC.updateStudent(student: self.student, at: index)
            }
        }
    }
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .failed:
            self.showAlert(title: "Sorry", message: "We were unable to send your email :(")
        default:
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension DetailViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result:MessageComposeResult) {
        switch result {
        case .failed:
            self.showAlert(title: "Sorry", message: "We were unable to send your message :(")
        default:
            self.dismiss(animated: true, completion: nil)
        }
    }
}
