//
//  MovieSearch.swift
//  finalIos
//
//  Created by Cédric Debroux on 10/11/2022.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieSearch: UIViewController{
    
    private var movies = [Movie]()
    let baseUrl = Api.baseImageURL
    
    @IBOutlet var search: UITextField!
    
    @IBOutlet var searchMovieCollection: UICollectionView!
    var api = Api()
    var canLoadMorePage: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        searchMovieCollection.dataSource = self
        searchMovieCollection.delegate = self
        searchMovieCollection.register(UINib(nibName: CellMovieSearch.identifier, bundle: nil), forCellWithReuseIdentifier: CellMovieSearch.identifier)
        searchMovieCollection.setCollectionViewLayout(createLayout(), animated: true)
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        api = Api()
    }
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/5))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = Constants.spacingInsets
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
    
    
    
    func fetchApiMovies(){
        movies = [Movie]()
        searchMovieCollection.reloadData()
        guard let url = api.urlSearchMovies(search: search.text!) else { return }
        api.fetch(url: url)
        {
            [weak self] response in
            switch response {
            case .success(let data):
                guard let self else {return}
                if self.api.currentPage == data.totalPages {
                    self.canLoadMorePage = false
                }
                let indexPaths =
                Array(self.movies.count..<self.movies.count + data.results.count).map { index in
                    IndexPath(row: index, section: 0)
                }
                self.movies.append(contentsOf: data.results)
                
                self.searchMovieCollection.insertItems(at: indexPaths)
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension MovieSearch: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellMovieSearch.identifier, for: indexPath) as? CellMovieSearch else {
            fatalError("error !!!!!!!")
        }
        
        let data = movies[indexPath.row]
        cell.setupCellSearch(model: data)
        return cell
        
    }
}

extension MovieSearch: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailMovie = storyboard?.instantiateViewController(withIdentifier: MovieDetails.identifier) as? MovieDetails{
            detailMovie.movie = movies[indexPath.row]
            navigationController?.pushViewController(detailMovie, animated: true)
        }
        else{
            fatalError("unubale live details")
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count-1 && canLoadMorePage {
            api.currentPage += 1
            fetchApiMovies()
        }
    }
}
extension MovieSearch: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.text = textField.text?.trim()
        if let text = textField.text, text.count >= 3 {
            fetchApiMovies()
            search.resignFirstResponder()
            return true
        }
        return false
    }
    
}

fileprivate enum Constants {
    static let defaultSpacing = CGFloat(5)
    static let spacingInsets = NSDirectionalEdgeInsets(top: defaultSpacing, leading: defaultSpacing, bottom: defaultSpacing, trailing: defaultSpacing)
}

extension UICollectionViewCell {
    class var identifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
//Accessible dans tout les view controller du projet avec self.hideKeyboardWhenTappedAround

// MARK: - hide keyboard

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension String{
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
