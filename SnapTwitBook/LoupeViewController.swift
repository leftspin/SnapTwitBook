//
//  LoupeViewController.swift
//  SnapTwitBook
//
//  Created by Mike Manzano on 8/3/16.
//  Copyright © 2016 Mike Manzano. All rights reserved.
//

import UIKit

class LoupeViewController: UIViewController {

// MARK: Constants
    
    /// The velocity that the photo must have when "flicked" to exit the screen
    let escapeVelocity: CGFloat = 300
    
// MARK: Configuration
    
    var photo: UIImage? = nil
    {
        didSet
        {
            photoView.image = photo
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    var closeRequested: (() -> Void)? = nil
    
// MARK: UI Components
    
    let photoView: UIImageView = {
        let v = UIImageView(frame: CGRect.zero)
        v.contentMode = .ScaleAspectFit
        v.userInteractionEnabled = true
        return v
        }()
    let containerView: UIView = {
        let v = UIView(frame: CGRect.zero)
        v.userInteractionEnabled = true
        return v
        }()
    
// MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        
        containerView.addSubview(photoView)
        view.addSubview(containerView)
        
        // If they tap on the background, dismiss
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(LoupeViewController.backgroundTapped(_:)))
        view.addGestureRecognizer(backgroundTap)
        
        // A pan gesture for dragging
        let imagePan = UIPanGestureRecognizer(target: self, action: #selector(LoupeViewController.photoPanned(_:)))
        photoView.addGestureRecognizer(imagePan)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var scaledImageHeight = (4.0 / 3.0) * view.bounds.size.width
        if let image = photo {
            scaledImageHeight = (image.size.height / image.size.width) * view.bounds.size.width
        }
        containerView.frame.size = CGSize(width: view.bounds.size.width, height: scaledImageHeight)
        containerView.frame.origin.y = (view.bounds.size.height - containerView.frame.size.height) / 2.0
        photoView.frame = containerView.bounds
    }
    
// MARK: Display
    
    func bouncePhotoBack() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .BeginFromCurrentState, animations: {
            self.photoView.transform = CGAffineTransformIdentity
            self.view.backgroundColor = UIColor.blackColor()
            }, completion: nil)
    }
    
// MARK: Actions & Handlers
    
    func backgroundTapped(tap: UITapGestureRecognizer) {
        closeRequested?()
    }
    private var currentTranslation = CGPoint.zero
    func photoPanned(pan: UIPanGestureRecognizer) {
        let translation = pan.translationInView(pan.view!)
        currentTranslation = translation // record this for `imageRepresentation()`
        let translationDistance = abs(sqrt((currentTranslation.x * currentTranslation.x) + (currentTranslation.y * currentTranslation.y))) // http://tinyurl.com/gv3lqa8
        switch pan.state {
        case .Began, .Changed:
            pan.view!.transform = CGAffineTransformMakeTranslation(translation.x, translation.y)
            view.backgroundColor = UIColor(white: 0, alpha: max(1 - (translationDistance/view.bounds.size.width), 0))
        case .Ended:
            let velocityXYComponents = pan.velocityInView(pan.view!)
            let velocity = sqrt((velocityXYComponents.x * velocityXYComponents.x) + (velocityXYComponents.y * velocityXYComponents.y)) // http://tinyurl.com/gv3lqa8
            if velocity >= escapeVelocity {
                closeRequested?()
            } else {
                bouncePhotoBack()
            }
        default:
            bouncePhotoBack()
        }
    }
}

// MARK: -

extension LoupeViewController: ImageTransitionable
{
    func imageRepresentation() -> (image: UIImage, frameInRootViewCoords: CGRect)? {
        guard let image = photoView.image else {
            return nil
        }
        return (image, containerView.convertRect(containerView.bounds.offsetBy(dx: currentTranslation.x, dy: currentTranslation.y), toView: view))
    }
    func showImageRepresentation(isShown: Bool) {
        photoView.hidden = !isShown
    }
}
