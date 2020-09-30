//
//  UpdateStudentProtocol.swift
//  Students
//
//  Created by Agil Madinali on 9/28/20.
//

protocol UpdateStudentProtocol: class {
    func updateStudent(student: StudentInfo?, at index: (section:String, row:Int)?)
}
