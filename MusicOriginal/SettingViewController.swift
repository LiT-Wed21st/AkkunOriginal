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
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return 10
        } else if tableView.tag == 1 {
            return 20
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell")!
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
            let storyboard: UIStoryboard = self.storyboard!
            let second = storyboard.instantiateViewController(withIdentifier: "play")
            self.present(second, animated: true, completion: nil)
    }
}
