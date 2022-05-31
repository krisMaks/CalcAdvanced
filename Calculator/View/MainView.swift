//
//  MainView.swift
//  CalcAdvanced
//
//  Created by Кристина Максимова on 31.05.2022.
//

import UIKit

class MainView: UIView {
    //Создание необходимых UI-элементов, констант и переменных
    let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Menlo", size: 35)
        label.textColor = .white
        label.textAlignment = .right
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let historyButton: UIButton = {
        let button = UIButton(type: .system)
        button.addStyleHistoryButton()
//        button.addTarget(self, action: #selector(getHistory), for: .touchUpInside)
        return button
    }()
    private let resultView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let firstLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setConfig(axis: .horizontal)
        return stackView
    }()
    
    private let secondLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setConfig(axis: .horizontal)
        return stackView
    }()
    
    private let thirdLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setConfig(axis: .horizontal)
        return stackView
    }()
    
    private let fourthLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setConfig(axis: .horizontal)
        return stackView
    }()
    
    private let fifthLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setConfig(axis: .horizontal)
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setConfig(axis: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var sharedConstraints: [NSLayoutConstraint] = []
    
    let namesSharedButton: [[String]] = [["AC", "x²", "x³", "xª", "÷"], ["MC", "7", "8", "9", "×"], ["M＋", "4", "5", "6", "-"], ["M౼", "1", "2", "3", "+"], ["MR", "±", "0", ".", "="]]
    let namesCompactButton: [[String]] = [["π", "AC", "x²", "x³", "xª", "÷"], ["e", "MC", "7", "8", "9", "×"], ["sin", "M＋", "4", "5", "6", "-"], ["cos", "M౼", "1", "2", "3", "+"], ["tan", "MR", "±", "0", ".", "="]]
    let namesRegularButton: [[String]] = [["(", "π", "AC", "x²", "x³", "xª", "÷"], [")", "e", "MC", "7", "8", "9", "×"], ["√", "sin", "M＋", "4", "5", "6", "-"], ["∛", "cos", "M౼", "1", "2", "3", "+"], ["%", "tan", "MR", "±", "0", ".", "="]]
    private var buttons = [[UIButton]]()
    
    //Добавление subview на view
    func setupView() {
        verticalStackView.addArrangedSubview(firstLineStackView)
        verticalStackView.addArrangedSubview(secondLineStackView)
        verticalStackView.addArrangedSubview(thirdLineStackView)
        verticalStackView.addArrangedSubview(fourthLineStackView)
        verticalStackView.addArrangedSubview(fifthLineStackView)
        resultView.addSubview(historyButton)
        resultView.addSubview(resultLabel)
        self.addSubview(resultView)
        self.addSubview(verticalStackView)
    }
    //Установка констрейнтов для элементов
    func setConstraints() {
        sharedConstraints = resultView.addConstraints(top: self.safeAreaLayoutGuide.topAnchor,
                                                      leading: self.safeAreaLayoutGuide.leadingAnchor,
                                                      trailing: self.safeAreaLayoutGuide.trailingAnchor,
                                                      height: self.heightAnchor,
                                                      multiplier: 0.2)
        sharedConstraints += historyButton.addConstraints(top: resultView.topAnchor,
                                                          trailing: resultView.trailingAnchor,
                                                          trailingConstant: -10,
                                                          height: 25,
                                                          width: 100)
        sharedConstraints += resultLabel.addConstraints(bottom: resultView.bottomAnchor,
                                                        trailing: resultView.trailingAnchor,
                                                        leading: resultView.leadingAnchor,
                                                        trailingConstant: -10,
                                                        leadingConstant: 10,
                                                        height: 40)
        sharedConstraints += verticalStackView.addConstraints(top: resultView.bottomAnchor,
                                                              bottom: self.safeAreaLayoutGuide.bottomAnchor,
                                                              leading: self.safeAreaLayoutGuide.leadingAnchor,
                                                              trailing: self.safeAreaLayoutGuide.trailingAnchor)
    }
    
    private func setButtons(with namesButton: [[String]]) {
        var newButtons = [UIButton]()
        for namesLine in namesButton {
            for name in namesLine {
                let button = UIButton(type: .system)
                button.addStyleMainButton()
                button.setTitle(name, for: .normal)
                newButtons.append(button)
                if !name.containsOtherThan(.nums) {
                    button.backgroundColor = UIColor(named: "grayButton")
                } else if !name.containsOtherThan(.mainOperations) {
                    button.backgroundColor = UIColor(named: "orangeButton")
                } else {
                    button.backgroundColor = UIColor(named: "darkGrayButton")
                }
//                if !name.containsOtherThan(.nums) {
//                    button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
//                }
//                if !name.containsOtherThan(.binaryOperations) {
//                    button.addTarget(self, action: #selector(binaryOperatorPressed), for: .touchUpInside)
//                }
//                if !name.containsOtherThan(.equal) {
//                    button.addTarget(self, action: #selector(equalPressed), for: .touchUpInside)
//                }
//                if !name.containsOtherThan(.dot) {
//                    button.addTarget(self, action: #selector(dotOperatorPressed), for: .touchUpInside)
//                }
//                if !name.containsOtherThan(.unaryOperations) {
//                    button.addTarget(self, action: #selector(unaryOperatorPressed), for: .touchUpInside)
//                }
//                if !name.containsOtherThan(.other) {
//                    button.addTarget(self, action: #selector(otherOperatorPressed), for: .touchUpInside)
//                }
//                if !name.containsOtherThan(.percent) {
//                    button.addTarget(self, action: #selector(persentOperatorPressed), for: .touchUpInside)
//                }
//                if !name.containsOtherThan(.memory) {
//                    button.addTarget(self, action: #selector(memoryOperatorPressed), for: .touchUpInside)
//                }
//                if !name.containsOtherThan(.bracket) {
//                    button.addTarget(self, action: #selector(bracketPressed), for: .touchUpInside)
//                }
            }
            buttons.append(newButtons)
            newButtons.removeAll()
        }
    }
    
    func setView(with namesButtons: [[String]]) {
        let stacks = [firstLineStackView, secondLineStackView, thirdLineStackView, fourthLineStackView, fifthLineStackView]
        removeViewInStack()
        setButtons(with: namesButtons)
        for (index, buttonsLine) in buttons.enumerated() {
            for button in buttonsLine {
                stacks[index].addArrangedSubview(button)
            }
        }
    }
    //Вспомогательный метод для очистки subview в stackView
    private func removeViewInStack() {
        let stacks = [firstLineStackView, secondLineStackView, thirdLineStackView, fourthLineStackView, fifthLineStackView]
        for stack in stacks {
            for view in stack.arrangedSubviews {
                stack.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
        buttons.removeAll()
    }
}
