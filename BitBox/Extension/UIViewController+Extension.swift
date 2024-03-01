//
//  UIViewController+Extension.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import UIKit

extension UIViewController {
    func hideAllSubviews() {
        for subview in self.view.subviews {
            subview.isHidden = true
        }
    }
}
