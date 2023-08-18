//
//  View+Extensions.swift
//  RYM
//
//  Created by Yauheni Skiruk on 2.11.22.
//

import Foundation
import SwiftUI

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

extension View {
    func progress(_ isVisible: Bool, onTapped: @escaping () -> Void) -> some View {
        ZStack(alignment: .center) {
            self
            if isVisible {
                Group {
                    Color.black.opacity(0.7).ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                }
                .onTapGesture(perform: onTapped)
            }
        }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
