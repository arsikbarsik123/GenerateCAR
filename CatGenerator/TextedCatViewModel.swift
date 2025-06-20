import UIKit

class TextedCatViewModel: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        
        textedButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        textField.addTarget(self, action: #selector(didChangedTextField(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    let textedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show me CAR", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.backgroundColor = .blue
        button.isEnabled = false
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let textField: UITextField = {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        let text = UITextField()
        
        text.placeholder = "Enter the message"
        text.layer.cornerRadius = 10
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.systemGray3.cgColor
        text.clipsToBounds = true
        text.font = .systemFont(ofSize: 20)
        text.leftView = padding
        text.leftViewMode = .always
        text.clearButtonMode = .whileEditing
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "defaultCat")
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    func setupViews() {
        addSubview(textedButton)
        addSubview(imageView)
        addSubview(textField)
        addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            imageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            textField.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            textField.widthAnchor.constraint(equalToConstant: 300),
            textField.heightAnchor.constraint(equalToConstant: 50),

            textedButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            textedButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            textedButton.heightAnchor.constraint(equalToConstant: 30),
            textedButton.widthAnchor.constraint(equalToConstant: 200),
            
            activityIndicator.centerXAnchor.constraint(equalTo: textedButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: textedButton.centerYAnchor),
            
            textedButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        let text = textField.text ?? ""
        onTap?(text)
    }
    
    @objc func didChangedTextField(_ sender: UITextField) {
        if textField.text?.isEmpty == true {
            textedButton.alpha = 0.5
            textedButton.isEnabled = false
        } else {
            textedButton.alpha = 1
            textedButton.isEnabled = true
        }
    }
    
    var onTap: ((String) -> Void)?
//    var onChange: ((String) -> Void)?
    
    func updateImage(with data: Data) {
        imageView.image = UIImage(data: data)
    }
    
    func prepareUIBeforeDownload() {
        textedButton.isEnabled = false
        textedButton.alpha = 0.5
        textField.isEnabled = false
        textField.alpha = 0.5
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
}
