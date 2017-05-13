//
//  InterfaceController.swift
//  Mobile-Day-Impacta-Watch Extension
//
//  Created by Ezequiel on 13/05/17.
//  Copyright © 2017 Ezequiel. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

extension Array {
    
    func aleatorio() -> Element  {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}

class InterfaceController: WKInterfaceController {
    
    fileprivate var wcSession: WCSession!
    
    @IBOutlet var savedAnimal: WKInterfaceLabel!
    @IBOutlet var veggieButton: WKInterfaceButton!
    let animaizinhos = ["🐶", "🐱", "🐭","🐹" ,"🐰","🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷"]
    
    
    @IBAction func veggieButtonTouched() {
        saveAnimal(self.animaizinhos.aleatorio())
    }
    
    func saveAnimal(_ animal:String) {
        
        print("\n Salvando um animalzinho...")
        print(animal)
        let data:Data = animal.data(using: .utf8)!
        wcSession.sendMessageData(data, replyHandler: nil, errorHandler: {(error) -> Void in
            print("WCSession errors have occurred: \(error.localizedDescription)")
        })
        
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if WCSession.isSupported() {
            wcSession = WCSession.default()
            wcSession.delegate = self
            wcSession.activate()
        }
    }
}

extension InterfaceController : WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async {
            
            if let status = String(data: messageData, encoding: .utf8) {
                print(status)
                self.savedAnimal.setText(status)
                //self.statusLabel.setText(status)
            }
        }
    }
}
