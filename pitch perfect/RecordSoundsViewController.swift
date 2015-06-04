//
//  RecordSoundsViewController.swift
//  pitch perfect
//
//  Created by Ксения Белан on 09/12/14.
//  Copyright (c) 2014 Ксения Белан. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        //TODO: show text "recording in progress"
        stopButton.hidden = false
        recordingInProgress.hidden = false
        recordButton.enabled = false
        println("in recordAudio")
        
        //TODO: record audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        

    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
            if (segue.identifier == "stopRecording"){
                let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
                
                let data = sender as! RecordedAudio
                playSoundsVC.receivedAudio = data
                
            }
        }
        
    
    
    @IBAction func stopRecording(sender: UIButton) {
    //hide "recording in progress"
        //stop recording
        stopButton.hidden = true
        recordingInProgress.hidden = true
        recordButton.enabled = true
        println("stop recording")
        
        
        //Inside func stopAudio(sender: UIButton)
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    
    }
}
