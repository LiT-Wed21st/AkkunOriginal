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
    
    var artists: [Artist] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.backgroundImage = UIImage()
    }
    
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

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text!)
        // 入力された文字列でアーティストを検索
        searchArtist(name: searchBar.text!)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let label = cell.viewWithTag(1) as! UILabel
        label.text = artists[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artists[indexPath.row]
        let nav = self.presentingViewController as! UINavigationController
        let prevVC = nav.viewControllers.first as! SettingViewController
        prevVC.selectedArtists.append(artist)
        prevVC.tableView.reloadData()
        self.dismiss(animated: true)
    }
}
