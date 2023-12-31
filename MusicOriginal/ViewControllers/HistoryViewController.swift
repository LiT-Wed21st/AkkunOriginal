//
//  HistoryViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/09/04.
//

import UIKit
import RealmSwift
import MusicKit

class HistoryViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var playlists: [Playlist] = []
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        playlists = Array(realm.objects(Playlist.self))
    }
    
    @IBAction func back() {
        guard let nav = self.navigationController else { return }
        nav.popViewController(animated: true)
    }
    
    // TimeIntervalをStringに変換
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
    
    // DateをStringに変換
    func dateToString(date: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.timeZone = TimeZone(identifier: "Asia/Tokyo")
        df.dateFormat = "yyyy/MM/dd"
        return df.string(from: date)
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlist = playlists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HistoryTableViewCell
        cell.selectionStyle = .none
        cell.nameLabel.text = playlist.name
        cell.dateLable.text = "作成日: " + dateToString(date: playlist.createdAt)
        cell.durationLabel.text = "時間: " + timeIntervalToString(timeInterval: playlist.duration)
        let artistIDs = Array(playlist.artistIDs)
        Task {
            do {
                for artistID in artistIDs {
                    let request = MusicCatalogResourceRequest<Artist>(matching: \.id, equalTo: MusicItemID(artistID))
                    let response = try await request.response()
                    if let artist = response.items.first {
                        cell.artists.append(artist)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            cell.updateView()
        }

        return cell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        return cell.frame.height
    }
    
    // セルが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Task {
            let loadingView = UIView(frame: view.bounds)
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            activityIndicator.center = loadingView.center
            activityIndicator.color = .gray
            activityIndicator.style = .large
            activityIndicator.startAnimating()
            loadingView.addSubview(activityIndicator)
            view.addSubview(loadingView)
            
            let playlist = playlists[indexPath.row]
            let songIDs = Array(playlist.songIDs)
            var songs: [Song] = []
            
            do {
                for songID in songIDs {
                    let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: MusicItemID(rawValue: songID))
                    let response = try await request.response()
                    songs.append(response.items.first!)
                }
            } catch {
                print(error)
            }
            
            loadingView.removeFromSuperview()
            let nav = self.navigationController!
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "play") as! PlayViewController
            nextVC.songs = songs
            nextVC.playlistDuration = playlist.duration
            nextVC.error = playlist.error
            nextVC.isSaved = true
            nav.pushViewController(nextVC, animated: true)
        }
    }
}
