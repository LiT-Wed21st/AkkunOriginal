//
//  PlayViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/08/02.
//

import UIKit
import MusicKit
import MediaPlayer
import MBCircularProgressBar

class PlayViewController: UIViewController {
    
    @IBOutlet var songsView: UIView!
    @IBOutlet var innerSongsView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var progressBar: MBCircularProgressBarView!
    
    var songs: [Song] = []
    var error: TimeInterval!
    var timer: Timer!
    var songControllTimer: Timer!
    var time: TimeInterval!
    var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // songsViewのデザイン
        songsView.layer.cornerRadius = 15
        songsView.layer.shadowOffset = CGSize(width: 0, height: 0)
        songsView.layer.shadowColor = UIColor.black.cgColor
        songsView.layer.shadowOpacity = 0.2
        songsView.layer.shadowRadius = 4
        
        // innerSongsViewのデザイン
        innerSongsView.layer.cornerRadius = 15
        innerSongsView.layer.masksToBounds = true
        
        // artworkImageViewのデザイン
        artworkImageView.layer.cornerRadius = artworkImageView.layer.frame.width / 2
        
        // playButtonのデザイン
        playButton.layer.cornerRadius = playButton.layer.frame.width / 2
        
        // progressBarの設定と初期化
        progressBar.maxValue = time
        progressBar.value = 0
        
        tableView.reloadData()
        
        timerLabel.text = timeIntervalToString(timeInterval: time)
        setArtworkImage(song: songs[currentIndex])
    }
    
    // playButtonがタップされた際の処理
    @IBAction func playButtonTapped(_ sender: UIButton) {
        sender.isHidden = true
        playSongs(song: songs[currentIndex])
        startTimer()
    }
    
    // 曲を再生
    func playSongs(song: Song) {
        Task {
            SystemMusicPlayer.shared.queue = .init(arrayLiteral: song)
            do {
                try await SystemMusicPlayer.shared.play()
            } catch {
                print(error.localizedDescription)
            }
            setArtworkImage(song: song)
            startSongControllTimer(song: song)
        }
    }
    
    // メインのタイマーを開始
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] _ in
            time -= 1.0
            progressBar.value = progressBar.maxValue - time
            timerLabel.text = timeIntervalToString(timeInterval: time)
        })
    }
    
    // 曲の終了時に処理を実行
    func startSongControllTimer(song: Song) {
        songControllTimer = Timer.scheduledTimer(withTimeInterval: song.duration!, repeats: false, block: { [self] _ in
            takeInterval()
        })
    }
    
    // 誤差の調整
    func takeInterval() {
        SystemMusicPlayer.shared.stop()
        Thread.sleep(forTimeInterval: error / Double(songs.count))
        currentIndex += 1
        playSongs(song: songs[currentIndex])
    }
    
    // artworkImageViewに画像を表示
    func setArtworkImage(song: Song) {
        DispatchQueue.global(qos: .background).async() { [self] in
            guard let artwork = song.artwork, let url = artwork.url(width: 240, height: 240), let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async() { [self] in
                artworkImageView.backgroundColor = UIColor(cgColor: artwork.backgroundColor!)
                let artworkImage = UIImage(data: data)
                artworkImageView.image = artworkImage
            }
        }
    }
    
    // timeIntervalをStringに変換
    func timeIntervalToString(timeInterval: TimeInterval) -> String {
        let df = DateComponentsFormatter()
        df.unitsStyle = .positional
        return df.string(from: timeInterval)!
    }
}

extension PlayViewController: UITableViewDataSource, UITableViewDelegate {
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let label = cell.viewWithTag(1) as! UILabel
        label.text = songs[indexPath.row].title
        return cell
    }
}
