//
//  WebViewController.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/02/27.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift
import RxWebKit

class WebViewController: UIViewController {
    
    var loadUrl: String?
    weak var operationPageViewController: OperationPageViewController?

    @IBOutlet weak var webView: WebView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var timerButton: UIBarButtonItem!
    
    private let disposeBag = DisposeBag()
    private var timer: Timer?
    private let viewModel = WebViewViewModel()
    private var index: Int {
        navigationController?.view.tag ?? 0
    }
    
    static func initWebViewController(tag: Int,
                                      url: String?,
                                      operationPageViewController: OperationPageViewController?) -> UINavigationController? {
        guard let nc = R.storyboard.main.navigationController(),
            let vc = nc.topViewController as? WebViewController else { return nil }
        nc.view.tag = tag
        vc.operationPageViewController = operationPageViewController
        vc.loadUrl = url
        return nc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupProgressView()
        setupBackButton()
        setupForwardButton()
        setupReload()
        becomeActive()
        bindFavorite()
        initDeleteButton()
        initTimerButton()
    }
    
    @IBAction func tapClose(_ sender: Any) {
        operationPageViewController?.closePage(index: index)
    }

    @IBAction func tapFavorite(_ sender: Any) {
        if viewModel.isFavorite {
            viewModel.deleteFavorite(url: webView.url)
        }
        else {
            takeScreenShot()
        }
    }
    
    @IBAction func tapFavoriteList(_ sender: Any) {
        guard let vc = FavoriteListViewController.initFavoriteListViewController(
            operationPageViewController: operationPageViewController) else { return }
        vc.presentationController?.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapTimer(_ sender: Any) {
        
        guard let vc = R.storyboard.main.timerViewController() else { return }
        present(vc, animated: true, completion: nil)
    }
    
    func goBack() {
        webView.goBack()
    }
    
    func goForword() {
        webView.goForward()
    }
    
    private func setupWebView() {
        webView.set(operationPageViewController: operationPageViewController)
        loadWebView()
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    
    private func loadWebView() {
        guard let url = URL(string: loadUrl ?? "https://www.google.com/") else { return }
        webView.load(URLRequest(url: url))
    }
    
    private func takeScreenShot() {
        webView.takeSnapshot(with: nil, completionHandler: { [weak self] (image, error) in
            self?.viewModel.savePicture(image: image, url: self?.webView.url?.absoluteString, title: self?.webView.title)
        })
    }
    
    private func takeThumbnail() {
        webView.takeSnapshot(with: nil, completionHandler: { [weak self] (image, error) in
            self?.updateThumbnail(image: image)
        })
    }
    
    private func updateThumbnail(image: UIImage?) {
        operationPageViewController?.update(image: image, title: webView.title, index: index)
    }
    
    private func setupProgressView() {
        webView.rx.estimatedProgress.asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] value in
                self?.progressView.progress = Float(value)
            }).disposed(by: disposeBag)
        
        webView.rx.loading.asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isLoading in
                self?.progressView.isHidden = !isLoading
                self?.initFavoriteButton()
                if !isLoading {
                    self?.takeThumbnail()
                }
            }).disposed(by: disposeBag)
    }
    
    private func setupBackButton() {
        leftButton.image = R.image.left()?.withRenderingMode(.alwaysOriginal)
        webView.rx.canGoBack.asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] canGoBack in
                self?.setupButton(self?.leftButton, image: R.image.left(), isEnabled: canGoBack)
            }).disposed(by: disposeBag)
        
        leftButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.webView.goBack()
            }).disposed(by: disposeBag)
    }
    
    private func setupForwardButton() {
        
        webView.rx.canGoForward.asDriver(onErrorJustReturn: false)
        .drive(onNext: { [weak self] canGoForward in
            self?.setupButton(self?.rightButton, image: R.image.right(), isEnabled: canGoForward)
        }).disposed(by: disposeBag)
        
        rightButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.webView.goForward()
            }).disposed(by: disposeBag)
    }
    
    private func setupButton(_ button: UIBarButtonItem?, image: UIImage?, isEnabled: Bool) {
        if isEnabled {
            button?.image = image?.withRenderingMode(.alwaysOriginal)
        } else {
            button?.image = image
        }
        button?.isEnabled = isEnabled
    }
    
    private func setupReload() {
        reloadButton.image = R.image.reload()?.withRenderingMode(.alwaysOriginal)
        reloadButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.webView.reload()
            }).disposed(by: disposeBag)
    }
    
    private func setupTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: false, block: { [weak self] _ in
            UIApplication.shared.isIdleTimerDisabled = false
            self?.timer?.invalidate()
        })
    }
    
    private func becomeActive() {
        NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification).subscribe(onNext: {[weak self] _ in
            self?.setupTimer()
            }).disposed(by: disposeBag)
    }
    
    private func bindFavorite() {
        viewModel.isFavoriteObserver.subscribe(onNext: { [weak self] isFavorite in
            self?.setFavoriteImage(isFavorite: isFavorite)
            }).disposed(by: disposeBag)
    }
    
    private func initFavoriteButton() {
        viewModel.checkFavorite(url: webView.url)
    }
    
    private func setFavoriteImage(isFavorite: Bool) {
        if isFavorite {
            favoriteButton.image = R.image.heart()?.withRenderingMode(.alwaysOriginal)
        } else {
            favoriteButton.image = R.image.heart()
            favoriteButton.tintColor = .gray
        }
    }
    
    private func initDeleteButton() {
        deleteButton.image = R.image.cross()?.withRenderingMode(.alwaysOriginal)
    }
    
    private func initTimerButton() {
        timerButton.image = R.image.hourglass()?.withRenderingMode(.alwaysOriginal)
    }
}

extension WebViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
        setupTimer()
        viewModel.checkFavorite(url: webView.url)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        // iFrame対応
        guard let requestUrl = navigationAction.request.url,
              navigationAction.request.mainDocumentURL?.absoluteString == requestUrl.absoluteString else {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.allow)
    }
    
    private func substringKeyword(text: String) -> String? {
        let pattern = "(?<=https\\:\\/\\/www\\.google\\.com\\/search\\?q\\=)(.*)(?=\\&source)"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }

        guard let matched = regex.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) else {
            return nil
        }

        return (text as NSString).substring(with: matched.range(at: 0))
    }
}

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame?.isMainFrame != true {
            webView.load(navigationAction.request)
        }

        return nil
    }
}
