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
    
    var context:CIContext = CIContext(options: nil)
    
    var filters:[CIFilter] = []
    
    let placeHolderImage = UIImage(named: "Placeholder")
    
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
        
        //user our helper function to get CIfilter instances
        filters = photoFilters()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //function returns the cell at a certain indexpath
        let cell: FilterCell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as FilterCell
        
        if cell.imageView.image == nil {
            
            cell.imageView.image = placeHolderImage
            
            //creating a background queue
            let filterQueue:dispatch_queue_t = dispatch_queue_create("filter queue", nil)
            
            //ALWAYS DO UI CHANGES ON THE MAIN THREAD
            
            //this dispatches to the queue
            dispatch_async(filterQueue, { () -> Void in
                let filterImage = self.filteredImageFromImage(self.thisFeedItem.thumbNail, filter: self.filters[indexPath.row])
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.imageView.image = filterImage
                })
            })
            
        }

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
        
        let composite = CIFilter(name: "CIHardLightBlendMode")
        //this takes in the output of the sepia filter and allows you to send it to the composite with hardlightblendmode
        composite.setValue(sepia.outputImage, forKey: kCIInputImageKey)
        
        let vignette = CIFilter(name: "CIVignette")
        //now we combine this with a vignette
        vignette.setValue(composite.outputImage, forKey: kCIInputImageKey)
        
        //change the intensity of the vignette
        vignette.setValue(kIntensity * 2, forKey: kCIInputIntensityKey)
        
        //sets the radius of the vignette * 30
        vignette.setValue(kIntensity * 30, forKey: kCIInputRadiusKey)
        
        return [blur, instant, noir, transfer, unsharpen, monochrome, colorControls, sepia, colorClamp, composite, vignette]
        
    }
    //helper functions for the filter that takes in the image data and a cifilter instance and returns a UIimage
    
    func filteredImageFromImage (imageData: NSData, filter: CIFilter) -> UIImage {
        
        //ci context instance is reponsible for all the computation of the images
        
        //ci image holds the image data. then we convert a ci image to a uiimage for our use
        
        let unfilteredImage = CIImage(data: imageData)
        filter.setValue(unfilteredImage, forKey: kCIInputImageKey)
        let filteredImage:CIImage = filter.outputImage
        
        //lets us set the image size properly
        let extent = filteredImage.extent()
        let cgImage:CGImageRef = context.createCGImage(filteredImage, fromRect: extent)
        
        let finalImage = UIImage(CGImage: cgImage, scale: 1.0, orientation: UIImageOrientation.Up)
        
        return finalImage!
        
        
    }

}
