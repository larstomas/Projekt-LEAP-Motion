//
//  GarmentDisplayView.swift
//  ChatBasic
//
//  Created by Julius Hopf on 2019-12-05.
//  Copyright © 2019 Julius Hopf. All rights reserved.
//

import SwiftUI

struct GarmentDisplayView: View {
    var body: some View {
        VStack{
            CircleImage()
        VStack(alignment: .leading){
            Text("Ful Tröja")
                .font(.largeTitle)
            HStack{
                Text("Senast använd: 6 månader sedan")
            Spacer()
                Button("Sälj"){
                    
                }
                .padding()
                .background(Color.red)
                .cornerRadius(40)
                .foregroundColor(.white)
                .padding(5)
            }
            }
            .padding()
        }
    }
}

struct GarmentDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        GarmentDisplayView()
    }
}
