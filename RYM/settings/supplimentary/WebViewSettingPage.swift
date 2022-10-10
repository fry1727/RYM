//
//  WebViewSettingPage.swift
//  RYM
//
//  Created by Yauheni Skiruk on 10.10.22.
//

import SwiftUI
import WebKit

struct WebViewSettingsPage: View {
    let url: URL
    let header: String

    let homeRouter = HomeRouter.shared

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Button(action: {
                    homeRouter.dissmis()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                })
                .frame(width: 40, height: 40, alignment: .leading)
                Text(header)
                    .foregroundColor(.white)
                    .padding(.leading, 100)
                Spacer()
            }
            .padding(.horizontal)
            .frame(height: 48)
            .frame(alignment: .top)
            WebView(url: url)
        }
    }
}

struct WebViewSettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        WebViewSettingsPage(url: URL(string: "")!, header: "Terms of Use")
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context _: Context) -> some UIView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}
