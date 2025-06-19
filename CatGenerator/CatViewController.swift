import UIKit

class CatViewController: UIViewController {
    var imageContent: Data?
    let catView = CatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(catView)
        catView.translatesAutoresizingMaskIntoConstraints = false
        setupCatViewConstrints()
        
        catView.onTap = { [weak self] in
            self?.downloadCat()
            self?.catView.prepareUIBeforeDownload()
        }
    }
    
}

// MARK: - Set elements on screen

private extension CatViewController {
    func downloadCat() {
        guard let url = URL(string: "https://cataas.com/cat") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.catView.updateImage(with: data)
                self?.catView.activityIndicator.stopAnimating()
                self?.catView.textedButton.alpha = 1
                self?.catView.textedButton.isEnabled = true
            }
        }
        task.resume()
    }
    
}

// MARK: - Set constraints

private extension CatViewController {
    func setupCatViewConstrints() {
        NSLayoutConstraint.activate([
            catView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            catView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            catView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            catView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

