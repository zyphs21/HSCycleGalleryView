//
//  ViewController.swift
//  HSCycleGalleryViewDemo
//
//  Created by Hanson on 2018/1/18.
//  Copyright © 2018年 HansonStudio. All rights reserved.
//

import UIKit
import HSCycleGalleryView

class ViewController: UIViewController {

    let colors: [UIColor] = [.cyan, .blue, .green, .red]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pager = HSCycleGalleryView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 200))
        pager.register(TestCollectionViewCell.self, forCellReuseIdentifier: "TestCollectionViewCell")
        pager.delegate = self
        self.view.addSubview(pager)
        pager.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: HSCycleGalleryViewDelegate {
    
    func numberOfItemInCycleGalleryView(_ cycleGalleryView: HSCycleGalleryView) -> Int {
        return colors.count
    }
    
    func cycleGalleryView(_ cycleGalleryView: HSCycleGalleryView, cellForItemAtIndex index: Int) -> UICollectionViewCell {
        let cell = cycleGalleryView.dequeueReusableCell(withIdentifier: "TestCollectionViewCell", for: IndexPath(item: index, section: 0))
        cell.backgroundColor = colors[index]
        return cell
    }
    
}

