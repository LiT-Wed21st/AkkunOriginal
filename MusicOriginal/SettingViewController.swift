//
//  SettingViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/08/01.
//

import UIKit
import MusicKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var artistsView: UIView!
    @IBOutlet weak var innerArtistsView: UIView!
    
    // 選択されたアーティストの配列
    var selectedArtists: [Artist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // buttonのデザイン
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        
        // timeViewのデザイン
        timeView.layer.cornerRadius = 15
        timeView.layer.shadowOffset = CGSize(width: 0, height: 0)
        timeView.layer.shadowColor = UIColor.black.cgColor
        timeView.layer.shadowOpacity = 0.2
        timeView.layer.shadowRadius = 4
        
        // artistsViewのデザイン
        artistsView.layer.cornerRadius = 15
        artistsView.layer.shadowOffset = CGSize(width: 0, height: 0)
        artistsView.layer.shadowColor = UIColor.black.cgColor
        artistsView.layer.shadowOpacity = 0.2
        artistsView.layer.shadowRadius = 4
        
        // innerArtistsViewのデザイン
        innerArtistsView.layer.cornerRadius = 15
        innerArtistsView.layer.masksToBounds = true
    }
    
    // アーティストを追加するボタン
    @IBAction func addArtist() {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "search") as! SearchViewController
        self.present(nextVC, animated: true)
    }
}

// tableViewの設定
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedArtists.count
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let label = cell.viewWithTag(1) as! UILabel
        label.text = selectedArtists[indexPath.row].name
        return cell
    }
}
