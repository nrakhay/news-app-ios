//
//  WebViewVC.swift
//  intro-lab-nrakhay
//
//  Created by Nurali Rakhay on 05.02.2023.
//

import UIKit
import WebKit

final class WebViewVC: UIViewController, WKNavigationDelegate {
    private var webView = WKWebView()
    private var linkToShow: URL
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(URLRequest(url: linkToShow))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    init(urlString: URL) {
        linkToShow = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
}
