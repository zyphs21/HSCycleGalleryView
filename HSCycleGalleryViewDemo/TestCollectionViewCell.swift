//
//  TestCollectionViewCell.swift
//  HSCycleGalleryView
//
//  Created by Hanson on 2018/1/17.
//  Copyright © 2018年 HansonStudio. All rights reserved.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    
    lazy var testLabel: UILabel = {
       let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(testLabel)
        testLabel.center = contentView.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
