//
//  MapViewController.swift
//  ExchangeAGram
//
//  Created by Clint on 1/20/15.
//  Copyright (c) 2015 Republic. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //access data
        let request = NSFetchRequest(entityName: "FeedItem")
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        
        var error:NSError?
        let itemArray = context.executeFetchRequest(request, error: &error)
        println(error)
        
        if itemArray!.count > 0{
            for item in itemArray! {
                let location = CLLocationCoordinate2D(latitude: Double(item.latitude), longitude: Double(item.longitude))
                //how much should we show
                let span = MKCoordinateSpanMake(0.05, 0.05)
                //where is the center
                let region = MKCoordinateRegionMake(location, span)
                mapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.setCoordinate(location)
                annotation.title = item.caption
                mapView.addAnnotation(annotation)
            }
        }
        
        
        
//        //setting up an 'annotation', which is a red pin on a map
//        
//        //set location for Paris France
//        let location = CLLocationCoordinate2D(latitude: 48.868639224587, longitude: 2.37119161036255)
//        
//        //sets how big map is
//        let span = MKCoordinateSpanMake(0.05, 0.05)
//        
//        //sets where the map is centered
//        let region = MKCoordinateRegionMake(location, span)
//        
//        //finally we set the map
//        mapView.setRegion(region, animated: true)
//    
//        //add an annotation
//        let annotation = MKPointAnnotation()
//        annotation.setCoordinate(location)
//        annotation.title = "Canal Saint-Martin"
//        annotation.subtitle = "Paris"
//        
//        mapView.addAnnotation(annotation)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
