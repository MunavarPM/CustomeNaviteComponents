//
//  ContentView.swift
//  StickyHeader
//
//  Created by wac on 16/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var stickyOffset: CGFloat = 0
    @State private var isValue: CGFloat = 0

    var body: some View {
      
            GeometryReader { geo in
                ScrollView {
                    ScrollViewReader { scrollView in
                        VStack(spacing: 20) {
                            Text("Header 1")
                                .frame(width: UIScreen.main.bounds.width, height: 100)
                                .background(Color.blue)

                            Text("Header 2")
                                .frame(width: UIScreen.main.bounds.width, height: 100)
                                .background(Color.green)
                                .padding(.bottom, 100)

                          
                            
                            // Content
                            ForEach(1..<50) { index in
                                Text("Item \(index)")
                                    .frame(width: UIScreen.main.bounds.width, height: 50)
                                    .background(Color.gray)
                            }
                            
                        }
                        .overlay(content: {
                            // Sticky Header
                            GeometryReader { geometry in
                                VStack {
                                Text("Sticky Header")
                                    .frame(width: UIScreen.main.bounds.width, height: 100)
                                    .background(Color.red)
                                    .offset(y: max(0, -scrollOffset + stickyOffset + geo.safeAreaInsets.top)) // Adjust offset for navigation bar height
                                    .background(GeometryReader {
                                        Color.clear
                                            .preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named("scroll")).origin.y)
                                    })
                                    .opacity(isValue > 56 ? 1 : 0)
                                    Spacer()
                            }
                            }
                            .frame(height: 100)
                            .padding(.top, -(1645))
                        })
                        .onPreferenceChange(ViewOffsetKey.self) { value in
                            stickyOffset = value
                            isValue = value
                            print(value)
                        
                        }
                        .onChange(of: stickyOffset) { newValue in
                            scrollView.scrollTo("scrollToTop", anchor: .top)
                        }
                    }
                    .id("scroll")
                }
            }
        
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
