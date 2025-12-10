//
//  LoginView.swift
//  LearnSwift
//
//  Created by song on 2025/12/10.
//
import SwiftUI
import UIKit

// uikit原始视图
class LoginView: UIViewController {
    // 枚举状态
    enum PageState {
        case login // 登陆状态
        case register // 注册状态
    }

    // 标题标签
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "登陆"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        return label
    }()

    // 手机号输入
    let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入手机号"
        tf.keyboardType = .phonePad
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .whileEditing
        // 添加手机号格式校验
        return tf
    }()

    // 密码输入框
    let passwordText: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入密码"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .whileEditing
        return tf
    }()

    // 登陆注册按钮
    let actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("登陆", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        // 配置为false就不能触发点击事件
        btn.isEnabled = true
        // 不能在这里添加，因为这个时候self实例还没有完全初始化，闭包捕获的self可能不是预期的实例
        // btn.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return btn
    }()

    // 切换登录注册的文字按钮
    let switchButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("立即注册", for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        // btn.addTarget(self, action: #selector(switchPageState), for: .touchUpInside)
        return btn
    }()

    // 状态属性
    private var currentState: PageState = .login

    // 视图加载完成
    override func viewDidLoad() {
        super.viewDidLoad()
        // 加载ui组件
        setupUI()
        // 使用约束布局组件
        setupLayout()
        // 隐藏键盘
        setupKeyboard()
    }

    // 视图将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // 视图将要消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// 实现uiviewrepresentable
// 2. 桥接 UIKit 登录控制器到 SwiftUI
struct LoginRegisterView: UIViewControllerRepresentable {
    // MARK: - 必须实现的方法（创建 UIViewController）

    func makeUIViewController(context: Context) -> LoginView {
        let loginVC = LoginView()
        // 设置代理（通过 Coordinator 传递回调）
        return loginVC
    }

    // MARK: - 必须实现的方法（更新 UIViewController）

    func updateUIViewController(_ uiViewController: LoginView, context: Context) {
        // 无需更新，空实现即可
    }
}
