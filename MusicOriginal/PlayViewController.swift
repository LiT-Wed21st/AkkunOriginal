//
//  PlayViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/08/02.
//

import UIKit
import MusicKit

class PlayViewController: UIViewController {
    
    @IBOutlet var playView: UIView!
    @IBOutlet var songsView: UIView!
    @IBOutlet var innerSongsView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    
    var songs: [Song] = []
    var error: TimeInterval!
    var isPlaying = false
    var timer: Timer!
    var time: TimeInterval!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        songsView.layer.cornerRadius = 15
        songsView.layer.shadowOffset = CGSize(width: 0, height: 0)
        songsView.layer.shadowColor = UIColor.black.cgColor
        songsView.layer.shadowOpacity = 0.2
        songsView.layer.shadowRadius = 4
        
        innerSongsView.layer.cornerRadius = 15
        innerSongsView.layer.masksToBounds = true
        
        tableView.reloadData()
        
        timerLabel.text = timeIntervalToString(timeInterval: time)
    }
    
    // artworkImageViewがタップされた際の処理
    @IBAction func artwarkImageViewTapped(_ sender: UIGestureRecognizer) {
        print("tap")
        if !isPlaying {
            playSongs()
            setArtworkImage(song: songs.first!)
        }
    }
    
    // 曲を再生
    func playSongs() {
        Task {
            SystemMusicPlayer.shared.queue = .init(for: songs)
            do {
                try await SystemMusicPlayer.shared.play()
            } catch {
                print(error.localizedDescription)
            }
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
                
            })
        }
    }
    
    func setArtworkImage(song: Song) {
        Task {
            var artworkImage: UIImage!
            let url = song.artwork!.url(width: 120, height: 120)!
            do {
                let data = try Data(contentsOf: url)
                artworkImage = UIImage(data: data)
            } catch {
                print(error)
            }
            artworkImageView.image = artworkImage
        }
    }
    
    func timeIntervalToString(timeInterval: TimeInterval) -> String {
        let df = DateComponentsFormatter()
        df.unitsStyle = .positional
        return df.string(from: timeInterval)!
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
