//
//  FeedItem.swift
//  ExchangeAGram
//
//  Created by Clint on 1/17/15.
//  Copyright (c) 2015 Republic. All rights reserved.
//

import Foundation
import CoreData

@objc (FeedItem)


class FeedItem: NSManagedObject {

    @NSManaged var caption: String
    @NSManaged var image: NSData
    @NSManaged var thumbNail: NSData

}
