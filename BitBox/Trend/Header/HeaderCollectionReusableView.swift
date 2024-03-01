//
//  HeaderCollectionReusableView.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import UIKit
import SnapKit

class HeaderCollectionReusableView: BaseCollectionReusableView {
    let headerLabel = CustomLabel(type: .header)
    
    override func configureHierarchy() {
        addSubview(headerLabel)
    }
    
    override func configureConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(8)
        }
    }
}
