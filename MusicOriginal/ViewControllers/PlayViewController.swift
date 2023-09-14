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
import RealmSwift

class PlayViewController: UIViewController {
    
    @IBOutlet var songsView: UIView!
    @IBOutlet var innerSongsView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var songs: [Song] = []
    var error: TimeInterval! //
    var timer: Timer!
    var songControllTimer: Timer!
    var playlistDuration: TimeInterval!
    var time: TimeInterval!
    var currentIndex: Int = 0
    var artists: [Artist] = []
    
    var isSaved = false
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        time = playlistDuration
        
        let saveButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(savePlaylist))
        self.navigationItem.rightBarButtonItem = saveButtonItem
        
        if isSaved {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
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
    
    @IBAction func back() {
        let nav = self.navigationController
        nav?.popViewController(animated: true)
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
            if time > 0 {
                time -= 1.0
                progressBar.value = progressBar.maxValue - time
                timerLabel.text = timeIntervalToString(timeInterval: time)
            } else {
                timer.invalidate()
            }
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
        if currentIndex < songs.count - 1 {
            currentIndex += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + error / Double(songs.count - 1)) { [self] in
                playSongs(song: songs[currentIndex])
            }
        } else {
            let nav = self.navigationController!
            nav.popToRootViewController(animated: true)
        }
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
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "ja_JP")
        df.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        df.dateFormat = "HH:mm:ss"
        let today = df.calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        var str = df.string(from: Date(timeInterval: timeInterval, since: today))
        if str.first == "0" {
            str.removeFirst()
            if str.first == "0" {
                str.removeFirst(2)
            }
        }
        return str
    }
    
    // プレイリストを保存
    @IBAction func savePlaylist() {
        var nameTextField: UITextField!
        let alert = UIAlertController(title: "プレイリスト名", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            nameTextField = textField
        })
        let defaultAction = UIAlertAction(title: "保存", style: .default, handler: { [self] _ in
            guard let name = nameTextField.text else { return }
            let playlist = Playlist(name: name, duration: playlistDuration, songs: songs, artists: artists, error: error)
            try! realm.write() {
                realm.add(playlist)
            }
            let alert = UIAlertController(title: "保存完了", message: "プレイリストの保存が完了しました。", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(defaultAction)
            self.present(alert, animated: true)
        })
        alert.addAction(defaultAction)
        self.present(alert, animated: true)
        
        print("here")
        isSaved = true
        saveButton.isEnabled = !isSaved
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
