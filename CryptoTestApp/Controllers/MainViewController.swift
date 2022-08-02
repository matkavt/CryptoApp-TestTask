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
    
    private var isLive = false
    private var currentCost: Double = 0.0 {
        didSet {
            currencyView.excangeResult = currentCost
        }
    }
    
    private var savedDate: Date? = Date() {
        didSet {
            if let savedDate = savedDate {
                isLive = false
                liveLabel.isHidden = true
                getCost(by: savedDate)
            } else {
                isLive = true
                liveLabel.isHidden = false
                startTimer()
            }
        }
    }
    
    private var customTransitioningDelegate: UIViewControllerTransitioningDelegate?
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(appTitleLabel)
        view.addSubview(dateTimeFieldView)
        view.addSubview(dateTimePickerButton)
        view.addSubview(currencyView)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showDateTimePicker))
        dateTimePickerButton.addGestureRecognizer(tapRecognizer)
        
        setUpConstraints()
        view.addSubview(liveLabel)
        setUpLiveLabel()
        
        if isLive {
            startTimer()
        } else {
            getCost(by: savedDate!)
            liveLabel.isHidden = true
        }
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
            currencyView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
    
    private func setUpLiveLabel() {
        liveLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
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
    
    private lazy var appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Тестовое задание"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        return label
        
    }()
    
    private lazy var dateTimeFieldView: RoundedLabelView = {
        let roundedLabel = RoundedLabelView()
        roundedLabel.setText(text: "Cейчас", color: .black, fontSize: 16, fontWeight: .regular)
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
        let destinationVC = CustomSheetNavigationController(rootViewController: DateTimePickerViewController())
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

