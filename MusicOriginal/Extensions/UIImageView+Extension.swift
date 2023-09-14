//
//  UIImageView+Extension.swift
//  MusicOriginal
//
//  Created by Yuri Tsuchikawa on 2023/09/14.
//

import UIKit

extension UIImageView {
    
    func setImage(url: URL) {
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else { return }
            DispatchQueue.main.sync {
                self.image = image
            }
        }
    }
}
