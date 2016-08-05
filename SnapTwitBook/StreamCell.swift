//
//  StreamCell.swift
//  SnapTwitBook
//
//  Created by Mike Manzano on 7/27/16.
//  Copyright © 2016 Mike Manzano. All rights reserved.
//

import UIKit

class StreamCell: UITableViewCell {

// MARK: Instance
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    func commonSetup() {
        contentView.addSubview(photoView)
        contentView.addSubview(titleLabel)
    }
    
// MARK: Configuration
    
    /// Set to the photo
    var photo: UIImage?
    {
        didSet
        {
            photoView.image = photo
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
// MARK: UI Components
    
    /// Shows the main photo
    let photoView: UIImageView = {
        let v = UIImageView(frame: CGRect.zero)
        v.contentMode = .ScaleAspectFit
        return v
        }()
    
    /// The title
    let titleLabel: UILabel = {
        let v = UILabel(frame: CGRect.zero)
        v.font = UIFont.boldSystemFontOfSize(14)
        v.numberOfLines = 1
        v.backgroundColor = UIColor.whiteColor()
        return v
        }()
    
// MARK: UITableViewCell
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
// MARK: UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let image = photo
        {
            let scaledImageHeight = (image.size.height / image.size.width) * contentView.bounds.size.width
            photoView.frame.size = CGSize(width: contentView.bounds.size.width, height: scaledImageHeight)
        }
        else
        {
            photoView.frame.size = CGSize.zero
        }
        
        titleLabel.frame.size.width = contentView.bounds.size.width - 30
        titleLabel.sizeToFit()
        titleLabel.frame.origin.y = photoView.frame.origin.y + photoView.frame.size.height + 15
        titleLabel.frame.origin.x = 15
    }
    override func sizeThatFits(size: CGSize) -> CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        return CGSize(width: size.width, height: titleLabel.frame.origin.y + titleLabel.frame.size.height + 30)
    }
    
}
