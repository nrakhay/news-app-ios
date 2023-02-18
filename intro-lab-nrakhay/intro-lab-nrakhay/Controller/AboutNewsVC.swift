//
//  AboutNewsVC.swift
//  intro-lab-nrakhay
//
//  Created by Nurali Rakhay on 04.02.2023.
//

import UIKit

final class AboutNewsVC: UIViewController {
    private var newsModel: NewsModel
    
    private var newsImageView = UIImageView()
    private var newsTitleLabel = UILabel()
    private var newsDescriptionLabel = UILabel()
    private var newsPublisherLabel = UILabel()
    private var newsPublishedDay = UILabel()
    private var horizontalStackView = UIStackView()
    
    private var openNewsButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        addSubviews()
        addSpinner()

        configureTitleLabel()
        configureImageView()
        configureDescriptionLabel()
        configureHorizontalStackView()
        configureOpenButton()
        
        fillViewsWithData()
    }
    
    init(newsModel: NewsModel) {
        self.newsModel = newsModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }
    
    private func addSubviews() {
        view.addSubview(newsTitleLabel)
        view.addSubview(newsImageView)
        view.addSubview(horizontalStackView)
        view.addSubview(newsDescriptionLabel)
        view.addSubview(openNewsButton)
        view.addSubview(spinner)
    }
    
    //MARK: - UI Data
    private func fillViewsWithData() {
        if let url = URL(string: newsModel.imageUrl) {
            setImage(from: url)
        }
        
        newsTitleLabel.text = newsModel.title
        newsDescriptionLabel.text = newsModel.description
        newsPublisherLabel.text = newsModel.publisher
        newsPublishedDay.text = newsModel.publishedDay
    }
    
    private func setImage(from url: URL) {
        if let imageFromCache =
            imageCache.object(forKey: url.absoluteString as AnyObject)
            as? UIImage {
                newsImageView.image = imageFromCache
                spinner.removeFromSuperview()
                return
        }
    }
    
    //MARK: - NewsImageView
    private func configureImageView() {
        newsImageView.layer.cornerRadius = 10
        newsImageView.clipsToBounds = true
        
        setImageViewConstraints()
    }
    
    private func setImageViewConstraints() {
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        newsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        newsImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        newsImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    //MARK: - NewsTitleLabel
    private func configureTitleLabel() {
        newsTitleLabel.numberOfLines = 0
        newsTitleLabel.font = newsTitleLabel.font.withSize(22)
        newsTitleLabel.font = UIFont.boldSystemFont(ofSize: newsTitleLabel.font.pointSize)
        newsTitleLabel.textAlignment = .justified
        
        setNewsTitleConstraints()
    }
    
    private func setNewsTitleConstraints() {
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        newsTitleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 5).isActive = true
        newsTitleLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1).isActive = true
    }
    
    //MARK: - NewsDescriptionLabel
    private func configureDescriptionLabel() {
        newsDescriptionLabel.numberOfLines = 0
        newsDescriptionLabel.font = newsDescriptionLabel.font.withSize(18)
        newsDescriptionLabel.textAlignment = .justified
        
        setNewsDescriptionConstraints()
    }

    private func setNewsDescriptionConstraints() {
        newsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        newsDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 5).isActive = true
        newsDescriptionLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1).isActive = true
    }
    
    //MARK: - HorizontalStackView
    private func configureHorizontalStackView() {
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        
        setHorizontalStackViewConstraints()
        addLabelsToStackView()
    }
    
    private func setHorizontalStackViewConstraints() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.topAnchor.constraint(equalTo: newsDescriptionLabel.bottomAnchor, constant: 5).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        horizontalStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func addLabelsToStackView() {
        horizontalStackView.addArrangedSubview(newsPublisherLabel)
        horizontalStackView.addArrangedSubview(newsPublishedDay)
    }
    
    //MARK: - OpenNewsButton
    private func configureOpenButton() {
        openNewsButton.setTitle("Read More", for: .normal)
        openNewsButton.backgroundColor = .systemBlue
        openNewsButton.layer.cornerRadius = 10
        openNewsButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        setOpenButtonConstraints()
    }
    
    @objc private func didTapButton() {
        guard let url = URL(string: newsModel.newsUrl) else {
            return
        }
        
        let webViewVC = WebViewVC(urlString: url)
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    private func setOpenButtonConstraints() {
        openNewsButton.translatesAutoresizingMaskIntoConstraints = false
        openNewsButton.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 10).isActive = true
        openNewsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        openNewsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        openNewsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        openNewsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    //MARK: - Spinner
    private let spinner = UIActivityIndicatorView()
    
    private func addSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        spinner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        spinner.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        spinner.startAnimating()
    }
}
