//
//  HSCycleGalleryViewLayout.swift
//  HSCycleGalleryView
//
//  Created by Hanson on 2018/1/16.
//  Copyright © 2018年 HansonStudio. All rights reserved.
//

import UIKit

class HSCycleGalleryViewLayout: UICollectionViewFlowLayout {
    
    var itemWidth: CGFloat = 290
    var itemHeight: CGFloat = 133
    
    override func prepare() {
        super.prepare()
        
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.scrollDirection = .horizontal
        // 下面 layoutAttributesForElements 中将item scale变换后，自然有空隙了
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        
        // 为了让第一张图片与最后一张图片出现在最中央
        let left = (self.collectionView!.bounds.width - itemWidth) / 2
        let top = (self.collectionView!.bounds.height - itemHeight) / 2
        self.sectionInset = UIEdgeInsets.init(top: top, left: left, bottom: top, right: left)
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array = super.layoutAttributesForElements(in: rect)
        let visiableRect = CGRect(x: self.collectionView!.contentOffset.x,
                                  y: self.collectionView!.contentOffset.y,
                                  width: self.collectionView!.frame.width,
                                  height: self.collectionView!.frame.height)
        
        // 当前屏幕中点，相对于collect view上的x坐标
        let centerX = self.collectionView!.contentOffset.x + self.collectionView!.bounds.width / 2
        
        for attributes in array! {
            if !visiableRect.intersects(attributes.frame) { continue }
            
            let offsetCenterX = abs(attributes.center.x - centerX)
            let scale = max(1 - offsetCenterX / self.collectionView!.bounds.width * 0.4, 0.8)
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        return array
    }
    
    /// 用来设置collectionView停止滚动那一刻的位置(实现目的是当停止滑动，时刻有一张图片是位于屏幕最中央的)
    override func targetContentOffset(forProposedContentOffset
        proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let lastRect = CGRect(x: proposedContentOffset.x, y: proposedContentOffset.y,
                              width: self.collectionView!.bounds.width,
                              height: self.collectionView!.bounds.height)
        // 当前屏幕中点，相对于collect view上的x坐标
        let centerX = proposedContentOffset.x + self.collectionView!.bounds.width * 0.5;
        let array = self.layoutAttributesForElements(in: lastRect)
        
        //需要移动的距离
        var adjustOffsetX = CGFloat(MAXFLOAT);
        for attri in array! {
            //每个单元格里中点的偏移量
            let deviation = attri.center.x - centerX
            //保存偏移最小的那个
            if abs(deviation) < abs(adjustOffsetX) {
                adjustOffsetX = deviation
            }
        }
        // 通过偏移量返回最终停留的位置
        return CGPoint(x: proposedContentOffset.x + adjustOffsetX, y: proposedContentOffset.y)
    }
}

