import UIKit

final class CalculatorViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = CalculatorViewModel()
    
    private let buttonTitles: [[String]] = [
        ["C", "⌫", "/", "x"],
        ["7", "8", "9", "-"],
        ["4", "5", "6", "+"],
        ["1", "2", "3", "="],
        ["0", ".", "±"]
    ]
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.text = "0"
        label.backgroundColor = .darkGray
        label.textColor = .white
        label.layer.cornerRadius = 30
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        setupResultLabel()
        setupButtons()
    }
    
    private func setupResultLabel() {
        view.addSubview(resultLabel)
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupButtons() {
        view.addSubview(stackView)
        
        for rowTitles in buttonTitles {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal// yan yana
            rowStackView.spacing = 5
            rowStackView.distribution = .fillEqually
            
            for title in rowTitles {
                rowStackView.addArrangedSubview(createButton(with: title))
            }
            
            stackView.addArrangedSubview(rowStackView)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func createButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.backgroundColor = getColor(for: title)
        button.layer.cornerRadius = 40
        button.clipsToBounds = true
        
        // Butonun boyutunu Auto Layout yerine Intrinsic Content Size ile belirlemek
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }
    
    private func getColor(for title: String) -> UIColor {
        switch title {
        case "=": return .systemGreen
        case "+", "-", "x", "/", "C", "⌫": return .systemOrange
        default: return .darkGray
        }
    }
    
    // MARK: - Actions
    @objc private func buttonPressed(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        viewModel.handleInput(title)
        resultLabel.text = viewModel.displayText
    }
}
