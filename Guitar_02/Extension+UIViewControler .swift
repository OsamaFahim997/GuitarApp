//
//  Extension+UIViewControler .swift
//  Guitar_02
//
//  Created by Jibran Haider on 13/01/2020.
//  Copyright © 2020 Jibran Haider. All rights reserved.
//

import Foundation
import UIKit

extension GuitarViewController{
    func showAlert(title: String, message: String, handlerYes:((UIAlertAction) -> Void)?, handlerCancel:((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .cancel, handler: handlerYes)
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: handlerCancel)
        alert.addAction(action)
        alert.addAction(actionCancel)
        DispatchQueue.main.async{
        self.present(alert, animated: true, completion: nil)
        }
    }
}
