//
//  SettingViewController.swift
//  MusicOriginal
//
//  Created by ak ha on 2023/08/01.
//

import UIKit
import MusicKit

class SettingViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIPickerViewDelegate,UIPickerViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return 10
        }
        if tableView.tag == 1 {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
           
        }
        if tableView.tag == 1 {
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if tableView.tag == 0 {
            
        }
        if tableView.tag == 1 {
            
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataList.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return dataList.count
    }
    
    @IBOutlet weak var testPickerView: UIPickerView!
    
    let dataList = [[Int](0...24), [Int](0...60), [Int](0...60)]
    
    @IBOutlet weak var artistTableView: UITableView!
    
    @IBOutlet weak var genreTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistTableView.delegate = self
        artistTableView.delegate = self
        genreTableView.dataSource = self
        genreTableView.delegate = self
        
        
        //時間設定の定義
        let hStr = UILabel()
        hStr.text = "時間"
        hStr.sizeToFit()
        
        let mStr = UILabel()
        mStr.text = "分"
        mStr.sizeToFit()
        
        let sStr = UILabel()
        sStr.text = "秒"
        sStr.sizeToFit()
        
        //AppleMusicから情報を入手
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
            })
            
            songs.forEach({ song in
                print(song.duration!)
            })
        }
    }
}
