//
//  NewsListVC.swift
//  intro-lab-nrakhay
//
//  Created by Nurali Rakhay on 04.02.2023.
//

import UIKit

final class NewsListVC: UIViewController {
    private enum Constants {
        static let newsCell = "NewsCell"
        static let tinkoff = "Tinkoff"
        static let search = "Search"
    }
    
    private var safeArea: UILayoutGuide!
    private var tableView = UITableView()
    private var searchTextField = UITextField()
    private var searchButton = UIButton()
    private var searchStackView = UIStackView()
    private var news = [NewsModel]()
    private var newsManager = NewsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        safeArea = view.layoutMarginsGuide
        
        view.addSubview(searchStackView)
        view.addSubview(tableView)
        
        configureSearchStackView()
        configureTableView()
        
        setDefaultNews()
        
        newsManager.delegate = self
        searchTextField.delegate = self
        
        newsManager.fetchNews(about: Constants.tinkoff)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        setTableViewConstraints()
        
        tableView.rowHeight = 100
        tableView.register(NewsCell.self, forCellReuseIdentifier: Constants.newsCell)
        
        
        tableView.tableHeaderView = nil
    }
    
    private func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setDefaultNews() {
        let newsFromDefaults = DataManager.getSavedNews()
        if newsFromDefaults.isEmpty {
            return
        }

        news = DataManager.getSavedNews()
    }
    
    //MARK: - HorizontalStackView
    private func configureSearchStackView() {
        searchStackView.axis = .horizontal
        searchStackView.distribution = .fill
        searchStackView.spacing = 8
        setSearchStackViewConstraints()
        
        configureTextField()
        configureSearchButton()

        addElementsToStackView()
    }
    
    private func setSearchStackViewConstraints() {
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5).isActive = true
        searchStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        searchStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        searchStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func addElementsToStackView() {
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchButton)
    }

    //MARK: - TextField
    private func configureTextField() {
        searchTextField.placeholder = Constants.search
        searchTextField.borderStyle = .roundedRect
    }
    
    //MARK: - SearchButton
    private func configureSearchButton() {
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        searchButton.imageView?.clipsToBounds = true
    }
    
    @objc private func didTapSearchButton() {
        searchTextField.endEditing(true)
    }
}

//MARK: - UITextField
extension NewsListVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter the keyword!"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let keyword = searchTextField.text {
            newsManager.fetchNews(about: keyword)
        }
        
        searchTextField.text = ""
    }
}

//MARK: - UITableView
extension NewsListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        
        let singleNews = self.news[indexPath.row]
        cell.set(news: singleNews)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clickedNews = news[indexPath.row]
        let vc = AboutNewsVC(newsModel: clickedNews)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - NewsManagerDelegate
extension NewsListVC: NewsManagerDelegate {
    func didUpdateNews(_ newsManager: NewsManager, _ news: [NewsModel]) {
        self.news = news
        
        DataManager.saveNewsData(newsModel: news)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
