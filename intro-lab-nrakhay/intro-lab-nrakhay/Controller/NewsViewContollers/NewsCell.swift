//
//  VideoCell.swift
//  intro-lab-nrakhay
//
//  Created by Nurali Rakhay on 04.02.2023.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

final class NewsCell: UITableViewCell {
    private var newsImageView =  UIImageView()
    private var newsTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(newsImageView)
        addSubview(newsTitleLabel)
        
        
        configureImageView()
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func set(news: NewsModel) {
        if let url = URL(string: news.imageUrl) {
            setImage(from: url)
        }
        
        newsTitleLabel.text = news.title
    }
    
    private var task: URLSessionDataTask!
    
    private func setImage(from url: URL) {
        newsImageView.image = nil
        
        addSpinner()
        
        if let task = task {
            task.cancel() // if task isn't nil, then stop it and start new task
        }
        
        if let imageFromCache =
            imageCache.object(forKey: url.absoluteString as AnyObject)
            as? UIImage {
                newsImageView.image = imageFromCache
                spinner.removeFromSuperview()
                return
        }
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let newImage = UIImage(data: data)
            else {
                print("Couldn't load image from URL: \(url)")
                return
            }
            
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
        
            DispatchQueue.main.async {
                self.newsImageView.image = newImage
                self.spinner.removeFromSuperview()
            }
        }
        
        task.resume()
    }
    
    
    //MARK: - Spinner Configuration
    private let spinner = UIActivityIndicatorView()
    
    private func addSpinner() {
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 80).isActive = true
        spinner.widthAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 16/9).isActive = true
        
        spinner.startAnimating()
    }
    
    //MARK: - Configurations
    private func configureImageView() {
        newsImageView.layer.cornerRadius = 10
        newsImageView.clipsToBounds = true
        
        setImageConstraints()
    }

    private func configureTitleLabel() {
        newsTitleLabel.numberOfLines = 0
        newsTitleLabel.adjustsFontSizeToFitWidth = true
        
        setTitleConstraints()
    }
    
    private func setImageConstraints() {
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        newsImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        newsImageView.widthAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 16/9).isActive = true
    }

    private func setTitleConstraints() {
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 20).isActive = true
        newsTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        newsTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
}
