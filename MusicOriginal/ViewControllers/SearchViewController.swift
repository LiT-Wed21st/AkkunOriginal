//
//  SearchViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/08/30.
//

import UIKit
import MusicKit

class SearchViewController: UIViewController {
    
    @IBOutlet var searchView: UIStackView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    // 検索ワードに一致するアーティストの配列
    var artists: [Artist] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // searchViewのデザイン
        searchView.layer.cornerRadius = 10
        searchView.layer.masksToBounds = true
        
        // テキストフィールドの内容が変更された時の処理
        searchTextField.addTarget(self, action: #selector(searchArtist(_:)), for: .editingChanged)
    }
    
    // 検索ワードに一致するアーティストを取得
    @objc func searchArtist(_ sender: UITextField) {
        Task {
            do {
                let request = MusicCatalogSearchRequest(term: sender.text ?? "", types: [Artist.self])
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
        let prevVC = nav.viewControllers[1] as! SettingViewController
        prevVC.selectedArtists.append(artist)
        prevVC.collectionView.reloadData()
        self.dismiss(animated: true)
    }
}
