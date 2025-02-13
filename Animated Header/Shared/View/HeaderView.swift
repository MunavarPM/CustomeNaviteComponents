//
//  HeaderView.swift
//  Animated Header (iOS)
//
//  Created by Balaji on 09/01/21.
//

import SwiftUI

struct HeaderView: View {
    
    @ObservedObject var homeData : HomeViewModel
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0){
            
            HStack(spacing: 0){
                
                Text("Kavsoft Bakery")
                    .font(.title)
                    .fontWeight(.bold)
                    .opacity(homeData.offset > 200 ? Double((homeData.offset - 200) / 50) : 0)
            }
            
            ZStack{
                
                VStack(alignment: .leading, spacing: 10, content: {
                    HStack {
                        ForEach(0 ..< 3) {_ in
                            Color.green
                                .frame(width: 30, height: 30)
                        }
                    }
                    HStack {
                        ForEach(0 ..< 3) {_ in
                            Color.green
                                .frame(width: 30, height: 30)
                        }
                    }
                    HStack {
                        ForEach(0 ..< 3) {_ in
                            Color.green
                                .frame(width: 30, height: 30)
                        }
                    }
                })
                .opacity(homeData.offset > 200 ? 1 - Double((homeData.offset - 200) / 50) : 1)
                
                // Custom ScrollView....
                
                // For Automatic Scrolling...
                
                ScrollViewReader { reader in
                    
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack {
                            ForEach(0 ..< 10) { _ in
                                Color.green
                                    .frame(width: 30, height: 30)
                            }
                        }
                    })
                    
                    // Visible Only When Scrolls Up...
                    .opacity(homeData.offset > 200 ? Double((homeData.offset - 200) / 50) : 0)
                }
            }
            // Default Frame = 60...
            // Top Fram = 40
            // So Total = 100
            .frame(height: 60)
    
            if homeData.offset > 250{
                Divider()
            }
        }
        .padding(.horizontal)
        .frame(height: 100)
        .background(scheme == .dark ? Color.black : Color.white)
    }
    
    // Getting Size Of Button And Doing ANimation...
    func getSize()->CGFloat{
        
        if homeData.offset > 200{
            let progress = (homeData.offset - 200) / 50
            
            if progress <= 1.0{
                return progress * 40
            }
            else{
                return 40
            }
        }
        else{
            return 0
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
