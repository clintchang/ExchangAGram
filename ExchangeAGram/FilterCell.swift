//
//  FilterCell.swift
//  ExchangeAGram
//
//  Created by Clint on 1/16/15.
//  Copyright (c) 2015 Republic. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    //we're creating an imageview for our cell because we're not creating all this in our storyboard
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        //we're adding this funection to our super.init to generate the imageview inside the UICollectionviewCell
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        //add this to our superview
        contentView.addSubview(imageView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
