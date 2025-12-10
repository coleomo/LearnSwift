//
//  LoginController.swift
//  LearnSwift
//
//  Created by song on 2025/12/10.
//
import UIKit

// 拓展登录视图
extension LoginView {
    // 初始化ui样式
    func setupUI() {
        view.backgroundColor = .systemBackground
        // 添加所有子视图到跟视图
        for item in [titleLabel, phoneTextField, passwordText, actionButton, switchButton] {
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        // 绑定事件
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(switchPageState), for: .touchUpInside)
    }

    // 自动布局:使用约束布局
    func setupLayout() {
        NSLayoutConstraint.activate([
            // 标题标签：顶部间距100，水平剧中
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 手机号输入框:标题下方20，左右间距30，高度44
            phoneTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            phoneTextField.heightAnchor.constraint(equalToConstant: 44),
            // 密码输入框:手机号下方15，左右间距30，高度44
            passwordText.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            passwordText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordText.heightAnchor.constraint(equalToConstant: 44),
            // 登陆注册按钮: 密码框下方20，左右间距30，高度48
            actionButton.topAnchor.constraint(equalTo: passwordText.bottomAnchor, constant: 20),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            actionButton.heightAnchor.constraint(equalToConstant: 48),
            // 切换按钮：登陆按钮下方20，水平剧中
            switchButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 20),
            switchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // 处理键盘收起
    func setupKeyboard() {
        // 点击空白处收起键盘
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(tapGesture)
    }
}

// 事件处理，比如登陆注册点击收起键盘
extension LoginView {
    // 登陆注册按钮点击
    @objc func actionButtonTapped() {
        print("点击登陆注册按钮")
        hideKeyBoard()
    }

    // 切换当前执行登陆注册状态
    @objc func switchPageState() {
        print("切换当前执行登陆注册状态")
        hideKeyBoard()
    }

    // 收起键盘
    @objc func hideKeyBoard() {
        view.endEditing(true)
    }
}
