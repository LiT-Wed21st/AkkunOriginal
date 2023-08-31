//
//  SearchViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/08/30.
//

import UIKit
import MusicKit

class SearchViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    // 検索ワードに一致するアーティストの配列
    var artists: [Artist] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // searchBarのデザイン
        searchBar.backgroundImage = UIImage()
    }
    
    // 検索ワードに一致するアーティストを取得する
    func searchArtist(name: String) {
        Task {
            do {
                let request = MusicCatalogSearchRequest(term: name, types: [Artist.self])
                let response = try await request.response()
                artists = []
                artists.append(contentsOf: response.artists)
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

// searchBarの設定
extension SearchViewController: UISearchBarDelegate {
    
    // 文字列が変更された時の処理
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchArtist(name: searchBar.text!)
    }
}

// tableViewの設定
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let label = cell.viewWithTag(1) as! UILabel
        label.text = artists[indexPath.row].name
        return cell
    }
    
    // セルが押された際の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artists[indexPath.row]
        let nav = self.presentingViewController as! UINavigationController
        let prevVC = nav.viewControllers.first as! SettingViewController
        prevVC.selectedArtists.append(artist)
        prevVC.tableView.reloadData()
        self.dismiss(animated: true)
    }
}
