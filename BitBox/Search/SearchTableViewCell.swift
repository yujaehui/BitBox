//
//  SearchTableViewCell.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/29/24.
//

import UIKit
import SnapKit

class SearchTableViewCell: BaseTableViewCell {
    let thumbImageView = UIImageView()
    let labelStackView = UIStackView()
    let nameLabel = CustomLabel(type: .name)
    let symbolLabel = CustomLabel(type: .symbol)
    let isFavoriteButton = UIButton()
    var buttonAction: (() -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        buttonAction = nil
    }
    
    override func configureHierarchy() {
        contentView.addSubview(thumbImageView)
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(symbolLabel)
        contentView.addSubview(isFavoriteButton)
    }
    
    override func configureView() {
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.distribution = .fillEqually
        isFavoriteButton.tintColor = ColorStyle.purple
        isFavoriteButton.addTarget(self, action: #selector(isFavoriteButtonClicked), for: .touchUpInside)
    }
    
    @objc func isFavoriteButtonClicked() {
        buttonAction?()
    }
    
    override func configureConstraints() {
        thumbImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(16)
            make.size.equalTo(40)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(thumbImageView.snp.trailing).offset(8)
            make.height.equalTo(40)
        }
        
        isFavoriteButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(16)
            make.size.equalTo(25)
        }
    }
    
    func configureCell(currentCell: Coin, searchText: String) {
        let imageURL = URL(string: currentCell.thumb)
        thumbImageView.kf.setImage(with: imageURL)
        nameLabel.attributedText = TextProcessingManager.shared.textColorChange(currentCell.name, changeText: searchText)
        symbolLabel.attributedText = TextProcessingManager.shared.textColorChange(currentCell.symbol, changeText: searchText)
    }
}
