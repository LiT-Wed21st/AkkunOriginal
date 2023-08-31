//
//  PlayViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/08/02.
//

import UIKit
import MusicKit

class PlayViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var songs: [Song] = []
    var error: TimeInterval!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    
        Task {
            SystemMusicPlayer.shared.queue = .init(for: songs)
            do {
                try await SystemMusicPlayer.shared.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension PlayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let label = cell.viewWithTag(1) as! UILabel
        label.text = songs[indexPath.row].title
        return cell
    }
}
