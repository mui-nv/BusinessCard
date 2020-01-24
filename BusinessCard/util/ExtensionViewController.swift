//
//  ExtensionViewController.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorDialog(messgae: String) {
        var alert = UIAlertController(title: "ERROR", message: nil, preferredStyle: .alert)
        alert.message = messgae
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
