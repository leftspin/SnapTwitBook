//
//  ViewController.swift
//  SnapTwitBook
//
//  Created by Mike Manzano on 7/27/16.
//  Copyright © 2016 Mike Manzano. All rights reserved.
//

import UIKit

class StreamViewController: UITableViewController, UIViewControllerTransitioningDelegate, ImageTransitionable
{

// MARK: Constants
    
    let streamCellIdentifier = "streamCellIdentifier"
    
// MARK: State
    
    var photoURLs: [NSURL] = []
    
// MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SnapTwitBook"
        tableView.registerClass(StreamCell.self, forCellReuseIdentifier: streamCellIdentifier)
        photoURLs = PhotoManager.photoURLs
        tableView.estimatedRowHeight = 339
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }

// MARK: UITableView Delegate & Datasource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoURLs.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(streamCellIdentifier, forIndexPath: indexPath) as! StreamCell
        cell.titleLabel.text = (photoURLs[indexPath.row].relativePath! as NSString).lastPathComponent
        cell.photo = UIImage(contentsOfFile: photoURLs[indexPath.row].path!)
        cell.photoView.hidden = indexPath == indexPathOfHiddenCell
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    let sizingCell = StreamCell(frame: CGRect.zero)
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        sizingCell.titleLabel.text = (photoURLs[indexPath.row].relativePath! as NSString).lastPathComponent
        sizingCell.photo = UIImage(contentsOfFile: photoURLs[indexPath.row].path!)
        sizingCell.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: sizingCell.bounds.size.height)
        return sizingCell.sizeThatFits(sizingCell.frame.size).height
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let loupeVC = LoupeViewController(nibName: nil, bundle: nil)
        loupeVC.photo = UIImage(contentsOfFile: photoURLs[indexPath.row].path!)
        loupeVC.closeRequested = {
            [weak self] in
            if let actualSelf = self {
                actualSelf.transitioningDelegate = actualSelf
            }
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        loupeVC.modalPresentationStyle = .Custom // Enable custom transition on present
        loupeVC.transitioningDelegate = self
        presentViewController(loupeVC, animated: true, completion: nil)
    }
    
// MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return StreamToLoupeTransition(isPresenting: true)
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return StreamToLoupeTransition(isPresenting: false)
    }
//    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
//        
//    }
    
// MARK: ImageTransitionable
    
    func imageRepresentation() -> (image: UIImage, frameInRootViewCoords: CGRect)? {
        if  let selectedIndexPath = tableView.indexPathForSelectedRow,
            let selectedCell = tableView.cellForRowAtIndexPath(selectedIndexPath) as? StreamCell,
            let image = selectedCell.photoView.image {
            let photoView = selectedCell.photoView
            let photoViewFrameInTableCoords = tableView.convertRect(photoView.bounds, fromView: photoView)
            let photoViewFrameOffsetFromVisibleBounds = photoViewFrameInTableCoords.offsetBy(dx: 0, dy: -tableView.bounds.origin.y)
            return (image, photoViewFrameOffsetFromVisibleBounds)
        } else {
            return nil
        }
    }
    private var indexPathOfHiddenCell: NSIndexPath? = nil
    func showImageRepresentation(isShown: Bool) {
        if  let selectedIndexPath = tableView.indexPathForSelectedRow,
            let selectedCell = tableView.cellForRowAtIndexPath(selectedIndexPath) as? StreamCell {
            selectedCell.photoView.hidden = !isShown
            indexPathOfHiddenCell = isShown ? nil : selectedIndexPath
        }
    }
}

