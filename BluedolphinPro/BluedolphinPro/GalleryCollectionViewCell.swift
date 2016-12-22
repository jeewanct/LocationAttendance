//
//  GalleryCollectionViewCell.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 15/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setThumbnailImage(_ thumbnailImage: UIImage){
        self.imageView.image = thumbnailImage
//        self.imageView.layer.borderWidth = 1
//        self.imageView.layer.borderColor = UIButton().tintColor.cgColor
    }

}
