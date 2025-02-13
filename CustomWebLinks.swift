import SwiftUI
import WebKit

// MARK: ⚠️ Don't change WebKit to another WebView service because the React team is removing the header of WebView based on this WebKit reference.

struct CustomWebLinks: View {
    // MARK: - PROPERTIES

    @State var link = ""
    @Environment(\.dismiss) private var dismiss
    @State var header = false
    var headerText: String = "Benefits"
    var isTitleHeaderNeedHome: Bool = true

    // MARK: - BODY

    var body: some View {
        VStack(spacing: 0) {
            TitleHeaderView(headerText: header ? headerText : "", leadingBT: true, leadingBTAction: {
                dismiss()
            }, homeButtonEnabled: isTitleHeaderNeedHome)
                .padding(.top, UIConstants.screenWidth * 0.03653435115)
                .padding(.bottom, UIConstants.screenWidth * 0.025)
            Spacer()
            HStack {
                if let link = URL(string: link) {
                    WebViewContainer(url: link)
                        .navigationBarTitle("", displayMode: .automatic)
                        .navigationBarBackButtonHidden(true)
                        .padding(.top, -(UIConstants.screenWidth * 0.05089058524))
                }
            }
        }
    }
}

// struct WebViewContainer: UIViewRepresentable {
//    let url: URL
//
//    func makeUIView(context: Context) -> WKWebView {
//        return WKWebView()
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        let request = URLRequest(url: url)
//        uiView.load(request)
//    }
// }
struct CustomWebLinksUIViewRepresentable: UIViewRepresentable {
    let link: String
    let header: Bool
    let headerText: String
    let isTitleHeaderNeedHome: Bool
    @Binding var isNavigateToCreateMukafaAccount: Bool
    @Environment(\.dismiss) var dismiss

    // Create and configure the WKWebView
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        if let url = URL(string: link) {
            webView.load(URLRequest(url: url))
            print("Navigating to: \(url)")
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No need to update the view in this case
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: CustomWebLinksUIViewRepresentable

        init(_ parent: CustomWebLinksUIViewRepresentable) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Update canGoBack based on webView's history
            //parent.canGoBack = webView.canGoBack
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url?.absoluteString,
               let urlComponents = URL(string: url) {
                let path = urlComponents.lastPathComponent
                if path == "create-account" {
                    parent.isNavigateToCreateMukafaAccount = true
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
    }
}

struct CustomWebLinksUIViewRepresentableForReturn: UIViewRepresentable {
    let link: String
    let header: Bool
    let headerText: String
    let isTitleHeaderNeedHome: Bool
    @Binding var isNavigateToReturnModule: Bool // Binding to trigger navigation to the create account page

    // Create and configure the WKWebView
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator // Set the delegate
        if let url = URL(string: link) {
            webView.load(URLRequest(url: url))
            print("Navigating to: \(url)")
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No need to update the view in this case
    }

    // Create a coordinator to act as the WKNavigationDelegate
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: CustomWebLinksUIViewRepresentableForReturn

        init(_ parent: CustomWebLinksUIViewRepresentableForReturn) {
            self.parent = parent
        }

        // This method gets called when a new navigation occurs
      func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
          if let url = navigationAction.request.url?.absoluteString, let urlComponents = URL(string: url) {
              print("Navigating to - Return: \(url)")

              // Get the last path component
              let path = urlComponents.lastPathComponent

              // Check if the path matches the "My Orders" page
              if path == "my-orders" {
                  // Trigger navigation to the native "Return Module" page
                  self.parent.isNavigateToReturnModule = true
                  decisionHandler(.cancel) // Stop the WebView from navigating to the URL
                  return
              }
              // Handle "tel:" scheme to open phone dialer
              else if url.hasPrefix("tel:") {
                  if let telURL = URL(string: url) {
                      UIApplication.shared.open(telURL, options: [:], completionHandler: nil)
                  }
                  decisionHandler(.cancel) // Prevent WebView from loading the "tel:" link
                  return
              }
              // Handle WhatsApp URL scheme
              else if url.hasPrefix("https://wa.me/") {
                  if let waURL = URL(string: url) {
                      UIApplication.shared.open(waURL, options: [:], completionHandler: nil)
                  }
                  decisionHandler(.cancel) // Prevent WebView from loading the WhatsApp link
                  return
              }
              else {
                  print("URL become different in - Return: \(url)")
              }
          }

          decisionHandler(.allow) // Default case: allow the navigation
      }

    }
}

struct CustomWebLinkUIViewRepresentable: View {
    let link: String
    let header: Bool
    let headerText: String
    let isTitleHeaderNeedHome: Bool
    @Binding var isNavigateToCreateAccount: Bool
    @Environment(\.dismiss) var dismiss
    @State var isFromLogin: Bool?
    @State private var isNaivageToHome: Bool = false

    var body: some View {
        ZStack {
            NavigationLink("", destination: CustomTabBar().navigationBarBackButtonHidden(true), isActive: $isNaivageToHome)
            VStack(spacing: 0) {
                // Conditionally render the TitleHeaderView
                if header {
                    TitleHeaderView(
                        headerText: headerText,
                        leadingBT: true,
                        leadingBTAction: {
                            if isFromLogin ?? false {
                                isNaivageToHome = true
                            } else {
                                dismiss()
                            }
                        },
                        homeButtonEnabled: isTitleHeaderNeedHome
                    )
                    .padding(.top, UIConstants.screenWidth * 0.03653435115)
                    .padding(.bottom, UIConstants.screenWidth * 0.025)
                }

                // The WKWebView inside CustomWebLinks
                CustomWebLinksUIViewRepresentable(
                    link: link,
                    header: header,
                    headerText: headerText,
                    isTitleHeaderNeedHome: isTitleHeaderNeedHome,
                    isNavigateToCreateMukafaAccount: $isNavigateToCreateAccount
                )
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct CustomWebLinkUIViewRepresentableForReturn: View {
    let link: String
    let header: Bool
    let headerText: String
    let isTitleHeaderNeedHome: Bool
    @Binding var isNavigateToReturn: Bool
    @Environment(\.dismiss) var dismiss
    @State var isFromLogin: Bool?
    @State private var isNaivageToHome: Bool = false

    var body: some View {
        ZStack {
            NavigationLink("", destination: CustomTabBar().navigationBarBackButtonHidden(true), isActive: $isNaivageToHome)
            VStack(spacing: 0) {
                // Conditionally render the TitleHeaderView
                if header {
                    TitleHeaderView(
                        headerText: headerText,
                        leadingBT: true,
                        leadingBTAction: {
                            if isFromLogin ?? false {
                                isNaivageToHome = true
                            } else {
                                dismiss()
                            }
                        },
                        homeButtonEnabled: isTitleHeaderNeedHome
                    )
                    .padding(.top, UIConstants.screenWidth * 0.03653435115)
                    .padding(.bottom, UIConstants.screenWidth * 0.025)
                }

                // The WKWebView inside CustomWebLinks
                CustomWebLinksUIViewRepresentableForReturn(
                    link: link,
                    header: header,
                    headerText: headerText,
                    isTitleHeaderNeedHome: isTitleHeaderNeedHome,
                    isNavigateToReturnModule: $isNavigateToReturn
                )
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}
