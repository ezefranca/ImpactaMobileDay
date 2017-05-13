//
//  ViewController.swift
//  Mobile-Day-Impacta
//
//  Created by Ezequiel on 13/05/17.
//  Copyright © 2017 Ezequiel. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {
    
    fileprivate var wcSession: WCSession!
    
    @IBOutlet var updateTitle: UIButton!
    @IBOutlet var savedAnimalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if WCSession.isSupported() {
            wcSession = WCSession.default()
            wcSession.delegate = self
            wcSession.activate()
            self.updateTitle.setTitle("Atualizar", for: .normal)
        }
        //updateConnectButtonTitle()
    }
    
    
    @IBAction func sendNumerOfAnimals(_ sender: Any) {
        let title = "Go 🌱!!"
        let data:Data = title.data(using: .utf8)!
        wcSession.sendMessageData(data, replyHandler: nil, errorHandler: {(error) -> Void in
            print("WCSession errors have occurred: \(error.localizedDescription)")
        })
    }
}


extension ViewController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print("\nAt the phone end...")
        print(messageData)
        if let animal = String(data: messageData, encoding: .ascii) {
            self.savedAnimalLabel.text = animal
            print(animal)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        
        print("\nAt the phone end...")
        print(messageData)
        if let animal = String(data: messageData, encoding: .utf8) {
            self.savedAnimalLabel.text = animal
            print(animal)
        }
    }
    //func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}

