//
//  SearchController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class SearchController: HotController, UISearchBarDelegate{
    
    var searchKeyWordsVideos = [Video]()
    var searchVideos: [Video]?
    var waitLoadingVideosTimer: Timer?
    
    let noResultsId = "noResultsId"
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
        navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)        
        searchBar.endEditing(true)
    }
    
    override func setupRefreshControl() {
        collectionView?.refreshControl = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchVideos()
        activityIndicatorView.stopAnimating()
        
        collectionView?.register(noResultsCell.self, forCellWithReuseIdentifier: noResultsId)
        
        searchBar.delegate = self
        if #available(iOS 11.0, *){
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
    }
    
    override func fetchVideos() {
        waitLoadingVideosTimer?.invalidate()
        waitLoadingVideosTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(reloadHomeVideos), userInfo: nil, repeats: true)
    }
    
    @objc func reloadHomeVideos(){
        if HomeApiService.sharedInstance.isFetched{
            allVideos = HomeApiService.sharedInstance.videos
            waitLoadingVideosTimer?.invalidate()
        }
    }
    
    override func setupMenuBar(){
        
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 2.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.3
    }
    
    override func setupNavBarButtons() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backToPreviousView))
        self.navigationItem.titleView = searchBar
    }
    
    @objc func backToPreviousView(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.tintColor = .black
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "搜尋影片"
        
        return searchBar
    }()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text == nil || searchBar.text == ""{
            searchBar.endEditing(true)
        }else{
            
            if let searchKeyWord = searchBar.text {
                let searchWords = searchKeyWord.components(separatedBy: " ")
                
                allVideos = allVideos?.sorted(by: {$0.publishedAt?.compare($1.publishedAt ?? 0) == .orderedDescending})
                
                searchKeyWordsVideos = []
        
                searchWords.forEach({ (word) in
                    searchVideoForKeyWord(word)
                })
                
                searchWords.forEach({ (word) in
                    searchVideoForCharacters(searchWords: word)
                })
                
                handleSearchCompletion()
            }
        }
    }
    
    fileprivate func searchVideoForKeyWord(_ word: (String)) {
        var searchWordVideos = allVideos?.filter({$0.title?.lowercased().contains(word.lowercased()) == true || $0.channel?.name?.lowercased().contains(word.lowercased()) == true})
        checkRematchSearchVideos(searchWordVideos: searchWordVideos)
        searchWordVideos = searchWordVideos?.filter({!searchKeyWordsVideos.contains($0)})
        searchKeyWordsVideos += searchWordVideos ?? []
    }
    
    private func checkRematchSearchVideos(searchWordVideos: [Video]?){
        var rematchSearchWordVideos = searchWordVideos?.filter({searchKeyWordsVideos.contains($0)})
        rematchSearchWordVideos = rematchSearchWordVideos?.sorted(by: {$0.publishedAt?.compare($1.publishedAt ?? 0) == .orderedAscending})
        rematchSearchWordVideos?.forEach({ (video) in
            if let index = searchKeyWordsVideos.index(of: video){
                searchKeyWordsVideos.remove(at: index)
                searchKeyWordsVideos.insert(video, at: 0)
            }
        })
    }
    
    private func searchVideoForCharacters(searchWords: String){
        let partSearchVideos = searchKeyWordsVideos
        var searchAllCharacterVideos = [Video]()
        var restOfSearchVideos = allVideos?.filter({partSearchVideos.contains($0) == false})
        
        let searchCharacters = Array(searchWords.lowercased())
        searchCharacters.forEach({ (character) in

            var searchCharacterVideos: [Video]?

            if partSearchVideos.isEmpty{
                searchCharacterVideos = restOfSearchVideos?.filter({$0.title?.lowercased().contains(character) == true })
            }else{
                searchCharacterVideos = restOfSearchVideos?.filter({$0.title?.lowercased().contains(character) == true && $0.categories.contains(partSearchVideos[0].categories[1])})
            }
            searchAllCharacterVideos += searchCharacterVideos ?? []
            restOfSearchVideos = restOfSearchVideos?.filter({(searchCharacterVideos?.contains($0) == false)})
        })
        searchVideos = partSearchVideos + searchAllCharacterVideos
    }
    
    private func handleSearchCompletion(){
        collectionView?.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        searchBar.endEditing(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let searchVideos = searchVideos else { return 0 }
        if searchVideos.count > 0 {
            return searchVideos.count
        } else {
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let searchVideos = searchVideos{
            if searchVideos.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noResultsId , for: indexPath) as! noResultsCell
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId , for: indexPath) as! VideoCell
                cell.video = searchVideos[indexPath.item]
                return cell
            }
        }else{
            let cell = UICollectionViewCell()
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.endEditing(true)
        if searchVideos?.count == 0 { return }
        let video =  searchVideos?[indexPath.item]
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController
        mainTabBarController?.maximizePlayerDetails(video: video)
    }
    
}

