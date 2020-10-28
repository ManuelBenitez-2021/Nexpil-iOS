//
//  PhotoCollectionViewCell.swift
//  Nexpil
//
//  Created by Admin on 07/07/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import Photos

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configureWithModel(_ model: PHAsset) {
        
        if tag != 0 {
            PHImageManager.default().cancelImageRequest(PHImageRequestID(tag))
        }
        
        tag = Int(PHImageManager.default().requestImage(for: model, targetSize: contentView.bounds.size, contentMode: .aspectFill, options: nil) { image, info in
            self.imageView.image = image
        })
    }
}
