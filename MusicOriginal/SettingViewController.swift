//
//  SettingViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/08/01.
//

import UIKit
import MusicKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var buttonWrapper: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var artistsView: UIView!
    @IBOutlet weak var innerArtistsView: UIView!
    
    // 選択されたアーティストの配列
    var selectedArtists: [Artist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // buttonのデザイン
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.masksToBounds = true
        button.backgroundColor = .black
        button.tintColor = .clear
        button.layer.layoutIfNeeded()
        let buttonLayer = CAGradientLayer()
        buttonLayer.frame = button.bounds
        let color1 = CGColor(red: 0, green: 179 / 255, blue: 203 / 255, alpha: 1)
        let color2 = CGColor(red: 0, green: 139 / 255, blue: 163 / 255, alpha: 1)
        buttonLayer.colors = [color1, color2]
        buttonLayer.locations = [0.0, 1.0]
        buttonLayer.startPoint = CGPoint(x: 0, y: 0)
        buttonLayer.endPoint = CGPoint(x: 1, y: 0.1)
        button.layer.insertSublayer(buttonLayer, at: 0)
        buttonWrapper.layer.cornerRadius = button.frame.height / 2
        buttonWrapper.layer.shadowOffset = CGSize(width: 0, height: 0)
        buttonWrapper.layer.shadowColor = CGColor(red: 0, green: 159 / 255, blue: 183 / 255, alpha: 1)
        buttonWrapper.layer.shadowOpacity = 0.8
        buttonWrapper.layer.shadowRadius = 5
        
        // timeViewのデザイン
        timeView.layer.cornerRadius = 15
        timeView.layer.shadowOffset = CGSize(width: 0, height: 0)
        timeView.layer.shadowColor = UIColor.black.cgColor
        timeView.layer.shadowOpacity = 0.2
        timeView.layer.shadowRadius = 4
        
        // artistsViewのデザイン
        artistsView.layer.cornerRadius = 15
        artistsView.layer.shadowOffset = CGSize(width: 0, height: 0)
        artistsView.layer.shadowColor = UIColor.black.cgColor
        artistsView.layer.shadowOpacity = 0.2
        artistsView.layer.shadowRadius = 4
        
        // innerArtistsViewのデザイン
        innerArtistsView.layer.cornerRadius = 15
        innerArtistsView.layer.masksToBounds = true
        
//        collectionView.register(UINib(nibName: "ArtistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
//        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        flowLayout.estimatedItemSize = CGSize()
    }
    
    // 戻るボタン
    @IBAction func back() {
        guard let nav = self.navigationController else { return }
        nav.popViewController(animated: true)
    }
    
    // アーティストを追加
    @IBAction func addArtist() {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "search") as! SearchViewController
        self.present(nextVC, animated: true)
    }
    
    // プレイリストを作成
    @IBAction func createPlaylist() {
        Task {
            let timerInterval = getTimeInterval()
            var songs: [Song] = []

            do {
                for artist in selectedArtists {
                    let artistWithTopSongs = try await artist.with([.topSongs])
                    songs.append(contentsOf: artistWithTopSongs.topSongs!)
                }
            } catch {
                print(error)
            }

            if songs.isEmpty {
                showAlert(message: "曲を取得できませんでした。アーティストを追加してください。")
                return
            }

            if songs.map({ song in
                return song.duration!
            }).reduce(0, +) < timerInterval {
                showAlert(message: "曲が足りません。よりたくさんのアーティストを追加してください。")
                return
            }

            let (error, playlist) = chooseBestPlaylist(timeInterval: timerInterval, songs: songs)

            if playlist.isEmpty {
                showAlert(message: "プレイリストを作成できませんでした。時間を増やしてください。")
                return
            }

            let nav = self.navigationController!
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "play") as! PlayViewController
            nextVC.error = error
            nextVC.songs = playlist
            nextVC.playlistDuration = timerInterval
            nextVC.artists = selectedArtists
            nav.pushViewController(nextVC, animated: true)
        }
    }
    
    // timePickerの時間を秒数で取得
    func getTimeInterval() -> TimeInterval {
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        return timePicker.date.timeIntervalSince(today)
    }
    
    // 最適なプレイリストを選択
    func chooseBestPlaylist(timeInterval: TimeInterval, songs: [Song]) -> (TimeInterval, [Song]) {
        var minimumError = timeInterval
        var bestPlaylist: [Song] = []
        
        for _ in 1..<50 {
            let (error, playlist) = createRandomPlaylist(timeInterval: timeInterval, songs: songs)
            
            if error < minimumError {
                minimumError = error
                bestPlaylist = playlist
            }
        }
        return (minimumError, bestPlaylist)
    }
    
    // ランダムなプレイリストを生成
    func createRandomPlaylist(timeInterval: TimeInterval, songs: [Song]) -> (TimeInterval, [Song]) {
        var remainingTime = timeInterval
        var remainingSongs = songs
        var randomPlaylist: [Song] = []
        
        while remainingTime > 0 {
            let randomInt = Int.random(in: 0..<remainingSongs.count)
            let selectedSong = remainingSongs.remove(at: randomInt)
            
            if selectedSong.duration! < remainingTime {
                remainingTime -= selectedSong.duration!
                randomPlaylist.append(selectedSong)
            } else {
                break
            }
        }
        return (remainingTime, randomPlaylist)
    }
    
    //アラートを表示
    func showAlert(message: String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(defaultAction)
        self.present(alert, animated: true)
    }
}

// tableViewの設定
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {

    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedArtists.count
    }

    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let label = cell.viewWithTag(1) as! UILabel
        label.text = selectedArtists[indexPath.row].name
        return cell
    }

    // セルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectedArtists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

//extension SettingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return selectedArtists.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.width / 3)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//}
