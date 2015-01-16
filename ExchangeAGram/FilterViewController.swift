//
//  FilterViewController.swift
//  ExchangeAGram
//
//  Created by Clint on 1/16/15.
//  Copyright (c) 2015 Republic. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //we'll be passing in a feeditem into this filterviewcontroller to run a filter
    var thisFeedItem:FeedItem!
    
    //we're going to create our own collection view just to see how it's done
    var collectionView: UICollectionView!
    
    //set our intensity constant
    let kIntensity = 0.7
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 150.0, height: 150.0)
        //now we set the collectionview. self.view.frame = full size of screen regardless of device
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        //now we set the delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        //set background color
        collectionView.backgroundColor = UIColor.whiteColor()
        //need to register our FilterCell with the filterviewcontroller
        collectionView.registerClass(FilterCell.self, forCellWithReuseIdentifier: "MyCell")
        
        self.view.addSubview(collectionView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //function returns the cell at a certain indexpath
        let cell: FilterCell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as FilterCell
        cell.imageView.image = UIImage(named: "Placeholder")
        return cell
        
    }
    
    //Helper Function
    
    func photoFilters() -> [CIFilter] {
        //create a bunch of filters
        let blur = CIFilter(name: "CIGaussianBlur")
        let instant = CIFilter(name: "CIPhotoEffectInstant")
        let noir = CIFilter(name: "CIPhotoEffectNoir")
        let transfer = CIFilter(name: "CIPhotoEffectTransfer")
        let unsharpen = CIFilter(name: "CIUnsharpMask")
        let monochrome = CIFilter(name: "CIColorMonochrome")
        
        let colorControls = CIFilter(name: "CIColorControls")
        colorControls.setValue(0.5, forKey: kCIInputSaturationKey)
        
        let sepia = CIFilter(name: "CISepiaTone")
        sepia.setValue(kIntensity, forKey: kCIInputIntensityKey)
        
        let colorClamp = CIFilter(name: "CIColorClamp")
        colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9), forKey: "inputMaxComponents")
        colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2), forKey: "inputMinComponents")
        
        return []
        
    }
    

}
