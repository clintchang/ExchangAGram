//
//  FeedItem.swift
//  ExchangeAGram
//
//  Created by Clint on 1/14/15.
//  Copyright (c) 2015 Republic. All rights reserved.
//

import Foundation
import CoreData

@objc (FeedItem)


//The feed item will be used to store our photos after editing them.
class FeedItem: NSManagedObject {

    @NSManaged var caption: String
    @NSManaged var image: NSData

}
