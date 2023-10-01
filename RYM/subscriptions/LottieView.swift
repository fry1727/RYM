//
//  LottieView.swift
//  RYM
//
//  Created by Yauheni Skiruk on 17.08.23.
//

import Foundation
import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    let animationView = LottieAnimationView()
    var fileName = "Flow 2"

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> some UIView {
        let view = UIView(frame: .zero)

        animationView.animation = LottieAnimation.named(fileName)

        guard let animation = LottieAnimation.named(fileName, bundle: .main) else {
                   fatalError("Couldn't load animation")
               }
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
                  animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
                  animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
              ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

     }
}
