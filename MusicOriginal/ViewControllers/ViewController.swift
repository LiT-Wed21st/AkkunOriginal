//
//  ViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/08/23.
//

import UIKit

// 起動時の初期画面
class ViewController: UIViewController {
    
    @IBOutlet var newButton: UIButton!
    @IBOutlet var historyButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デフォルトのナビゲーションバーを非表示
        self.navigationController?.navigationBar.isHidden = true
        
        newButton.layer.cornerRadius = newButton.layer.frame.height / 2
        newButton.layer.masksToBounds = true
        newButton.tintColor = .clear
        newButton.layoutIfNeeded()
        let newButtonLayer = CAGradientLayer()
        newButtonLayer.frame = newButton.bounds
        let color1 = CGColor(red: 0, green: 179 / 255, blue: 203 / 255, alpha: 1)
        let color2 = CGColor(red: 0, green: 139 / 255, blue: 163 / 255, alpha: 1)
        newButtonLayer.colors = [color1, color2]
        newButtonLayer.locations = [0.0, 1.0]
        newButtonLayer.startPoint = CGPoint(x: 0, y: 0)
        newButtonLayer.endPoint = CGPoint(x: 1.0, y: 0.1)
        newButton.layer.insertSublayer(newButtonLayer, at: 0)
        
        historyButton.layer.cornerRadius = historyButton.layer.frame.height / 2
        historyButton.layer.masksToBounds = true
        historyButton.layer.borderColor = historyButton.tintColor.cgColor
        historyButton.layer.borderWidth = 2
    }
    
    @IBAction func newPlaylist() {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "setting") as! SettingViewController
        let nav = self.navigationController!
        nav.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func showPlaylists() {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "history") as! HistoryViewController
        let nav = self.navigationController!
        nav.pushViewController(nextVC, animated: true)
    }
}
