//
//  FeedViewController.swift
//  ExchangeAGram
//
//  Created by Clint on 1/13/15.
//  Copyright (c) 2015 Republic. All rights reserved.
//

import UIKit
//in buildphases we import this so we can access the photo taking functions framework - gives us the uiimagepickercontroller, camera and photo library
import MobileCoreServices

//add the protocols for UICollectionViewDataSource and UICollectionViewDelegate
class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //this is the camera button being pressed
    @IBAction func snapBarButtonItemTapped(sender: UIBarButtonItem) {
        
        //check if camera is available. it won't be available on ios simulator - only on device
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            //this is a special type of a ui nav controller that allows us to access movies, pictures, and the libaries for both of these
            var cameraController = UIImagePickerController()
            //need to designate self so it knows which views to send the pictures
            cameraController.delegate = self
            //specify what kind of source type we'll be using since we know it's available (checked above)
            cameraController.sourceType = UIImagePickerControllerSourceType.Camera
            
            //specify media types that the controller will be accessing
            let mediaTypes:[AnyObject] = [kUTTypeImage]
            //will always do this when working with camera
            cameraController.mediaTypes = mediaTypes
            //won't let user do editing of photos
            cameraController.allowsEditing = false
            
            //present on screen
            self.presentViewController(cameraController, animated: true, completion: nil)
        } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            //we're going to use the photo library since we won't have camera access
            //set our controller
            var photoLibraryController = UIImagePickerController()
            photoLibraryController.delegate = self
            photoLibraryController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            let mediaTypes:[AnyObject] = [kUTTypeImage]
            photoLibraryController.mediaTypes = mediaTypes
            photoLibraryController.allowsEditing = false
            
            self.presentViewController(photoLibraryController, animated: true, completion: nil)
            
        } else {
            
            //alert if we can't access the camera or photo library
            var alertController = UIAlertController(title: "Alert", message: "Your device does not support the camera or photo library.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    // UIIMagePickerController Delegate - tells us which photo we picked
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        //this is a dict so we need to pull out the image via a key
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        //dismiss the imagepicker controller so we can go back to our feedview controller
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    // UICollectionViewDataSource - need to fill out these functions required in the protocol
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
 
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
