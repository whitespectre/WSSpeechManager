//
//  SpeechManager+SpeechRecognizer.swift
//  weighttrainer
//
//  Created by Lucas Diez de Medina on 20/06/2018.
//  Copyright © 2018 Lucas Diez de Medina. All rights reserved.
//

import UIKit
import Speech

public typealias WordRecognizedBlock = (_ recognizedWord: String) -> Void

extension SpeechManager: SFSpeechRecognizerDelegate {
    
    public func startListening(forWord word: String, wordDetectedBlock: @escaping WordRecognizedBlock) {
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                OperationQueue.main.addOperation {
                    self.listeningWord = word
                    self.wordDetectedBlock = wordDetectedBlock
                    self.startRecording()
                }
            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Not available on this device")
            case .notDetermined:
                print("Not determined")
            }
        }
    }
    
    public func startRecording() {
        
        if self.audioEngine.isRunning {
            self.stopRecording()
        }
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            guard error == nil else {
                print("Audio Engine Error: \(error!)")
                self.stopRecording()
                return
            }
            
            if let resultString = result?.bestTranscription.formattedString {
                if self.wordDetectedBlock != nil, self.listeningWord != nil,
                    resultString.lowercased().contains(self.listeningWord!) {
                    self.wordDetectedBlock!(self.listeningWord!)
                    self.stopRecording()
                }
            }
        })
        
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    public func stopRecording() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.inputNode.reset()
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        self.recognitionRequest = nil
        self.recognitionTask = nil
    }
    
}
