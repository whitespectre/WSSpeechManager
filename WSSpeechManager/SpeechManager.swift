//
//  SpeechManager.swift
//
//  Created by Lucas Diez de Medina on 18/06/2018.
//  Copyright © 2018 Lucas Diez de Medina. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

public class SpeechManager: NSObject {
    
    var player: AVAudioPlayer?
    let audioEngine = AVAudioEngine()
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    internal var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    internal var recognitionTask: SFSpeechRecognitionTask?
    
    public static let shared = SpeechManager()
    
    var listeningWord : String? = nil
    var wordDetectedBlock: WordRecognizedBlock? = nil
    
    override init() {
        super.init()
        speechRecognizer?.delegate = self
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
    }
    
    public func playSound(_ name: String, withExtension fileExtension: String = "mp3") {
        guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print (error.localizedDescription)
        }
    }
    
    public func playSystemSound(soundId: Int, ignoreMuteSwitch: Bool = false) {
        guard let fileName = systemSounds[soundId],
            let url = URL(string: "/System/Library/Audio/UISounds/" + fileName) else { return }
        
        if ignoreMuteSwitch {
            do {
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
                guard let player = player else { return }
                player.play()
            } catch let error {
                print (error.localizedDescription)
            }
        } else {
            AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(soundId), nil)
        }
    }

}

let systemSounds = [
    1015 : "Voicemail.caf",
    1070 : "ct-busy.caf",
    1074 : "ct-call-waiting.caf",
    1071 : "ct-congestion.caf",
    1073 : "ct-error.caf",
    1075 : "ct-keytone2.caf",
    1072 : "ct-path-ack.caf",
    1113 : "begin_record.caf",
    1117 : "begin_video_record.caf",
    1005 : "alarm.caf",
    1108 : "photoShutter.caf",
    1106 : "beep-beep.caf",
    1114 : "end_record.caf",
    1118 : "end_video_record.caf",
    1256 : "short_low_high.caf",
    1258 : "short_double_low.caf",
    1257 : "short_double_low.caf",
    1255 : "short_double_high.caf",
    1254 : "long_low_short_high.caf",
    1259 : "middle_9_short_double_low.caf",
    1115 : "jbl_ambiguous.caf",
    1110 : "jbl_begin.caf",
    1112 : "jbl_cancel.caf",
    1111 : "jbl_confirm.caf",
    1116 : "jbl_no_match.caf",
    1306 : "Tock.caf",
    1103 : "Tink.caf",
    1104 : "Tock.caf",
    1105 : "Tock1.caf",
    1006 : "low_power.caf",
    1000 : "new-mail.caf",
    1001 : "mail-sent.caf",
    1057 : "Tink.caf",
    1107 : "RingerChanged.caf",
    1100 : "lock.caf",
    1101 : "unlock.caf",
    1109 : "shake.caf",
    1051 : "SIMToolkitCallDropped.caf",
    1052 : "SIMToolkitGeneralBeep.caf",
    1053 : "SIMToolkitNegativeACK.caf",
    1054 : "SIMToolkitPositiveACK.caf",
    1055 : "SIMToolkitSMS.caf",
    1003 : "ReceivedMessage.caf",
    1007 : "sms-received1.caf",
    1008 : "sms-received2.caf",
    1009 : "sms-received3.caf",
    1010 : "sms-received4.caf",
    1012 : "sms-received12.caf",
    1013 : "sms-received5.caf",
    1014 : "sms-received6.caf",
    1020 : "Anticipate.caf",
    1021 : "Bloom.caf",
    1022 : "Calypso.caf",
    1023 : "Choo_Choo.caf",
    1024 : "Descent.caf",
    1025 : "Fanfare.caf",
    1026 : "Ladder.caf",
    1027 : "Minuet.caf",
    1028 : "News_Flash.caf",
    1029 : "Noir.caf",
    1030 : "Sherwood_Forest.caf",
    1031 : "Spell.caf",
    1032 : "Suspense.caf",
    1033 : "Telegraph.caf",
    1034 : "Tiptoes.caf",
    1035 : "Typewriters.caf",
    1036 : "Update.caf",
    1307 : "sms-received1.caf",
    1308 : "sms-received2.caf",
    1309 : "sms-received3.caf",
    1310 : "sms-received4.caf",
    1312 : "sms-received1_1.caf",
    1313 : "sms-received5.caf",
    1314 : "sms-received6.caf",
    1320 : "Anticipate.caf",
    1321 : "Bloom.caf",
    1322 : "Calypso.caf",
    1323 : "Choo_Choo.caf",
    1324 : "Descent.caf",
    1325 : "Fanfare.caf",
    1326 : "Ladder.caf",
    1327 : "Minuet.caf",
    1328 : "News_Flash.caf",
    1329 : "Noir.caf",
    1330 : "Sherwood_Forest.caf",
    1331 : "Spell.caf",
    1332 : "Suspense.caf",
    1333 : "Telegraph.caf",
    1334 : "Tiptoes.caf",
    1335 : "Typewriters.caf",
    1336 : "Update.caf",
    1004 : "SentMessage.caf",
    1016 : "tweet_sent.caf",
    1300 : "Voicemail.caf",
    1301 : "ReceivedMessage.caf",
    1302 : "new-mail.caf",
    1303 : "mail-sent.caf",
    1304 : "alarm.caf",
    1305 : "lock.caf",
    1315 : "Voicemail_1.caf",
    1200 : "dtmf-0.caf",
    1201 : "dtmf-1.caf",
    1202 : "dtmf-2.caf",
    1203 : "dtmf-3.caf",
    1204 : "dtmf-4.caf",
    1205 : "dtmf-5.caf",
    1206 : "dtmf-6.caf",
    1207 : "dtmf-7.caf",
    1208 : "dtmf-8.caf",
    1209 : "dtmf-9.caf",
    1210 : "dtmf-star.caf",
    1211 : "dtmf-pound.caf",
    1050 : "ussd.caf",
    1154 : "vc~ringing.caf",
    1153 : "ct-call-waiting.caf",
    1152 : "vc~ended.caf",
    1150 : "vc~invitation-accepted.caf",
    1151 : "vc~ringing.caf",
    1002 : "Voicemail.caf"
]
