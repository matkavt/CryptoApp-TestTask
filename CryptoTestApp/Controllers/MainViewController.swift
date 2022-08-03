//
//  MainViewController.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 31.07.2022.
//

import Foundation
import UIKit

/// ViewController for the main screen

final class MainViewController: UIViewController {
    
    private var customTransitioningDelegate: UIViewControllerTransitioningDelegate?
    private let networkManager = NetworkManager()
    private let cacheManager = ETHCostCache()
    private var timer: Timer?
    
    private var isLive = true {
        didSet {
            liveLabel.isHidden = !isLive
            if isLive {
                startTimer()
            }
        }
    }
    
    private var currentCost: Double? {
        didSet {
            if let currentCost = currentCost {
                currencyView.exchangeResult = currentCost
            } else {
                currencyView.exchangeResult = 0.0
            }
        }
    }
    
    private var savedDate: Date? {
        didSet {
            if let savedDate = savedDate {
                dateTimeFieldView.setText(text: Date.dateToLocalizedString(for: .ru, date: savedDate, withHours: true), color: .mainText, fontSize: 16, fontWeight: .regular)
            } else {
                dateTimeFieldView.setText(text: "Cейчас", color: .mainText, fontSize: 16, fontWeight: .regular)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        view.addSubview(appTitleLabel)
        view.addSubview(dateTimeFieldView)
        view.addSubview(dateTimePickerButton)
        view.addSubview(currencyView)
        view.addSubview(liveLabel)
        view.addSubview(copyToClipboardView)
        
        copyToClipboardView.alpha = 0.0
        setUpConstraints()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showDateTimePicker))
        dateTimePickerButton.addGestureRecognizer(tapRecognizer)
        
        let copyToClipboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(copyToClipboard))
        dateTimeFieldView.addGestureRecognizer(copyToClipboardRecognizer)
        
        getFromCache()
    }
    
    
    private func setUpConstraints() {
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            appTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            appTitleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            appTitleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            dateTimeFieldView.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 28),
            dateTimeFieldView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            dateTimeFieldView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            dateTimePickerButton.topAnchor.constraint(equalTo: dateTimeFieldView.bottomAnchor, constant: 20),
            dateTimePickerButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            dateTimePickerButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            currencyView.topAnchor.constraint(equalTo: dateTimePickerButton.bottomAnchor, constant: 44),
            currencyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            liveLabel.topAnchor.constraint(equalTo: dateTimePickerButton.bottomAnchor, constant: 36),
            liveLabel.leadingAnchor.constraint(equalTo: currencyView.trailingAnchor, constant: 4),
            
            copyToClipboardView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
            copyToClipboardView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            copyToClipboardView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            copyToClipboardView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8)
            
        ])
    }
    
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.networkManager.fetchLiveETHCost {data in
                if let cost = data?.cost {
                    
                    if self.isLive {
                        self.currentCost = cost
                        print("updating cost")
                    }
                }
            }
        }
    }
    
    private func getCostAndSaveToCache(by date: Date) {
        networkManager.fetchETHCost(by: date) { data in
            if let cost = data?.eth.usd {
                self.currentCost = cost
                print("got historical")
                
                print("saving for \(cost)")
                self.cacheManager.saveETHCostToCache(dateTime: date, cost: cost)
            }
        }
    }
    
    private func saveToCache() {
        DispatchQueue.main.async { [self] in
            if let dateTime = savedDate, let cost = currentCost {
                self.cacheManager.saveETHCostToCache(dateTime: dateTime, cost: cost)
            }
        }
    }
    
    private func getFromCache() {
        DispatchQueue.main.async { [self] in
            let data = cacheManager.getETHCostFromCache()
            
            if let savedDate = data?.0, let currentCost = data?.1 {
                self.isLive = false
                self.savedDate = savedDate
                self.currentCost = currentCost
            } else {
                self.isLive = true
                self.savedDate = nil
            }
        }
    }
    
    private var copyToClipboardView: CopyToClipboardView = {
        let view = CopyToClipboardView()
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    
    private lazy var appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Тестовое задание"
        label.textColor = .mainText
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        return label
        
    }()
    
    private lazy var dateTimeFieldView: RoundedLabelView = {
        let roundedLabel = RoundedLabelView()
        return roundedLabel
    }()
    
    private lazy var dateTimePickerButton: RoundedButton = {
        let roundedButton = RoundedButton(frame: .zero)
        roundedButton.setText(text: "Выбрать дату", color: .white, fontSize: 17, fontWeight: .medium)
        roundedButton.setUpGradient()
        return roundedButton
    }()
    
    private lazy var currencyView = CurrencyValueView()
    
    private lazy var liveLabel = LiveLabelView()
    
    @objc private func showDateTimePicker() {
        customTransitioningDelegate = CustomSheetTransitionDelegate(presentationControllerFactory: self)
        let vc = DateTimePickerViewController()
        vc.receiverDelegate = self
        vc.dateChosen = savedDate
        vc.timeChosen = savedDate
        let destinationVC = CustomSheetNavigationController(rootViewController: vc)
        destinationVC.modalPresentationStyle = .custom
        destinationVC.transitioningDelegate = customTransitioningDelegate
        present(destinationVC, animated: true)
    }
    
    @objc private func copyToClipboard(gesture: UITapGestureRecognizer) {
        
        copyToClipboardView.layer.shadowColor = UIColor.mainText.cgColor

        UIPasteboard.general.string = dateTimeFieldView.getText()
        
        UIView.animate(withDuration: 0.2, animations: { [self] in copyToClipboardView.alpha = 1.0 }) { (finished) in
            UIView.animate(withDuration: 0.15, delay: 2, animations: { self.copyToClipboardView.alpha = 0.0 })
        }
    }
}


extension MainViewController: CustomSheetPresentationControllerFactory {
    func makeCustomSheetPresentationController(presentedViewController: UIViewController, presentingViewController: UIViewController?) -> CustomSheetPresentationController {
        .init(presentedViewController: presentedViewController, presentingViewController: presentingViewController, dismissalHandler: self)
    }
    
}

extension MainViewController: CustomSheetDismissalController {
    func performDismissal(animated: Bool) {
        presentedViewController?.dismiss(animated: animated)
    }
    
}

extension MainViewController: DateTimeReceiverDelegate {
    func receiveDate(_ date: Date?) {
        print("received date")
        savedDate = date
        
        if let date = date {
            networkManager.isLoading = false
            isLive = false
            self.timer?.invalidate()
            
            DispatchQueue.main.async { [self] in
                print("get historical")
                getCostAndSaveToCache(by: date)
            }
            
        } else {
            isLive = true
            cacheManager.removeETHCostFromCache()
        }
    }
    
    func receiveTime(_ time: Date?) {
        return
    }
    
    
}

