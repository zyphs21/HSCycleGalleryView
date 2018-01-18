//
//  HSCycleGalleryView.swift
//  HSCycleGalleryView
//
//  Created by Hanson on 2018/1/16.
//  Copyright © 2018年 HansonStudio. All rights reserved.
//

import UIKit

@objc protocol HSCycleGalleryViewDelegate: class {
    
    func numberOfItemInCycleGalleryView(_ cycleGalleryView: HSCycleGalleryView) -> Int
    
    func cycleGalleryView(_ cycleGalleryView: HSCycleGalleryView, cellForItemAtIndex index: Int) -> UICollectionViewCell
    
    @objc optional func cycleGalleryView(_ cycleGalleryView: HSCycleGalleryView, didSelectItemCell cell: UICollectionViewCell, at Index: Int)
}

class HSCycleGalleryView: UIView {
    
    weak var delegate: HSCycleGalleryViewDelegate?
    
    var collectionView: UICollectionView!
    private let groupCount = 200
    private var indexArr = [Int]()
    var dataNum: Int = 0
    
    var autoScrollInterval: Double = 3
    
    var timer: Timer?
    var currentIndexPath: IndexPath!
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: HSCycleGalleryViewLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            self.removeTimer()
            if self.autoScrollInterval > 0 {
                self.addTimer()
            }
        } else {
            self.removeTimer()
        }
    }
}


// MARK: - Public Function

extension HSCycleGalleryView {
    
    func reloadData() {
        guard let dataNum = delegate?.numberOfItemInCycleGalleryView(self) else { return }
        self.dataNum = dataNum
        indexArr.removeAll()
        for _ in 0 ..< groupCount {
            for j in 0 ..< dataNum {
                indexArr.append(j)
            }
        }
        collectionView.reloadData()
        // Scroll to the middle
        currentIndexPath = IndexPath(item: groupCount / 2 * dataNum, section: 0)
        collectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        self.collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        return cell
    }
}


// MARK: - Private Function

extension HSCycleGalleryView {
    
    func removeTimer() {
        self.timer?.invalidate()
        timer = nil
    }
    
    func addTimer() {
        if timer != nil {
            return
        }
        timer = Timer(timeInterval: autoScrollInterval, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
        //        timer = Timer.scheduledTimer(timeInterval: TimeInterval(autoScrollInterval), target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    @objc func autoScroll() {
        if self.superview == nil || self.window == nil {
            return
        }
        print("timer-autoScroll")
        self.scrollToNextIndex()
    }
    
    private func scrollToNextIndex() {
        var currentIndex = currentIndexPath.row
        if (currentIndex + 1) >= indexArr.count {
            currentIndex = groupCount / 2 * self.dataNum
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        let nextIndex = currentIndex + 1
        collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
        currentIndexPath = IndexPath(item: nextIndex, section: 0)
    }
}

extension HSCycleGalleryView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexArr.count > 0 else { return UICollectionViewCell() }
        let index = indexArr[indexPath.row]
        let dataIndex = index % dataNum
        
        return self.delegate?.cycleGalleryView(self, cellForItemAtIndex: dataIndex) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexArr[indexPath.row]
        let dataIndex = index % dataNum
        let cell = collectionView.cellForItem(at: indexPath) ?? UICollectionViewCell()
        
        delegate?.cycleGalleryView?(self, didSelectItemCell: cell, at: dataIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pointInView = self.convert(collectionView.center, to: collectionView)
        let indexPathNow = collectionView.indexPathForItem(at: pointInView)
        let index = (indexPathNow?.row ?? 0) % dataNum
        // animate stop , locate to the middle
        currentIndexPath = IndexPath(item: groupCount / 2 * dataNum + index, section: 0)
        collectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
}

