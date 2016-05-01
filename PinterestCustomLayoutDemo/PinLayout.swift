//
//  PinLayout.swift
//  PinterestCustomLayoutDemo
//
//  Created by Tomer Buzaglo on 21/04/2016.
//  Copyright © 2016 iTomerBu. All rights reserved.
//

import UIKit

//we have 3 tasks:
//1) prapere layout
//2) layoutAttributes for elements in rect
//3) collectionViewContentSize
class PinLayout: UICollectionViewLayout {
    var delegate:PinDelegate?
    var numColumns = 2
    
    var padding:CGFloat = 2
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight:CGFloat = 0 //the final y offset of the tallest column
    private var width:CGFloat{
        return collectionView!.frame.width - collectionView!.contentInset.left  - collectionView!.contentInset.right
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    //called when layout takes place
    //once per orientation
    override func prepareLayout() {
        //super.prepareLayout()
        if cache.isEmpty{
            let numItems = collectionView!.numberOfItemsInSection(0)
            let columnWidth = width / CGFloat(numColumns)
            
            //xOffsets.count = numColumns
            var xOffsets = [CGFloat](count: numColumns, repeatedValue: 0)
            //yOffsets.count = numColumns
            //in the y direction yOffsets are temporary for the iteration below
            var yOffsets = [CGFloat](count: numColumns, repeatedValue: 0)
            
            
            //xOffsets:
            //[0, colwidth, colwidth*2...]
            for col in 0..<numColumns{
                xOffsets[col] = CGFloat(col) * columnWidth
            }
            
            //yOffsets:
            //[0, 0, 0], [heightFromDelegate, heightFromDelegate, heightFromDelegate]
            
            var col = 0
            for item in 0..<numItems {
                let path = NSIndexPath(forItem: item, inSection: 0)
                let height = delegate?.collectionView(collectionView!, heightForItemAtIndexPath: path) ?? 300
                let frame = CGRect(x: xOffsets[col], y: yOffsets[col], width: columnWidth, height: height)
                
                let attr = UICollectionViewLayoutAttributes(forCellWithIndexPath: path)
                ///* Inset `rect' by `(dx, dy)' -- i.e., offset its origin by `(dx, dy)', and decrease its size by `(2*dx, 2*dy)'. */
                let insetFrame = CGRectInset(frame, padding, padding)
                attr.frame = insetFrame
                
                cache.append(attr)
                
                yOffsets[col] = yOffsets[col] + height
                contentHeight = max(contentHeight, CGRectGetMaxY(frame))//Return the topmost y-value of `rect'
                
                col = col >= numColumns - 1 ? 0 : col + 1 //we itereate over items in 0...numItems and col in 0... numColumns
            }
            
        }
    }
    
    //called for each item in the collection View
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return  cache.filter { (attr) -> Bool in
            return CGRectIntersectsRect(rect, attr.frame)
        }
    }
}


protocol PinDelegate{
    func collectionView(collectionView:UICollectionView, heightForItemAtIndexPath indexPath:NSIndexPath)->CGFloat
}