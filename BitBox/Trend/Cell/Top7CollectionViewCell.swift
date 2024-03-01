//
//  Top7CollectionViewCell.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/2/24.
//

import UIKit
import SnapKit

class Top7CollectionViewCell: BaseCollectionViewCell {
    let rankLabel = CustomLabel(type: .rank)
    let thumbImageView = UIImageView()
    let infoStackView = UIStackView()
    let nameLabel = CustomLabel(type: .name)
    let symbolLabel = CustomLabel(type: .symbol)
    let priceStackView = UIStackView()
    let priceLabel = CustomLabel(type: .price3)
    let priceChangePercentageLabel = CustomLabel(type: .priceChange3)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.setupBottomBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        contentView.addSubview(rankLabel)
        contentView.addSubview(thumbImageView)
        contentView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(symbolLabel)
        contentView.addSubview(priceStackView)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceChangePercentageLabel)
    }
    
    override func configureView() {
        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.distribution = .fill
        
        priceStackView.axis = .vertical
        priceStackView.alignment = .leading
        priceStackView.distribution = .fill
        priceStackView.alignment = .trailing
    }
    
    override func configureConstraints() {
        rankLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(8)
        }
        
        thumbImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(rankLabel.snp.trailing).offset(8)
            make.size.equalTo(40)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(thumbImageView.snp.trailing).offset(8)
            make.height.equalTo(40)
            make.width.equalTo(150)
        }
        
        priceStackView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.height.equalTo(40)
            make.trailing.equalTo(contentView).inset(8)
        }
    }
    
    func configureCell(row: Int, currentCell: TopNFT) {
        rankLabel.text = "\(row+1)"
        let imageURL = URL(string: currentCell.thumb)
        thumbImageView.kf.setImage(with: imageURL)
        nameLabel.text = currentCell.name
        symbolLabel.text = currentCell.symbol
        priceLabel.text = currentCell.data.floorPrice
        priceChangePercentageLabel.text = NumberFormatterManager.shared.percentageFormatter(currentCell.floorPrice24hPercentageChange)
        priceChangePercentageLabel.textColor = currentCell.floorPrice24hPercentageChange >= 0 ? ColorStyle.red : ColorStyle.blue
    }
}
