//
//  RecorderViewController.swift
//  RecorderList
//
//  Created by stephan morris on 7/11/18.
//  Copyright © 2018 Smorris. All rights reserved.
//

import UIKit
import AVFoundation

class RecorderViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }

    func setupRecorder() {
        do {
        // Create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
        
        // Create URL for the Audio file
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "Audio.mp4"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
        // Create Settings for Audio Recorder
            
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
        
        // Create AudioRecorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
            
        } catch let error as NSError {
            //Handling the catch
            print(error)
        }
    }
    
    
    // MARK: - Action Methods

    @IBAction func recordTapped(_ sender: Any) {
        // print("Record") - Testing
        
        if audioRecorder!.isRecording {
            //Stop the Recording
            audioRecorder?.stop()
            
            //Change Button Title to Record
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
            
        } else {
            //Start the Recording
            audioRecorder?.record()
            
            //Change the button title to Stop
            recordButton.setTitle("Stop", for: .normal)
            
        }
    }
    @IBAction func playTapped(_ sender: Any) {
        // print("play") - Testing
        do {
        try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch {
            
        }
    }
    @IBAction func addTapped(_ sender: Any) {
        // print("add") - Testing
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        sound.name = textField.text
        sound.audio = NSData(contentsOf: audioURL!)! as Data
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    

}
