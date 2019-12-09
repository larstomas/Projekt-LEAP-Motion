//
//  CircleImage.swift
//  ChatBasic
//
//  Created by Julius Hopf on 2019-12-05.
//  Copyright © 2019 Julius Hopf. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("sweater")
        .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
