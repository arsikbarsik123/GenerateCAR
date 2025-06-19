import UIKit

class CatViewModel: UIView {
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
        button.layer.cornerRadius = 10
        button.backgroundColor = .blue
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "defaultCat")
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    func setupDefaultViews() {
        addSubview(textedButton)
        addSubview(imageView)
        addSubview(activityIndicator)
    }
    
    func setupDefaultConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            imageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),

            textedButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            textedButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            textedButton.heightAnchor.constraint(equalToConstant: 30),
            textedButton.widthAnchor.constraint(equalToConstant: 200),
            
            activityIndicator.centerXAnchor.constraint(equalTo: textedButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: textedButton.centerYAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultViews()
        setupDefaultConstraints()
        
        textedButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        onTap?()
    }
    
    var onTap: (() -> Void)?
    
    func updateImage(with data: Data) {
        imageView.image = UIImage(data: data)
    }
    
    func prepareUIBeforeDownload() {
        textedButton.isEnabled = false
        textedButton.alpha = 0.5
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
}
