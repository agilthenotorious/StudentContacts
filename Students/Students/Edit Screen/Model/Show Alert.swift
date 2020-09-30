//
//  showAlert.swift
//  Students
//
//  Created by Agil Madinali on 9/27/20.
//

import Foundation
import UIKit

extension UIViewController {

    func showAlert(title: String, message: String) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
