//
//  ViewController.swift
//  Project4
//
//  Created by Omar Makran on 3/17/24.
//  Copyright © 2024 Omar Makran. All rights reserved.
//

import UIKit
// WebKit is the framework used for web browsing capabilities. and APIs for web rendering and interaction.
import WebKit

// navigationDelegate is a Protocol. it will handle navigation events for the WKWebView.
class ViewController: UIViewController, WKNavigationDelegate {
    
    // used to display web content in the app.
    var webView: WKWebView!
    
    // used to visually represent the progress of a task.
    var progressView: UIProgressView!

    // is called when the view controller's view is requested but not yet loaded.
    override func loadView() {
        // a new instance of the WKWebView.
        webView = WKWebView()
        // assigns self (the ViewController instance) as its navigation delegate.
        webView.navigationDelegate = self
        view = webView
    }
    
    // is called after the view controller's view has been loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the Open button to selecte each site web you want.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // the button will be a flexible space item, which means it will expand to fill the available space in the toolbar.
        // nil indicates that this button doesn't have a target or action associated with it.
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        //  that the button will have a refresh system icon.
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // the default progress view style. This progress view is intended to show the progress of loading content in a web view.
        progressView = UIProgressView(progressViewStyle: .default)
        
        // ensures that the progress view is sized appropriately based on its content.
        progressView.sizeToFit()
        
        // This will allow the progress view to be displayed in the navigation bar or toolbar.
        let progressButton = UIBarButtonItem(customView: progressView)
        
        /*
         spacer and refresh buttons to the toolbarItems property of the view controller.
         This array defines the items to be displayed in the toolbar.
         */
        toolbarItems = [progressButton, spacer, refresh]
        
        // The view controller (presumably self) will be notified of changes to the estimatedProgress property. When the estimated progress changes, it can update the UI accordingly, such as updating the progress view's progress value.
        //
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    
        // This ensures that the toolbar is not hidden and will be displayed at the bottom of the screen.
        navigationController?.isToolbarHidden = false
        // creates a URL object.
        let url = URL(string: "https://www.1337.ma/")!
        // creates a new URLRequest.
        // webView.load(...): This method of WKWebView is used to load the content specified by the provided URLRequest.
        webView.load(URLRequest(url: url))
        // enables back and forward navigation gestures in the 'webView'.
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    @objc func  openTapped() {
        let ac = UIAlertController(title: "Open Page...", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // presentation controller to be displayed on iPad.
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else {
            return
        }
        guard let url = URL(string: "https://" + actionTitle) else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    // to display the Title on the Top the screen.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

}

