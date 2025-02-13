//
//  Home.swift
//  Animated Header (iOS)
//
//  Created by Balaji on 09/01/21.
//

import SwiftUI

struct Home: View {
    @StateObject var homeData = HomeViewModel()
    // For Dark Mode Adoption....
    @Environment(\.colorScheme) var scheme
    var body: some View {
        ScrollView(showsIndicators: false) {
            // Since Were Pinning Header View....
            LazyVStack(alignment: .leading, spacing: 15, pinnedViews: [.sectionHeaders], content: {
                // Parallax Header....

                GeometryReader { reader -> AnyView in

                    let offset = reader.frame(in: .global).minY

                    if -offset >= 0 {
                        DispatchQueue.main.async {
                            self.homeData.offset = -offset
                        }
                    }

                    return AnyView(
                        Color.red
                    )
                }
                .frame(height: 250)

                // Cards......

                Section(header: HeaderView(homeData: homeData)) {
                    // Tabs With Content....

                    VStack(alignment: .leading, spacing: 15, content: {
//
                        ForEach(0 ..< 30) { _ in

                            Color.yellow
                                .frame(width: 200, height: 200)
                        }
                    })
                }
            })
        }
        .overlay(
            // Only Safe Area....
            (scheme == .dark ? Color.black : Color.white)
                .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                .ignoresSafeArea(.all, edges: .top)
                .opacity(homeData.offset > 250 ? 1 : 0)
            , alignment: .top
        )
        // Used It Environment Object For Accessing All SUb Objects....
        .environmentObject(homeData)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
