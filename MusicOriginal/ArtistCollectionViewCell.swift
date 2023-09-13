//
//  ArtistCollectionViewCell.swift
//  MusicOriginal
//
//  Created by Yuri Tsuchikawa on 2023/09/13.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.masksToBounds = true
    }

}
