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
import Swift
let debugMode = false

extension String {
    func containsExact(word : String) -> Bool
    {
        return self.range(of: "\\b\(word)\\b", options: .regularExpression) != nil
    }
}


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
              
              messages.append(ChatMessage(message: "Är det inte dags att vi ses nån gång snart igen? ☺️", avatar: gar.name , color: .red))
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
    
    
    
    func parseMessage(_ chatMessage: ChatMessage) -> Bool{
        let jaSvar:[String] = ["ja", "visst", "okej", "absolut", "okejdå", "gärna", "perfekt"]
        let str = chatMessage.message;
        
        //Quick fix for empty messages
        if(str == ""){return false}
        
        let answer = str.split(separator: " ")[0].lowercased()
        if(debugMode){print("Answer: ", answer)}
        
        //Compare answer to all possible "jaSvar"
        for svar in jaSvar {
            if (answer.containsExact(word : svar)){
                return true;
            }
        }
        return false
        
    }
    
    var chatId : integer_t = 1
    
    
    func generateAnswer(p: Bool) -> String{
        var answer : String
        
        
        switch chatId {
            //Reset
        case 0:
            answer = "Är det inte dags att vi ses nån gång snart igen? ☺️"
            chatId = 1
            //Vill du ha kvar mig i garderoben?
        case 1:
            if(!p){
                answer = "Okej vad tråkigt att höra 😭. Men vill du kanske sälja mig vidare så någon annan kan dra nytta av mig? 💰"
                chatId = 2
            }
            else{
                answer = "Okej men då hänger jag kvar här i garderoben. Hoppas vi ses snart! 👋"
                chatId = 0
            }
            break
            
            // Vill du sälja mig
        case 2:
                if(p){
                    answer = "Oj vad spännande det här ska bli! Vad sägs om att jag lägger upp en anons för mig på tradera? 🤸‍♂️"
                    //Tradera
                    chatId = 3
                }
                else{
                    answer = "Okej. Men det är ju dumt att jag bara hänger här i garderoben och tar upp plats. Du vill inte skänka mig till Röda Korset då? 🎁"
                    //Röda korset
                    chatId = 4
                }
                break
            //Lägga upp mig på tradera?
            case 3:
                    if(p){
                        answer = "Perfekt! Nu har jag lagt upp min annons på tradera. Kan HUGO hämta upp mig kl 18:30 idag? 🚗"
                        //Hugo hämtning
                        chatId = 5
                    }
                    else{
                        answer = "Okej, ta med mig till nästa loppis då! 😃"
                        chatId = 0
                    }
                    break
            //Röda Korset
            case 4:
                    if(p){
                        answer = "Vad snäll du är som kan tänka dig att skicka vidare mig så jag kan skänka lycka till någon annan! Kan HUGO hämta upp mig kl 18:30?"
                        //Hugo hämtning
                        chatId = 5
                    }
                    else{
                        answer = "Jaha. Så du vill inte sälja mig eller skänka mig vidare. Är det för att jag är trasig?"
                        chatId = 6
                    }
                    break
            //HUGO hämtning
            case 5:
                    if(p){
                        answer = "Perfekt! Jag hör av mig när HUGO nörmar sig så kan du bära ut mig. Jag har nämligen lite svårt att ta mig ut sälv. Vi ses om en stund!"
                        //Hugo hämtning
                        chatId = 0
                    }
                    else{
                        answer = "Okej, hör av dig till Hugo när du vet en tid som passar! ☎️"
                        chatId = 0
                    }
                    break
            //Laga?
            case 6:
                    if(p){
                        answer = "Aj, va synd! 😧. Men om du har sparat mig så länge trots att jag är trasig, ska jag boka en tid så att en skräddare kan laga mig? 🤕"
                        //Hugo hämtning
                        chatId = 7
                    }
                    else{
                        answer = "Okej, vill du återvinna mig? ♻️"
                        chatId = 8
                    }
                    break
            //Skräddare
            case 7:
                    if(p){
                        answer = "Kan hugo hämta mig kl 18:30 och köra mig till nörmaste skräddare? 🧶🧵"
                        //Hugo hämtning
                        chatId = 5
                    }
                    else{
                        answer = "Vill du återvinna mig? ♻️"
                        chatId = 8
                    }
                    break
            //Återvinna
        case 8:
                if(p){
                    answer = "Kan hugo hämta mig kl 18:30 och köra mig till nörmaste återvinningsstation? 👍"
                    //Hugo hämtning
                    chatId = 5
                }
                else{
                    answer = "Men då hänger jag kvar i garderoben så kan du bestämma senare vad du vill göra med mig? 👚👕👔👗"
                    chatId = 0
                }
                break

        default:
            answer = "Chatboten har inte stöd för denna konversationen än. Chatid:" + String(chatId)
            chatId = 0
        }
        return answer
    }
}
