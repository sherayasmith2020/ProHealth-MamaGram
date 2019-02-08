//
//  RecordingViewController.swift
//  MamaGram
//
//  Created by reu2 on 7/9/18.
//  Copyright © 2018 reu. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource, FileManagerDelegate
{
    @IBOutlet weak var myTableView: UITableView!
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var soundFileURL: URL!
    var meterTimer: Timer!
    var recordings = [URL]()
    var calendar = [String]()
    
    var recordingsRev = [URL]()
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        listRecordings()
        myTableView.reloadData()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ////TableView Setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if recordings.isEmpty
        {
            print ("LIST IS EMPTY")
            return 0
        }else
        {
            return recordings.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = recordings.reversed()[indexPath.row].lastPathComponent.replacingOccurrences(of: ".m4a", with: "")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        play(recordings.reversed()[indexPath.row])
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let rename = renameSwipeAct(index: indexPath.row)
        let delete = deleteSwipeAct(index: indexPath.row, path: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, rename])
    }
    
    //Date functions
    func getDate() -> String{
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .short
         return format.string(from: Date())
    }
    
    ///Swipe Actions
    func renameSwipeAct(index : Int) -> UIContextualAction
    {
        let action = UIContextualAction(style: .normal , title: "Rename")
        {
            (action, view, completion) in
            self.askToRename(index)
            completion(true)
        }
        action.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.9, blue: 0.0, alpha: 1.0)
        action.title = "Rename"
        return action
    }
    func askToRename(_ row: Int)
    {
        let recording = self.recordings.reversed()[row]
        let alert = UIAlertController(title: "Rename",
                                      message: "Rename Recording \(recording.lastPathComponent)?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: .default,
                                      handler:
            {
                [unowned alert] _ in
                print("yes was tapped \(self.recordings[row])")
                if let textFields = alert.textFields {
                    let tfa = textFields as [UITextField]
                    let text = tfa[0].text
                    print("Text of subsequent save: " + text!)
                    let url = URL(fileURLWithPath: text!)
                    self.renameRecording(recording, to: url)
                }}))
        
        alert.addAction(UIAlertAction(title: "No",
                                      style: .default,
                                      handler:
            {_ in
                print("no was tapped")
        }))
        
        alert.addTextField(configurationHandler:
            {
                textfield in
                textfield.placeholder = "Enter a filename"
                let recName = recording.lastPathComponent.replacingOccurrences(of: ".m4a", with: "")
                textfield.text = "\(recName)"
        })
        self.present(alert, animated: true, completion: nil)
    }
    func renameRecording(_ from: URL, to: URL)
    {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let toURL = documentsDirectory.appendingPathComponent(to.lastPathComponent)
        print("renaming file \(from.absoluteString) to \(to) url \(toURL)")
        let fileManager = FileManager.default
        fileManager.delegate = self
        do
        {
            try FileManager.default.moveItem(at: from, to: toURL)
        } catch
        {
            print(error.localizedDescription)
            print("error renaming recording")
        }
        DispatchQueue.main.async
            {
                self.listRecordings()
                self.myTableView.reloadData()
        }
    }
    func deleteSwipeAct(index : Int, path : IndexPath)-> UIContextualAction
    {
        let action = UIContextualAction(style: .normal , title: "Rename")
        {
            (action, view, completion) in
            self.myTableView.beginUpdates()
            self.deleteRecord(self.recordings.reversed()[index])
            self.recordings = self.recordings.reversed()
            self.recordings.remove(at: index)
            self.myTableView.deleteRows(at: [path], with: .fade)
            self.listRecordings()
            self.myTableView.reloadData()
            self.myTableView.endUpdates()
        }
        action.backgroundColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        action.title = "Delete"
        return action
    }
    ///Ask to delete
    //    func askToDelete(_ row: Int)
    //    {
    //        let alert = UIAlertController(title: "Delete",
    //                                      message: "Delete Recording \(recordings[row].lastPathComponent)?", preferredStyle: .alert)
    //        alert.addAction(UIAlertAction(title: "Yes",
    //                                      style: .default,
    //                                      handler: {_ in
    //                                        print("yes was tapped \(self.recordings[row])")
    //                                        self.deleteRecord(self.recordings[row])}))
    //
    //        alert.addAction(UIAlertAction(title: "No", style: .default,
    //                                      handler: {_ in
    //                                        print("no was tapped")}))
    //        self.present(alert, animated: true, completion: nil)
    //    }
    func deleteRecord(_ url: URL)
    {
        print("removing file at \(url.absoluteString)")
        let fileManager = FileManager.default
        do
        {
            try fileManager.removeItem(at: url)
            print("Item Deleted")
        } catch
        {
            print(error.localizedDescription)
            print("error deleting recording")
        }
        DispatchQueue.main.async
            {
                self.listRecordings()
                self.myTableView.reloadData()
        }
    }
    func listRecordings()
    {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do
        {
            let urls = try FileManager.default.contentsOfDirectory(at: documentsDirectory,
                                                                   includingPropertiesForKeys: nil,
                                                                   options:FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            self.recordings = urls.filter({(name: URL) -> Bool in
                return name.pathExtension == ""
            })
            
        } catch
        {
            print(error.localizedDescription)
            print("something went wrong listing recordings")
        }
    }
    func fileManager(_ fileManager: FileManager, shouldMoveItemAt srcURL: URL, to dstURL: URL) -> Bool
    {
        print("should move \(srcURL) to \(dstURL)")
        return true
    }
    @objc func updateAudioMeter(_ timer: Timer)
    {
        if let recorder = self.recorder
        {
            if recorder.isRecording
            {
                let min = Int(recorder.currentTime / 60)
                let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
                let s = String(format: "%02d:%02d", min,
                               sec)
                statusLabel.text = s
                recorder.updateMeters()
            }
        }
    }
    func recordWithPermission(_ setup: Bool)
    {
        print("\(#function)")
        if setup == true
        {
            AVAudioSession.sharedInstance().requestRecordPermission
                {
                    [unowned self] granted in
                    if granted
                    {
                        DispatchQueue.main.async
                            {
                                print("Permission to record granted")
                                self.setSessionPlayAndRecord()
                                self.recordButton.setImage(UIImage(named: "greenMic"),
                                                           for: UIControlState.normal)
                                self.setupRecorder()
                                self.recorder.record()
                                self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                                       target: self,
                                                                       selector: #selector(self.updateAudioMeter(_:)),
                                                                       userInfo: nil,
                                                                       repeats: true)
                        }
                    }
            }
            if AVAudioSession.sharedInstance().recordPermission() == .denied
            {
                print("permission denied")
            }
        }
        else
        {
            recorder.stop()
            meterTimer.invalidate()
            recorder = nil
            recordButton.setImage(UIImage(named: "redRec"), for: UIControlState.normal)
            statusLabel.text = "00:00"
            listRecordings()
        }
        
    }
    func setSessionPlayAndRecord()
    {
        print("\(#function)")
        let session = AVAudioSession.sharedInstance()
        do
        {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        }catch
        {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do
        {
            try session.setActive(true)
        } catch
        {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    func setupRecorder()
    {
        print("\(#function)")
        
        //let format = DateFormatter()
        //format.dateStyle = .medium
        //format.timeStyle = .short
        let date = getDate()
        print(date)
        let currentFileName = "\(date).m4a"
        print(currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        print("writing to soundfile url: '\(soundFileURL!)'")
        
        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString)
        {
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        let recordSettings: [String: Any] =
            [
                AVFormatIDKey: kAudioFormatAppleLossless,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey: 32000,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey: 44100.0
        ]
        do
        {
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        }catch
        {
            recorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        print("\(#function)")
        print("finished recording \(flag)")
        recordButton.setTitle("Record", for: UIControlState())
        let alert = UIAlertController(title: "Recorder",
                                      message: "Finished Recording",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Keep", style: .default)
        {
            [unowned self] _ in
            print("keep was tapped")
            self.recorder = nil
            if let textFields = alert.textFields
            {
                let tfa = textFields as [UITextField]
                let text = tfa[0].text
                print("text of initial save: " + text!)
                let httpVoicenote = ["type": "voicenote", "title": text, "date created": self.getDate()]
                let newHttp = Http()
                newHttp.makePostCall(body: httpVoicenote)
                let url = URL(fileURLWithPath: text!)
                self.renameRecording(self.soundFileURL, to: url)
            }
            self.listRecordings()
            self.myTableView.reloadData()
            
        })
        alert.addAction(UIAlertAction(title: "Delete", style: .default)
        {
            [unowned self] _ in
            print("delete was tapped")
            self.deleteRecord(self.soundFileURL)
            self.myTableView.reloadData()
            self.recorder = nil
        })
        alert.addTextField(configurationHandler: {textfield in
            textfield.placeholder = "Enter a filename"
            let recName = self.soundFileURL.lastPathComponent.replacingOccurrences(of: ".m4a", with: "")
            textfield.text = "\(recName)"
        })
        self.present(alert, animated: true, completion: nil)
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        print("\(#function)")
        print("finished playing \(flag)")
        recordButton.isEnabled = true
    }
    func play(_ url: URL)
    {
        print("playing \(url)")
        do
        {
            self.player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch
        {
            self.player = nil
            print(error.localizedDescription)
            print("AVAudioPlayer init failed")
        }
        
    }
    @IBAction func record(_ sender: UIButton)
    {
        print("\(#function)")
        
        if player != nil && player.isPlaying
        {
            print("stopping")
            player.stop()
        }
        
        if recorder == nil
        {
            print("recording. recorder nil")
            recordWithPermission(true)
        } else
        {
            print("Stop recording")
            recordWithPermission(false)
            
        }
    }
    
}


    


