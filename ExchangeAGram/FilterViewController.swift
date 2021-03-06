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
    
    let tmp = NSTemporaryDirectory()
    
    
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
        
        
            
        cell.imageView.image = placeHolderImage
        
        //creating a background queue
        let filterQueue:dispatch_queue_t = dispatch_queue_create("filter queue", nil)
        
        //ALWAYS DO UI CHANGES ON THE MAIN THREAD
        
        //this dispatches to the queue
        dispatch_async(filterQueue, { () -> Void in
            
            let filterImage = self.getCachedImage(indexPath.row)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.imageView.image = filterImage
            })
        })
            
        

        return cell
        
    }
    
    //UICollectionviewDelegate
    
    //function for saving a filtered image
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        createUIAlertController(indexPath)
        
        
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
        
//        let colorClamp = CIFilter(name: "CIColorClamp")
//        colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9), forKey: "inputMaxComponents")
//        colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2), forKey: "inputMinComponents")
        
        let colorClamp = CIFilter(name: "CIColorClamp")
        colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
        colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
        
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
        
//        return [blur, instant, noir, transfer, unsharpen, monochrome, colorControls, sepia, **colorClamp, composite, vignette]
        return [blur, instant, noir, transfer, unsharpen, monochrome, colorControls, sepia, composite, vignette, colorClamp]
        
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

    //UIAlertController Helper Functions
    
    func createUIAlertController (indexPath: NSIndexPath) {
        
        //create a basic alert
        let alert = UIAlertController(title: "Photo Options", message: "Please choose an option", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        //this creates a field to enter your caption text
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Add Caption!"
            
            //this is just an extra paramenter that isn't necessary. you can have secure text entry if you want
            textField.secureTextEntry = false
        }
        
        var text:String
        //need to specify as UITextField so compiler knows what to expect
        let textField = alert.textFields![0] as UITextField
        
        
        let photoAction = UIAlertAction(title: "Post Photo to Facebook with Caption", style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
            self.shareToFacebook(indexPath)
            var text = textField.text
            self.saveFilterToCoreData(indexPath, caption: text)
            
        }
        
        alert.addAction(photoAction)
        
        let saveFilterAction = UIAlertAction(title: "Save Filter without posting on Facebook", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            var text = textField.text
            self.saveFilterToCoreData(indexPath, caption: text)
            
        }
        
        alert.addAction(saveFilterAction)
        
        let cancelAction = UIAlertAction(title: "Select another Filter", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            
        }
        
        alert.addAction(cancelAction)
        
        //you must display the alert
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func saveFilterToCoreData (indexPath: NSIndexPath, caption: String) {
        
        //we need to filter the full-size image
        let filterImage = self.filteredImageFromImage(self.thisFeedItem.image, filter: self.filters[indexPath.row])
        
        //compress the filtered image into jpg
        let imageData = UIImageJPEGRepresentation(filterImage, 1.0)
        
        //update our image
        self.thisFeedItem.image = imageData
        
        //update our thumbnail of our image with jpg compression
        let thumbNailData = UIImageJPEGRepresentation(filterImage, 0.1)
        self.thisFeedItem.thumbNail = thumbNailData
        
        self.thisFeedItem.caption = caption
        self.thisFeedItem.filtered = true
        
        //save our stuff
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
        self.navigationController?.popViewControllerAnimated(true)

        
    }
    
    
    func shareToFacebook (indexPath: NSIndexPath) {
        
        //this returns a UIimage instance
        let filterImage = self.filteredImageFromImage(self.thisFeedItem.image, filter: self.filters[indexPath.row])
        
        //we have to create this array because ___ expects an array
        let photos:NSArray = [filterImage]
        var params = FBPhotoParams()
        params.photos = photos
        
        FBDialogs.presentShareDialogWithPhotoParams(params, clientState: nil) { (call, result, error) -> Void in
            if (result? != nil) {
                println (result)
            } else {
                println (error)
            }
        }
        
        
    }
    
    
    //caching functions
    
    
    //this create a cached image
    func cacheImage(imageNumber: Int) {
        
        //filename will just be a number
        let fileName = "\(thisFeedItem.uniqueID)\(imageNumber)"
        let uniquePath = tmp.stringByAppendingPathComponent(fileName)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(fileName) {
            
            let data = self.thisFeedItem.thumbNail
            let filter = self.filters[imageNumber]
            let image = filteredImageFromImage(data, filter: filter)
            UIImageJPEGRepresentation(image, 1.0).writeToFile(uniquePath, atomically: true)
            
        }
        
    }
    
    //this helper function
    func getCachedImage (imageNumber: Int) -> UIImage {
        
        //filename will just be a number
        let fileName = "\(thisFeedItem.uniqueID)\(imageNumber)"
        let uniquePath = tmp.stringByAppendingPathComponent(fileName)
        
        var image:UIImage
        
        //check if file exists already.  if it does we used the cached one. if not, we call the cache function to create one
        if NSFileManager.defaultManager().fileExistsAtPath(uniquePath) {
            var returnedImage = UIImage(contentsOfFile: uniquePath)!
            image = UIImage(CGImage: returnedImage.CGImage, scale: 1.0, orientation: UIImageOrientation.Right)!
        } else {
            self.cacheImage(imageNumber)
            var returnedImage = UIImage(contentsOfFile: uniquePath)!
            image = UIImage(CGImage: returnedImage.CGImage, scale: 1.0, orientation: UIImageOrientation.Right)!
        }
        
        return image
        
    }
    
    
}
