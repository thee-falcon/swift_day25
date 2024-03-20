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
    
    var webSites = ["www.apple.com", "www.hackingwithswift.com", "1337.ma"]

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
        // back button.
        let backItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        // forward button.
        let forwardItem = UIBarButtonItem(title: "Forward", style: .plain, target: self, action: #selector(goForward))
        
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
        toolbarItems = [backItem,progressButton, spacer, refresh, forwardItem]
        
        // The view controller (presumably self) will be notified of changes to the estimatedProgress property. When the estimated progress changes, it can update the UI accordingly, such as updating the progress view's progress value.
        //
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    
        // This ensures that the toolbar is not hidden and will be displayed at the bottom of the screen.
        navigationController?.isToolbarHidden = false
        
        // creates a URL object.
        let url = URL(string: "https://" + webSites[0])!
        // creates a new URLRequest.
        // webView.load(...): This method of WKWebView is used to load the content specified by the provided URLRequest.
        webView.load(URLRequest(url: url))
        // enables back and forward navigation gestures in the 'webView'.
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    @objc func  openTapped() {
        let ac = UIAlertController(title: "Open Page...", message: nil, preferredStyle: .actionSheet)
        
        for webSite in webSites {
            ac.addAction(UIAlertAction(title: webSite, style: .default, handler: openPage))
        }

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
    
    // "estimatedProgress" It is a floating-point value ranging from 0.0 to 1.0, where 0.0 indicates that no content has been loaded and 1.0 indicates that all content has been loaded.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // ########################################################################################################################################################### //
    // this function is responsible for inspecting navigation actions in the web view and allowing or canceling them based on a predefined list of safe websites.  //
    // is part of the WKNavigationDelegate protocol, which is used to handle various events related to web navigation in a WKWebView instance.                     //
    // decisionHandler: a closure to allow or cancel the navigation action.                                                                                        //
    // that method inspect the URL being navigated to and decide whether it's safe to proceed.                                                                     //
    // @escaping keyword in Swift is used to indicate that a closure parameter can outlive the scope of the function it's passed into.                             //
    // ########################################################################################################################################################### //
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Retrieves the URL associated with the navigation action.
        guard let url = navigationAction.request.url, let host = url.host else {
            // If the URL or its host is nil, allow the navigation.
            decisionHandler(.allow)
            return
        }

        // Print the host for debugging purposes.
        print("Host: \(host)")

        // Check if the host is allowed.
        let allowedHosts = ["www.apple.com", "www.hackingwithswift.com"]
        if allowedHosts.contains(host) {
            // If the host is allowed, allow the navigation.
            decisionHandler(.allow)
        } else {
            // If the host is not allowed, present an alert and cancel the navigation.
            let alertController = UIAlertController(title: "Blocked", message: "This website is not allowed.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            decisionHandler(.cancel)
        }
    }
    // Back Button.
    @objc func goBack() {
        webView.goBack()
    }
    
    // Fowrward Button.
    @objc func  goForward() {
        webView.goForward()
    }
}

