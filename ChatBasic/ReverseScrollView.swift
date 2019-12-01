//
//  ReverseScrollView.swift
//  customScrollView
//
//  Created by John Mellard Buhian on 2019-12-01.
//  Copyright © 2019 John Mellard Buhian. All rights reserved.
//

import SwiftUI

struct ReverseScrollView<Content>: View where Content: View {
    @State private var contentHeight: CGFloat = CGFloat.zero
    @State private var scrollOffset: CGFloat = CGFloat.zero
    @State private var currentOffset: CGFloat = CGFloat.zero
    
    var content: () -> Content
    
    func offset(outerheight: CGFloat, innerheight: CGFloat) -> CGFloat
    {
        print("outerheight: \(outerheight) innerheight: \(outerheight)")
        
        let totalOffset = currentOffset + scrollOffset
        return -((innerheight/2 - outerheight/2) - totalOffset)
    }
    
    var body: some View {
        GeometryReader { outerGeometry in
            //render the content
            //set its sizing inside the parent
            
            self.content()
                .modifier(ViewHeightKey())
                .onPreferenceChange(ViewHeightKey.self) {self.contentHeight = $0}
                .frame(height: outerGeometry.size.height)
                .offset(y: self.offset(outerheight: outerGeometry.size.height, innerheight: self.contentHeight))
                .clipped()
                .animation(.easeInOut)
                .gesture(
                    DragGesture()
                        .onChanged({self.onDragChanged($0) })
                        .onEnded({self.onDragEnded($0, outerHeight: outerGeometry.size.height)})
                )
        }
    }
    
    func onDragChanged(_ value: DragGesture.Value) {
        print("start: \(value.startLocation.y)")
        print("start: \(value.location.y)")
        self.scrollOffset = (value.location.y - value.startLocation.y)
        print("ScrollOffset: \(self.scrollOffset)")
    }
    
    func onDragEnded(_ value: DragGesture.Value, outerHeight: CGFloat) {
        let scrollOffset = value.location.y - value.startLocation.y
        print("ended currentOffset = \(self.currentOffset) scrollOffset = \(scrollOffset)")
        
        let topLimit = self.contentHeight - outerHeight
        print("topLimit = \(topLimit))")
        
        if topLimit < 0{
            self.currentOffset = 0
        } else {
            if self.currentOffset + scrollOffset < 0 {
                self.currentOffset = 0
            } else if self.currentOffset + scrollOffset > topLimit {
                self.currentOffset = topLimit
            } else {
                self.currentOffset += scrollOffset
            }
        }
        print("new currentOffset = \(self.currentOffset)")
        self.scrollOffset = 0
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat{0}
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

extension ViewHeightKey: ViewModifier {
    func body(content: Content) -> some View {
        return content.background(GeometryReader { proxy in
            Color.clear.preference(key: Self.self, value: proxy.size.height)
        })
    }
}

/*
struct ReverseScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ReverseScrollView {
            VStack {
                ForEach(demoConversation.messages) { message in
                    BubbleView(message: "Hello")
                }
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
*/
