//
//  ImageRepresentation.swift
//  SnapTwitBook
//
//  Created by Mike Manzano on 8/5/16.
//  Copyright © 2016 Mike Manzano. All rights reserved.
//

import UIKit

/// A protocol for objects that can be transitioned by way of a represented image
protocol ImageTransitionable {
    /// Return the image representation for this object and its location in window coordinates
    /// - returns: a touple containing the image and its frame in base window coordinates
    func imageRepresentation() -> (image: UIImage, frameInRootViewCoords: CGRect)?
    /// Hide or show the image representation in this object
    /// - parameter isShown: whether the image representation should be displayed
    func showImageRepresentation(isShown: Bool)
}

// MARK: -

/// Extends `UINavigationController` to support `ImageTransitionable` by passing the
/// protocol through to the top view controller
extension UINavigationController: ImageTransitionable {
    func imageRepresentation() -> (image: UIImage, frameInRootViewCoords: CGRect)? {
        if let transitionable = topViewController as? ImageTransitionable {
            return transitionable.imageRepresentation()
        } else {
            return nil
        }
    }
    func showImageRepresentation(isShown: Bool) {
        if let transitionable = topViewController as? ImageTransitionable {
            transitionable.showImageRepresentation(isShown)
        }
    }
}