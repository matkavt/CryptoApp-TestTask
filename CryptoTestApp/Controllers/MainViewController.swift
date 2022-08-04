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
            // else старый таймер не выключается и работает одновременно с новым
        }
    }
    
    private var currentCost: Double? {
        didSet {
            if let currentCost = currentCost {
                currencyView.exchangeResult = currentCost
            } else {
                currencyView.exchangeResult = 0.0 // :((
            }
        }
    }
    
    private var savedDate: Date? {
        didSet {
            if let savedDate = savedDate {
                dateTimeFieldView.setText(text: Date.dateToLocalizedString(for: .ru, date: savedDate, withHours: true), color: .mainText, fontSize: 16, fontWeight: .regular)
            } else {
                dateTimeFieldView.setText(text: "Cейчас", color: .mainText, fontSize: 16, fontWeight: .regular) // Зачем локализация дней недели, если тут её нет
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
    
    
    // - MARK: Logic for getting cost of ETH
    
    private func startTimer() {
        let startTimerHash = Int.random(in: 0...100)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            // утечка памяти, нужно self сделать weak
            self.networkManager.fetchLiveETHCost {data in
                if let cost = data?.cost {
                    
                    if self.isLive {
                        self.currentCost = cost
                    }
                }
            }
            print("\(startTimerHash) timer tick") // старый таймер работает одновременно с новым
        }
    }
    
    private func getCostAndSaveToCache(by date: Date) {
        networkManager.fetchETHCost(by: date) { data in
            // утечка памяти, нужно self сделать weak
            if let cost = data?.eth.usd {
                self.currentCost = cost

                self.cacheManager.saveETHCostToCache(dateTime: date, cost: cost)
            }
        }
    }
    
    
    // - MARK: Logic for saving to cache

    private func saveToCache() {
        DispatchQueue.main.async { [self] in
            // Тут утечки как раз не должно быть
            if let dateTime = savedDate, let cost = currentCost {
                self.cacheManager.saveETHCostToCache(dateTime: dateTime, cost: cost)
            }
        }
    }
    
    private func getFromCache() {
        DispatchQueue.main.async { [self] in
            // Тут утечки как раз не должно быть
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
    
    // - MARK: UI Elements
    
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
        label.text = "Тестовое задание" // Зачем локализация дней недели, если тут её нет
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
        roundedButton.setText(text: "Выбрать дату", color: .white, fontSize: 17, fontWeight: .medium) // Зачем локализация дней недели, если тут её нет
        roundedButton.setUpGradient()
        return roundedButton
    }()
    
    private lazy var currencyView = CurrencyValueView()
    
    private lazy var liveLabel = LiveLabelView()
    
    
    // - MARK: UI Actions
    
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


// - MARK: MainViewController implements delegate to receive data from previous screen

extension MainViewController: DateTimeReceiverDelegate {
    
    // Используется 1 функция из двух и кажется, что этот протокол сюда не очень подходит
    // 1 вариант это отдельно дата и отдельно время
    // 2 вариант это дата и время внутри объекта Date
    
    func receiveDate(_ date: Date?) {
        savedDate = date
        
        if let date = date {
            networkManager.isLoading = false // зачем?
            // Ответ я так понимаю что запрос может быть в процессе и тогда не получится отправить другой, НО!
            // В таком случае этого мало, так как старый запрос не был отменён и когда если он задержится и придёт позже нового, то на экране будут неверные данные
            isLive = false
            self.timer?.invalidate()
            
            DispatchQueue.main.async { [self] in
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


