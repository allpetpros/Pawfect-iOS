import UIKit

protocol TabBarDelegate: AnyObject {
    func select(tab at: Int)
}

class TabBar: UIView {
    private var titles: [String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    var textColor: UIColor = .black
    var selectorViewColor: UIColor = #colorLiteral(red: 0.7764705882, green: 0.1333333333, blue: 0.1843137255, alpha: 1)
    var selectorTextColor: UIColor = #colorLiteral(red: 0.7764705882, green: 0.1333333333, blue: 0.1843137255, alpha: 1)
    weak var delegate: TabBarDelegate?
    convenience init(frame: CGRect, buttonTitles: [String]) {
        self.init(frame: frame)
        self.titles = buttonTitles
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    func setButtonTitles(titles: [String]) {
        self.titles = titles
        updateView()
    }
    private func configureTabBar () {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints(of: stack)
    }
    private func setupConstraints (of stack: UIStackView) {
        stack.arrangedSubviews[0].widthAnchor.constraint(equalToConstant:
            self.frame.width / CGFloat(titles.count))
            .isActive = true
        stack.topAnchor.constraint(equalTo: self.topAnchor)
            .isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            .isActive = true
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            .isActive = true
        stack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            .isActive = true
    }
    private func configureSelectorView () {
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height - 10, width: 10, height: 10))
        selectorView.cornerRadius = 5
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }
    private func createButton () {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for title in titles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            button.contentHorizontalAlignment = .left
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorViewColor, for: .normal)
    }
    @objc func buttonAction(sender: UIButton) {
        for (index, button) in buttons.enumerated() {
                button.setTitleColor(textColor, for: .normal)
            if button == sender {
                let selectorPosition = frame.width / CGFloat(titles.count) * CGFloat(index)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                button.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
    private func updateView () {
        createButton()
        configureSelectorView()
        configureTabBar()
    }
}
