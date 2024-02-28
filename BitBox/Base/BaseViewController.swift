//
//  BaseViewController.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/28/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorStyle.white
        configureHierarchy()
        configureView()
        configureConstraints()
    }
    
    func configureHierarchy() {}
    func configureView() {}
    func configureConstraints() {}
}
