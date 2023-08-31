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
    
    var count:Int = 0
    var selectedArtists: [Artist] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        
        timeView.layer.cornerRadius = 15
        timeView.layer.shadowOffset = CGSize(width: 0, height: 0)
        timeView.layer.shadowColor = UIColor.black.cgColor
        timeView.layer.shadowOpacity = 0.2
        timeView.layer.shadowRadius = 4
        
        artistsView.layer.cornerRadius = 15
        artistsView.layer.shadowOffset = CGSize(width: 0, height: 0)
        artistsView.layer.shadowColor = UIColor.black.cgColor
        artistsView.layer.shadowOpacity = 0.2
        artistsView.layer.shadowRadius = 4
        
        innerArtistsView.layer.cornerRadius = 15
        innerArtistsView.layer.masksToBounds = true
        searchController.searchBar.placeholder = "検索したい文字列を入力してください"
//        artistTableView.tableHeaderView = searchController.searchBar
    }
    
    @IBAction func addArtist() {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "search") as! SearchViewController
        self.present(nextVC, animated: true)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedArtists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let label = cell.viewWithTag(1) as! UILabel
        label.text = selectedArtists[indexPath.row].name
        return cell
    }
    
    @IBAction func moveForPlay(_ sender: Any) {
        print(selectedArtists)
        // 1. selectedArtistsの中にあるアーティストの曲を１０曲取得してくる
        let songs: [Song] = []
        selectedArtists.forEach({ artist in
            Task {
                do {
                    let artistWithTopSongs = try await artist.with([.topSongs])
                    print(artistWithTopSongs.topSongs)
                }
            }
        })
        
        // 2. ランダムで曲を選んで、プレイリストの長さから時間を引く
        
        // 3. 2.を繰り返して、残りの長さが０未満になったら終了
        
        // 4. 3.を10回繰り返して、一番残りが短いものを選んで表示する
        
        
        
        
      
        
        
//       for i in 1...10 {
//           for i in  {
//          func minusTime(){
//
//                }
//            }
//        }
        
        
//        let storyboard = self.storyboard!
//        let second = storyboard.instantiateViewController(withIdentifier: "play")
//        self.present(second, animated: true, completion: nil)
    }
}
