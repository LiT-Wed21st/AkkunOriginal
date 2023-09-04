//
//  ViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/08/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var newButton: UIButton!
    @IBOutlet var historyButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backButtonDisplayMode = .minimal
        
        newButton.layer.cornerRadius = newButton.layer.frame.height / 2
        newButton.layer.masksToBounds = true
        
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
