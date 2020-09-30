//
//  ViewController.swift
//  Students
//
//  Created by Agil Madinali on 9/18/20.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.tableFooterView = UIView()
        }
    }
    
    @IBOutlet weak var emptyListLabel: UILabel!
    
    var sectionArray = [String]()
    var studentArray = [String: [StudentInfo]]() {
        didSet {
            if studentArray.isEmpty {
                self.tableView.isHidden = true
                self.emptyListLabel.isHidden = false
            }
            else {
                self.emptyListLabel.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addNewStudent(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let addVC = sb.instantiateViewController(identifier: "EditViewController") as? EditViewController {
            addVC.updateDelegate = self
            self.present(addVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.isHidden = true
        self.title = "Students"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else { return }
        
        if let index = tableView.indexPathForSelectedRow {
            let key = self.sectionArray[index.section]
            let currentStudent = self.studentArray[key]?[index.row]
            detailVC.student = currentStudent
            detailVC.studentIndex = (section: key, row: index.row)
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sectionArray.count > 0 {
            let key = self.sectionArray[section]
            if let rowCount = self.studentArray[key]?.count {
                return rowCount
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath) as? StudentTableViewCell else { (fatalError("Cell cannot be dequeued!")) }
        
        if self.sectionArray.count > 0 {
            let key = self.sectionArray[indexPath.section]
            
            if let currentStudent = self.studentArray[key]?[indexPath.row] {
                cell.studentNameLabel.text = "\(currentStudent.firstName) \(currentStudent.lastName)"
                
                if let image = currentStudent.image {
                    cell.studentImageView.image = image
                }
                else {
                    cell.studentImageView.image = UIImage(named: "userprofile")
                }
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionArray[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionArray
    }
}

extension ViewController: UpdateStudentProtocol {
    
    func updateStudent(student: StudentInfo?, at index: (section:String, row:Int)?) {
        if let currentStudent = student,
           let firstLetter = currentStudent.firstName.first?.uppercased() {
                
            func insert(firstLetter: String, currentStudent: StudentInfo) {
                if var contactsForSection = self.studentArray[firstLetter] {
                    
                    if contactsForSection.count == 0 {
                        self.sectionArray.append(firstLetter)
                        self.sectionArray.sort()
                    }
                    
                    contactsForSection.append(currentStudent)
                    contactsForSection.sort(by: { "\($0.firstName) \($0.lastName)" < "\($1.firstName) \($1.lastName)" })
                    self.studentArray[firstLetter] = contactsForSection
                }
                else {
                    self.sectionArray.append(firstLetter)
                    self.sectionArray.sort()
                    self.studentArray[firstLetter] = [currentStudent]
                }
            }
            
            if let index = index {
                if index.section == firstLetter {
                    self.studentArray[firstLetter]?[index.row] = currentStudent
                    self.studentArray[firstLetter]?.sort(by: { "\($0.firstName) \($0.lastName)" < "\($1.firstName) \($1.lastName)" })
                }
                else {
                    insert(firstLetter: firstLetter, currentStudent: currentStudent)
                    if self.studentArray[index.section]?.count == 1 {
                        self.sectionArray.remove(at: 0)
                    }
                    self.studentArray[index.section]?.remove(at: index.row)
                }
            }
            else {
                insert(firstLetter: firstLetter, currentStudent: currentStudent)
            }
        }
    }
}
