//
//  SettingViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/08/01.
//

import UIKit
import MusicKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var artistTableView: UITableView!
    @IBOutlet weak var genreTableView: UITableView!
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testDatePicker: UIDatePicker!
    
    var count:Int = 0
    var selectedArtists: [Artist] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.placeholder = "検索したい文字列を入力してください"
//        artistTableView.tableHeaderView = searchController.searchBar
    }
    
    @IBAction func addArtist() {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "searchArtist") as! SearchViewController
        let nav = self.navigationController
        nav?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func test() {
        print(selectedArtists)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return selectedArtists.count
        } else if tableView.tag == 1 {
            return 20
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell")!
            let label = cell.viewWithTag(1) as! UILabel
            label.text = selectedArtists[indexPath.row].name
            return cell
        } else if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell")!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell")!
            return cell
        }
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
