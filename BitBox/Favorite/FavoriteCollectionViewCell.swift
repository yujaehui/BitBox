//
//  FavoriteCollectionViewCell.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import UIKit

class FavoriteCollectionViewCell: BaseCollectionViewCell {
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
        layer.cornerRadius = 20
        layer.shadowColor = ColorStyle.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.distribution = .fillEqually
        
        currentPriceLabel.textAlignment = .right
        
        priceChangePercentageLabel.textAlignment = .center
        priceChangePercentageLabel.clipsToBounds = true
        priceChangePercentageLabel.layer.cornerRadius = 5
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
            make.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(20)
            make.width.equalTo(70)
            make.bottom.equalTo(contentView).inset(16)
        }
    }
    
    func configureCell(currentCell: MarketCoin) {
        let imageURL = URL(string: currentCell.image)
        thumbImageView.kf.setImage(with: imageURL)
        nameLabel.text = currentCell.name
        symbolLabel.text = currentCell.symbol.uppercased()
        currentPriceLabel.text = NumberFormatterManager.shared.dollarFormatter(currentCell.currentPrice)
        priceChangePercentageLabel.text = NumberFormatterManager.shared.percentageFormatter(currentCell.priceChangePercentage24H)
        priceChangePercentageLabel.textColor = currentCell.priceChangePercentage24H >= 0 ? ColorStyle.red : ColorStyle.blue
        priceChangePercentageLabel.backgroundColor = currentCell.priceChangePercentage24H >= 0 ? ColorStyle.babyPink : ColorStyle.skyBlue
    }
}
