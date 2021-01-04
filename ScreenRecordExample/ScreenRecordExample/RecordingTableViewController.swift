//
//  RecordingTableViewController.swift
//  ScreenRecordExample
//
//  Created by Minhyuk Kim on 2020/12/08.
//

import UIKit
import AVKit

extension FileManager {
    static var recordingsDirectory: URL? {
        Self.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("SendBird")
            .appendingPathComponent("Recording")
    }
}

class RecordingTableViewController: UITableViewController {

    var files: [URL]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let directory = FileManager.recordingsDirectory else { return }
        self.files = (try? FileManager
                        .default
                        .contentsOfDirectory(at: directory,
                                             includingPropertiesForKeys: nil,
                                             options: .skipsHiddenFiles))?
                    .sorted(by: { $0.absoluteString < $1.absoluteString })
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)

        let file = self.files?[indexPath.row]
        cell.textLabel?.text = file?.absoluteString.split(separator: "/").last?.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = self.files?[indexPath.row] else { return }
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
}
