//
//  PlayViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/08/02.
//

import UIKit
import MusicKit
import MediaPlayer

class PlayViewController: UIViewController {
    
    @IBOutlet var songsView: UIView!
    @IBOutlet var innerSongsView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    
    var songs: [Song] = []
    var error: TimeInterval!
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
        
        artworkImageView.layer.cornerRadius = artworkImageView.layer.frame.width / 2
        
        playButton.layer.cornerRadius = playButton.layer.frame.width / 2
        
        tableView.reloadData()
        
        timerLabel.text = timeIntervalToString(timeInterval: time)
        setArtworkImage(song: songs.first!)
    }
    
    // playButtonがタップされた際の処理
    @IBAction func playButtonTapped(_ sender: UIButton) {
        sender.isHidden = true
        playSongs()
        startTimer()
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
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] _ in
            time -= 1.0
            timerLabel.text = timeIntervalToString(timeInterval: time)
        })
    }
    
    func setArtworkImage(song: Song) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            if let artwork = song.artwork, let url = artwork.url(width: 240, height: 240) {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.artworkImageView.backgroundColor = UIColor(cgColor: artwork.backgroundColor!)
                        let artworkImage = UIImage(data: data)
                        self.artworkImageView.image = artworkImage
                    }
                }
            }
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
