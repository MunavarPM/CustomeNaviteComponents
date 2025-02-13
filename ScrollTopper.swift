import SwiftUI

struct ScrollTopper: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    ScrollTopper()
}

struct ContentView1: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        CustomTabBar(selectedTab: $selectedTab)
    }
}

enum Tab {
    case home, settings
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        VStack {
            switch selectedTab {
            case .home:
                HomeView()
            case .settings:
                SettingsView()
            }

            HStack {
                Button(action: {
                    handleTabSelection(.home)
                }) {
                    Text("Home")
                }
                .padding()
                Button(action: {
                    handleTabSelection(.settings)
                }) {
                    Text("Settings")
                }
                .padding()
            }
            .background(Color.yellow)
        }
    }

    private func handleTabSelection(_ tab: Tab) {
        if selectedTab == tab {
            scrollToTop()
        } else {
            selectedTab = tab
        }
    }

    private func scrollToTop() {
        NotificationCenter.default.post(name: .scrollToTop, object: nil)
    }
}

extension Notification.Name {
    static let scrollToTop = Notification.Name("scrollToTop")
}

struct HomeView: View {
    @State private var scrollProxy: ScrollViewProxy?

    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                List(0..<100, id: \.self) { i in
                    Text("Row \(i)")
                }
                .onAppear {
                    scrollProxy = proxy
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .scrollToTop)) { _ in
                scrollToTop()
            }
        }
    }

    private func scrollToTop() {
        withAnimation {
            scrollProxy?.scrollTo(0, anchor: .top)
        }
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings")
    }
}
