//
//  WKWebView+Load.swift
//  News
//
//  Created by Daniel Nunez on 27-02-21.
//

import WebKit

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
