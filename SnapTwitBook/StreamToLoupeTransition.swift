//
//  StreamToLoupeTransition.swift
//  SnapTwitBook
//
//  Created by Mike Manzano on 8/5/16.
//  Copyright © 2016 Mike Manzano. All rights reserved.
//

import UIKit

/// Transitions back and forth from a `StreamViewControler` to a `LoupeViewController`
class StreamToLoupeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
// MARK: Configuration
    
    /// Duration of the transition animation
    var duration: NSTimeInterval = 1
    
    /// Whether `animateTransition()` is animating the destination view controller onto the screen
    var isPresenting = true
    
// MARK: Instance
    
    /// Initialize by specifying whether this is a present or dismiss transition
    /// - parameter isPresenting: `true` if a view controller is presenting, `false` otherwise
    init(isPresenting: Bool) {
        super.init()
        self.isPresenting = isPresenting
    }
    
// MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()

        func transitionViewHierarchy() {
            if isPresenting {
                containerView?.addSubview(toVC.view)
            } else {
                fromVC.view.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        }
        
        if transitionContext.isAnimated() {
            let photoProp = UIImageView(frame: CGRect.zero)
            photoProp.contentMode = .ScaleAspectFit
            containerView?.addSubview(photoProp)
            if  let fromImageTransitionable = fromVC as? ImageTransitionable,
                let toImageTransitionable = toVC as? ImageTransitionable,
                let fromImageRepresentation = fromImageTransitionable.imageRepresentation(),
                let toImageRepresentation = toImageTransitionable.imageRepresentation() {
                
                /// Scene setup
                fromImageTransitionable.showImageRepresentation(false)
                toImageTransitionable.showImageRepresentation(false)
                photoProp.image = fromImageRepresentation.image
                photoProp.frame = containerView?.convertRect(fromImageRepresentation.frameInRootViewCoords, fromView: fromVC.view) ?? CGRect.zero
                if isPresenting {
                    // if we're presenting, add the destination view and set alpha to 0 so we can fade it in later
                    toVC.view.alpha = 0
                    containerView?.addSubview(toVC.view)
                }
                containerView?.bringSubviewToFront(photoProp)

                /// Animate
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .BeginFromCurrentState, animations: {
                    photoProp.frame = containerView?.convertRect(toImageRepresentation.frameInRootViewCoords, fromView: toVC.view) ?? CGRect.zero
                    toVC.view.alpha = 1 // fade in the destination view (has no effect if it's already visible as in the case where we're dismissing)
                    if !self.isPresenting {
                        fromVC.view.alpha = 0 // if we're dismissing, fade out the from view
                    }
                }, completion: {
                    (finished) in
                    photoProp.removeFromSuperview()
                    toImageTransitionable.showImageRepresentation(true)
                    if !self.isPresenting {
                        fromVC.view.removeFromSuperview()
                    }
                    transitionContext.completeTransition(true)
                })
            } else {
                transitionViewHierarchy()
            }
        } else { // isAnimated
            transitionViewHierarchy()
        } // isAnimated
    }
}
