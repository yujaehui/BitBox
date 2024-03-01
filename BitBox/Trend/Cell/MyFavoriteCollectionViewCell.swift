//
//  MyFavoriteCollectionViewCell.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import UIKit
import SnapKit

class MyFavoriteCollectionViewCell: BaseCollectionViewCell {
    let thumbImageView = UIImageView()
    let labelStackView = UIStackView()
    let nameLabel = CustomLabel(type: .name)
    let symbolLabel = CustomLabel(type: .symbol)
    let currentPriceLabel = CustomLabel(type: .price2)
    let priceChangePercentageLabel = CustomLabel(type: .priceChange2)
        
    override func configureHierarchy() {
        contentView.addSubview(thumbImageView)
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(symbolLabel)
        contentView.addSubview(currentPriceLabel)
        contentView.addSubview(priceChangePercentageLabel)
    }
    
    override func configureView() {
        backgroundColor = ColorStyle.lightGray
        layer.cornerRadius = 20
        
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.distribution = .fillEqually
    }
    
    override func configureConstraints() {
        thumbImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(16)
            make.leading.equalTo(contentView).inset(16)
            make.size.equalTo(40)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(16)
            make.leading.equalTo(thumbImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(40)
        }
        
        currentPriceLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(20)
        }
        
        priceChangePercentageLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPriceLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(20)
            make.bottom.equalTo(contentView).inset(16)
        }
    }
    
    func configureCell(currentCell: MarketCoin) {
        let imageURL = URL(string: currentCell.image)
        thumbImageView.kf.setImage(with: imageURL)
        nameLabel.text = currentCell.name
        symbolLabel.text = currentCell.symbol
        currentPriceLabel.text = NumberFormatterManager.shared.dollarFormatter(currentCell.currentPrice)
        priceChangePercentageLabel.text = NumberFormatterManager.shared.percentageFormatter(currentCell.priceChangePercentage24H)
        priceChangePercentageLabel.textColor = currentCell.priceChangePercentage24H >= 0 ? ColorStyle.red : ColorStyle.blue
    }
}
