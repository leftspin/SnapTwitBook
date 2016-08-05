//
//  PhotoManager.swift
//  SnapTwitBook
//
//  Created by Mike Manzano on 8/3/16.
//  Copyright © 2016 Mike Manzano. All rights reserved.
//

import UIKit

class PhotoManager
{
    static var photoURLs: [NSURL] = []
    static func loadPhotoURLs()
    {
        guard let photosPath = NSBundle.mainBundle().pathForResource("photos", ofType: nil) else {
            print("Could not find the photos path")
            return
        }

        let photosURL = NSURL(fileURLWithPath: photosPath)
        
        do
        {
            photoURLs = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(photosURL, includingPropertiesForKeys: nil, options: [])
        }
        catch let e as NSError
        {
            print("\(e)")
        }
    }
}