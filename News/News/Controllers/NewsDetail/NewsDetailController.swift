//
//  NewsDetailController.swift
//  News
//
//  Created by Daniel Nunez on 27-02-21.
//

import UIKit
import WebKit

class NewsDetailController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!

    static let nibName = String(describing: NewsDetailController.self)
    private var viewModel: NewsDetailsViewModel!

    static func create(with viewModel: NewsDetailsViewModel) -> NewsDetailController {
        let view = NewsDetailController(nibName: nibName, bundle: nil)
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)

        setupViews()
    }

    func setupViews() {
        webView.load(viewModel.url)
        webView.allowsBackForwardNavigationGestures = true
    }
}
