//
//  UIViewControllerExtension.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 20/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func showAlertWith(title: String, message: String){
        let alert: UIAlertController = {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            return alert
        }()
        self.present(alert, animated: true, completion: nil)
    }
}
