//
//  ArticleViewController.swift
//  Zeeguu Reader
//
//  Created by Jorrit Oosterhof on 08-12-15.
//  Copyright © 2015 Jorrit Oosterhof.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import WebKit
import Zeeguu_API_iOS

class ArticleViewController: UIViewController, WKNavigationDelegate {
	
	var article: Article?
//	private var _articleView: ArticleView
//	var articleView: ArticleView {
//		get {
//			return _articleView
//		}
//	}
	
	private var webview: ZGWebView
	
//	var translationMode: ArticleViewTranslationMode {
//		get {
//			return self._articleView.translationMode
//		}
//		set(mode) {
//			self._articleView.translationMode = mode
//		}
//	}
	
	init(article: Article? = nil) {
		self.article = article
//		self._articleView = ArticleView(article: self.article)
		self.webview = ZGWebView(article: self.article)
		super.init(nibName: nil, bundle: nil)
		self.webview.navigationDelegate = self
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.view.backgroundColor = UIColor.whiteColor()
//		let views: [String: AnyObject] = ["v": _articleView]
		let views: [String: AnyObject] = ["v": webview]
		
//		self.view.addSubview(_articleView)
		self.view.addSubview(webview)
		self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
		
//		let jsBut = UIBarButtonItem(title: "Execute JS".localized, style: .Plain, target: self, action: #selector(ArticleViewController.doJS(_:)))
//		self.navigationItem.leftBarButtonItem = jsBut
		
		let optionsBut = UIBarButtonItem(title: "OPTIONS".localized, style: .Plain, target: self, action: #selector(ArticleViewController.showOptions(_:)))
		self.navigationItem.rightBarButtonItem = optionsBut
		
//		if let str = article?.url, url = NSURL(string: "http://www.readability.com/m?url=\(str)") {
//			webview.loadRequest(NSURLRequest(URL: url))
//		}
		if let str = article?.url, url = NSURL(string: str) {
			webview.loadRequest(NSURLRequest(URL: url))
		}

		if article == nil {
			optionsBut.enabled = false;
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(animated: Bool) {
		let mc = UIMenuController.sharedMenuController()
		
		let bookmarkItem = UIMenuItem(title: "TRANSLATE".localized, action: NSSelectorFromString("translate:"))
		
		mc.menuItems = [bookmarkItem]
	}
	
	override func viewDidDisappear(animated: Bool) {
		let mc = UIMenuController.sharedMenuController()
		
		mc.menuItems = nil
	}
	
	func showOptions(sender: UIBarButtonItem) {
		let vc = ArticleViewOptionsTableViewController(parent: self)
		vc.popoverPresentationController?.barButtonItem = sender
		self.presentViewController(vc, animated: true, completion: nil)
	}
	
//	func doJS(sender: UIBarButtonItem) {
//		let jsFilePath = NSBundle.mainBundle().pathForResource("SelectionScripts", ofType: "js")
//		if let jsf = jsFilePath, jsFile = try? String(contentsOfFile: jsf) {
//			webview.evaluateJavaScript(jsFile, completionHandler: { (data, error) in
//				print("data: \(data)")
//				print("error: \(error)")
//			})
//		}
//	}
	
	func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
		let jsFilePath = NSBundle.mainBundle().pathForResource("SelectionScripts", ofType: "js")
		if let jsf = jsFilePath, jsFile = try? String(contentsOfFile: jsf) {
			webView.evaluateJavaScript(jsFile, completionHandler: { (data, error) in
				print("data: \(data)")
				print("error: \(error)")
			})
		}
	}

}

