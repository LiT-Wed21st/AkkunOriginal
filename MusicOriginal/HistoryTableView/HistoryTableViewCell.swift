//
//  HistoryTableViewCell.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/09/04.
//

import UIKit
import MusicKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var wrapperView: UIView!
    
    var artists: [Artist] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        wrapperView.layer.cornerRadius = 15
//        wrapperView.clipsToBounds = true
        wrapperView.layer.shadowOffset = .zero
        wrapperView.layer.shadowOpacity = 0.2
        wrapperView.layer.shadowColor = UIColor.black.cgColor
        wrapperView.layer.shadowRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView() {
        let const = max(0, CGFloat(artists.count * 58) - stackView.bounds.width)
        widthConstraint.constant = const
        artists.forEach({ artist in
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
            imageView.layer.cornerRadius = 24
            imageView.clipsToBounds = true
            guard let artwork = artist.artwork, let url = artwork.url(width: 256, height: 256) else { return }
            imageView.setImage(url: url)
            let spacer = UIView()
            spacer.translatesAutoresizingMaskIntoConstraints = false
            spacer.widthAnchor.constraint(equalToConstant: 10).isActive = true
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(spacer)
        })
        let spacer = UIView()
        stackView.addArrangedSubview(spacer)
    }
}
