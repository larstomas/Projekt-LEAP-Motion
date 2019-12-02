import SwiftUI

// let's create a structure that will represent each message in chat
struct ChatMessage : Hashable {
    var message: String
    var avatar: String
    var color: Color
     // isMe will be true if We sent the message
    var isMe: Bool = false
}

// ChatRow will be a view similar to a Cell in standard Swift
struct ChatRow : View {
    // we will need to access and represent the chatMessages here
    var chatMessage: ChatMessage
    // body - is the body of the view, just like the body of the first view we created when opened the project
    var body: some View {
        // HStack - is a horizontal stack. We let the SwiftUI know that we need to place
        // all the following contents horizontally one after another
        HStack{
            
            if !chatMessage.isMe {
                Group{
                    Text(chatMessage.message)
                    .bold()
                    .padding()
                    .foregroundColor(Color.white)
                    .background(chatMessage.color)
                    .cornerRadius(15)
                    .padding(.bottom, 2)
                }
            } else {
                HStack{
                    Group {
                        Spacer()
                        
                        Text(chatMessage.message)
                        .bold()
                        .padding(10)
                        .foregroundColor(Color.white)
                        .background(chatMessage.color)
                        .cornerRadius(10)
                        .padding(.bottom, 2)
                    }
                }
            }
        }

    }
}

struct ContentView : View {
    
     // @State here is necessary to make the composedMessage variable accessible from different views
    @State var composedMessage: String = ""
    @EnvironmentObject var chatController: ChatController

    
    var body: some View {
      
        // the VStack is a vertical stack where we place all our substacks like the List and the TextField
        VStack {
            // I've removed the text line from here and replaced it with a list
            // List is the way you should create any list in SwiftUI
            //nav change
            NavigationView {
                ScrollView () {
                    VStack(alignment: .leading) {
                        ForEach(chatController.messages, id: \.self) {msg in
                            ChatRow(chatMessage: msg)
                        }
                    }
                }
            }.padding()
            
            // TextField are aligned with the Send Button in the same line so we put them in HStack
            HStack {
                // this textField generates the value for the composedMessage @State var
                TextField("Meddelande...", text: $composedMessage).frame(minHeight: CGFloat(30))
                // the button triggers the sendMessage() function written in the end of current View
                Button(action: sendMessage) {
                    Text("Skicka")
                }
            }.frame(minHeight: CGFloat(50)).padding()
            // that's the height of the HStack
        }
    }
    func sendMessage() {
        chatController.sendMessage(ChatMessage(message: composedMessage, avatar: "Julius", color: .green, isMe: true))
        let yesOrNo : Bool = chatController.parseMessage(ChatMessage(message: composedMessage, avatar: "Julius", color: .green, isMe: true))
        
        
        composedMessage = ""
        
        chatController.sendMessage(ChatMessage(message: chatController.generateAnswer(p:yesOrNo), avatar: "Tröja", color: .red))
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(ChatController())
    }
}
#endif
