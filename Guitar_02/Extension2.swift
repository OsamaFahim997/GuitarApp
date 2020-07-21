//
//  Extension2.swift
//  Guitar_02
//
//  Created by Jibran Haider on 14/01/2020.
//  Copyright © 2020 Jibran Haider. All rights reserved.
//

import Foundation
import UIKit

extension GuitarViewController{
    func showAlert1(title: String, message: String, handlerYes:((UIAlertAction) -> Void)?, handlerCancel:((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .cancel, handler: handlerYes)
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: handlerCancel)
        alert.addAction(action)
        alert.addAction(actionCancel)
        DispatchQueue.main.async{
            self.present(alert, animated: true, completion: nil)
        }
    }
}
