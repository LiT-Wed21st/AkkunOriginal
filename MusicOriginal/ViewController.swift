//
//  ViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/07/12.
//

import UIKit
import MusicKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        Task {
            do {
                let request = MusicCatalogSearchRequest(term: "Bump of Chikin", types: [Playlist.self])
                let response = try await request.response()
                print(response.songs)
            } catch {
                print("error")
            }
            var request = MusicCatalogSearchRequest(term: "Bump of Chicken", types: [Song.self])
             request.limit = 10
            
            let response = try await request.response()
            let songs = response.songs
            songs.forEach({ song in
              print(song)
                
                songs.forEach({ song in
                  print(song.duration!)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int{
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
