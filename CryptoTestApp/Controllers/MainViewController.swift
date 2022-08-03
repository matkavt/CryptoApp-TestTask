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
                dateTimeFieldView.setText(text: Date.dateToLocalizedString(for: .ru, date: savedDate, withHours: true), color: .black, fontSize: 16, fontWeight: .regular)
            } else {
                dateTimeFieldView.setText(text: "Cейчас", color: .black, fontSize: 16, fontWeight: .regular)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(appTitleLabel)
        view.addSubview(dateTimeFieldView)
        view.addSubview(dateTimePickerButton)
        view.addSubview(currencyView)
        view.addSubview(liveLabel)
        setUpConstraints()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showDateTimePicker))
        dateTimePickerButton.addGestureRecognizer(tapRecognizer)
        
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
            
        ])
    }
    
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if let _ = self.savedDate {
                self.networkManager.isLoading = false
                timer.invalidate()
            }
            
            self.networkManager.fetchLiveETHCost {data in
                if let cost = data?.cost {
                    self.currentCost = cost
                }
            }
        }
    }
    
    private func getCost(by date: Date) {
        networkManager.fetchETHCost(by: date) { data in
            if let cost = data?.eth.usd {
                self.currentCost = cost
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
    
    private lazy var appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Тестовое задание"
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

        savedDate = date
        
        if let date = date {
            isLive = false
            DispatchQueue.main.async { [self] in
                getCost(by: date)
                
                if let currentCost = currentCost {
                    cacheManager.saveETHCostToCache(dateTime: date, cost: currentCost)
                }
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

