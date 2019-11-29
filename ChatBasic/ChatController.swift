//
//  ChatController.swift
//  ChatBasic
//
//  Created by Julius Hopf on 2019-11-20.
//  Copyright © 2019 Julius Hopf. All rights reserved.
//

import Foundation
import Combine
import SwiftUI


// ChatController needs to be a ObservableObject in order
// to be accessible by SwiftUI
class ChatController : ObservableObject {
    // didChange will let the SwiftUI know that some changes have happened in this object
    // and we need to rebuild all the views related to that object
    var didChange = PassthroughSubject<Void, Never>()
    
    // We've relocated the messages from the main SwiftUI View. Now, if you wish, you can handle the networking part here and populate this array with any data from your database. If you do so, please share your code and let's build the first global open-source chat app in SwiftUI together
    // It has to be @Published in order for the new updated values to be accessible from the ContentView Controller
    @Published var garments:[Garment]
    @Published var messages: [ChatMessage]
    init() {
        garments = []
        messages = []
        initGarments()
    }

    
    
    func initGarments(){
        let fShirt = Garment (name: "fultröja", id: 1, gType: Garment.garmentType.shirt)
        garments.append(fShirt)
        
        var timeInterval = DateComponents()
        timeInterval.month = -6
        let todays = Calendar.current.date(byAdding: timeInterval, to: Date())!
        
        for gar in garments{
            
            if getDate(date: gar.lastUsed) == getDate(date: todays) {
                
                messages.append(ChatMessage(message: "Hej du har inte använt mig sedan " + getDate(date: gar.lastUsed), avatar: gar.name , color: .red))
              
              messages.append(ChatMessage(message: "Ska du inte använda mig snart?", avatar: gar.name , color: .red))
          }
        }
    }

    // this function will be accessible from SwiftUI main view
    // here you can add the necessary code to send your messages not only to the SwiftUI view, but also to the database so that other users of the app would be able to see it
    func sendMessage(_ chatMessage: ChatMessage) {
        // here we populate the messages array
        messages.append(chatMessage)
        // here we let the SwiftUI know that we need to rebuild the views
        didChange.send(())

    }
    
    func getDate(date : Date) -> String {

        var ret : String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        ret = formatter.string(from: date)
        
        return ret
    }
    
}
