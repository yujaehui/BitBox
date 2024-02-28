//
//  BaseCollectionViewCell.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/28/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorStyle.white
        configureHierarchy()
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {}
    func configureView() {}
    func configureConstraints() {}
    func setupBottomBorder() {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = ColorStyle.lightGray.cgColor
        borderLayer.frame = CGRect(x: 8, y: contentView.frame.height - 1, width: contentView.frame.width - 8, height: 1)
        contentView.layer.addSublayer(borderLayer)
    }
}
