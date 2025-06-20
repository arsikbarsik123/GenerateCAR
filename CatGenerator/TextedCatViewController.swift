import UIKit

class TextedCatViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let catView = TextedCatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled      = true
        catView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [scrollView].forEach { sv in
            sv.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(sv)
        }
        scrollView.addSubview(contentView)
        contentView.addSubview(catView)
        
        setupCatViewConstrints()
        
        catView.onTap = { [weak self] text in
            self?.downloadCat(with: text)
            self?.catView.prepareUIBeforeDownload()
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(gestureRecognizer)
        
        keyboardWill()
    }
    
}

// MARK: - Set elements on screen

private extension TextedCatViewController {
    func downloadCat(with text: String) {
        guard let url = URL(string: "https://cataas.com/cat/says/\(text)") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.catView.updateImage(with: data)
                self?.catView.activityIndicator.stopAnimating()
                self?.catView.textField.isEnabled = true
                self?.catView.textField.alpha = 1
                self?.catView.textedButton.alpha = 1
                self?.catView.textedButton.isEnabled = true
            }
        }
        task.resume()
    }
    
}

// MARK: - Set constraints

private extension TextedCatViewController {
    func setupCatViewConstrints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            catView.topAnchor.constraint(equalTo: contentView.topAnchor),
            catView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            catView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            catView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

// MARK: - keyboard

private extension TextedCatViewController {
    func keyboardWill() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func didTapView() {
        view.endEditing(true)
    }
}
