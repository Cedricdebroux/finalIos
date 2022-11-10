//
//  MoviePopular.swift
//  finalIos
//
//  Created by Cédric Debroux on 10/11/2022.
//

import UIKit
import Alamofire
import AlamofireImage

class MoviePopular: UIViewController {
    
    var canLoadMorePage: Bool = true
    
    @IBOutlet var popularMovie: UICollectionView!
    
    private var api = Api()
    
    private var movies = [Movie]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        popularMovie.dataSource = self
        popularMovie.delegate = self
        popularMovie.register(UINib(nibName: CellMovieList.identifier, bundle: nil), forCellWithReuseIdentifier: CellMovieList.identifier)
        popularMovie.setCollectionViewLayout(createLayout(), animated: true, completion: nil)
        popularMovie.refreshControl = UIRefreshControl()
        popularMovie.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    override func viewWillDisappear(_ animated: Bool) {
        movies = [Movie]()
        popularMovie.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        api = Api()
        fetchApiMovies()
    }
    func fetchApiMovies(){
        guard let url = api.urlTrending() else { return }
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
                
                self.popularMovie.insertItems(at: indexPaths)
                    self.popularMovie.refreshControl?.endRefreshing()
            case .failure(let error):
                print(error)
            }
        }
    }


   
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = Constants.spacingInsets
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
    
    // MARK: - OBJC Pull to refresh
    
    @objc func callPullToRefresh(){
        api.currentPage = 1
        movies = [Movie]()
        popularMovie.reloadData()
        self.fetchApiMovies()
    }
}
// MARK: - Extension Datasource
extension MoviePopular: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellMovieList.identifier, for: indexPath) as? CellMovieList else {
            fatalError("error !!!!!!!")
        }
        
        let data = movies[indexPath.row]
        cell.setupCell(model: data)
        return cell
    }
    
}
// MARK: - Extension Delegate
extension MoviePopular: UICollectionViewDelegate{
    
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

fileprivate enum Constants {
    static let defaultSpacing = CGFloat(5)
    static let spacingInsets = NSDirectionalEdgeInsets(top: defaultSpacing, leading: defaultSpacing, bottom: defaultSpacing, trailing: defaultSpacing)
}


