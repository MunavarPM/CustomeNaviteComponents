//
//  DetentBottomSheet.swift
//  Demo
//
//  Created by Munavar PM on 14/07/24.
//

import SwiftUI

struct DetentBottomSheet<Destination: View>: ViewModifier {
    let heights = stride(from: 0.1, through: 1.0, by: 0.1).map { PresentationDetent.fraction($0) }
    @Binding var showSheet: Bool
    var detent: [PresentationDetent]?
    var showPresentationIdicator: Visibility = .visible
    var destination: () -> (Destination)
    init(
        showSheet: Binding<Bool>,
        detent: [PresentationDetent]?,
        showPresentationIdicator: Visibility,
        destination: @escaping () -> Destination) {
        _showSheet = showSheet
        self.detent = detent
        self.showPresentationIdicator = showPresentationIdicator
        self.destination = destination
    }

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showSheet) {
                destination()
                    .presentationDetents(Set(detent ?? heights))
                    .presentationDragIndicator(showPresentationIdicator)
            }
    }
}

extension View {
    
    ///  ///
    /// Usage: -
    ///  The following example  to present a bottom sheet
    ///
    ///      var body: some View {
    ///             VStack {
    ///                 //// Body
    ///             }
    ///              .presentDetentSheet($showSheet, detent: nil, showPresentationIdicator: .hidden) {
    ///                   DemoView()
    ///             }
    ///          }
    ///
    /// - Parameters:
    ///   - showSheet: to show the bottom sheet
    ///   - detent: to describe the size of the sheet example: [.large, .medium], [.fraction(0.5)], [.height(200)]
    ///   - showPresentationIdicator: to show and hide the sheet indicator
    ///   - destination: destination view or the content of the sheet
    /// - Returns: Bootom sheet
    func presentDetentSheet<Destination: View>(
        _ showSheet: Binding<Bool>,
        detent: [PresentationDetent]?,
        showPresentationIdicator: Visibility = .visible,
        @ViewBuilder destination: @escaping () -> Destination
    ) -> some View {
        modifier(DetentBottomSheet(showSheet: showSheet, detent: detent, showPresentationIdicator: showPresentationIdicator, destination: destination))
    }
}


// MARK: - Preview

struct BottomSheetPreview: View {
    @State var showSheet = false
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.largeTitle)
            Button("show Sheet") {
                self.showSheet = true
            }
        }
        .padding()
        .presentDetentSheet($showSheet, detent: [.medium, .large], showPresentationIdicator: .visible) {
            DemoView()
        }
    }
}

#Preview {
    BottomSheetPreview()
}

struct DemoView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0...3, id: \.self) { item in
                    Text("\(item)")
                        .padding()
                }
            }
        }
    }
}
