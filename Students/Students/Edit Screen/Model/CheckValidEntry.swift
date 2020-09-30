//
//  CheckValidEntry.swift
//  Students
//
//  Created by Agil Madinali on 9/28/20.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        let numRegEx = "[0-9]{8,12}"
        let numPred = NSPredicate(format:"SELF MATCHES %@", numRegEx)
        return numPred.evaluate(with: self)
    }
    
    func isValidName() -> Bool {
        let nameRegEx = "[A-Za-z]{3,25}"
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: self)
    }
}
