//
//  ViewController.swift
//  NewsAPI
//
//  Created by Mina Emad on 29/04/2024.
//

import UIKit
import SDWebImage
import CoreData
import Reachability


class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    let reachability = try! Reachability()
    
    var indicator : UIActivityIndicatorView?
    
    var newsList: [New] = []
    var newsListOnline: [New] = []
    var newsListOffline: [New] = []
    
    var appDelegate : AppDelegate?
    var managedObjContext: NSManagedObjectContext?
    
    let coreData = CoreDataAccessObject()
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator()
        checkInternetConnection()
        getDataFromAPI{[weak self] news in
            DispatchQueue.main.async {
                self?.indicator?.stopAnimating()
                self?.newsList=news
                self?.coreData.deleteAllNewsFromNews()
                self?.coreData.insertToNews(newsList: self!.newsList)
                self?.homeCollectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjContext = appDelegate?.persistentContainer.viewContext
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3.5, height: view.frame.height/4)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as? HomeCollectionViewCell else {
            fatalError("Failed to dequeue NewsCell")
        }
        
        cell.homeImage.layer.cornerRadius = 17
        cell.homeImage.layer.shadowColor = UIColor.black.cgColor
        cell.homeImage.layer.shadowOpacity = 0.5
        cell.homeImage.layer.shadowOffset = CGSize(width: 4, height: 4)
        cell.homeImage.layer.shadowRadius = 5.0
        cell.homeImage.layer.masksToBounds = true

        if let imageUrl = newsList[indexPath.row].imageUrl, let url = URL(string: imageUrl) {
              let transformer = SDImageResizingTransformer(size: CGSize(width: 100, height: 100), scaleMode: .aspectFill)
              cell.homeImage.sd_setImage(with: url, placeholderImage: UIImage(named: "man"), context: [.imageTransformer: transformer])
          } else {
              cell.homeImage.image = UIImage(named: "man")
          }

        cell.homeTitle.text = newsList[indexPath.row].author

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DetailsViewController.isFav = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsController = storyboard.instantiateViewController(withIdentifier: "HomeDetailVC") as? DetailsViewController{
            detailsController.new = newsList[indexPath.row]
            present(detailsController, animated: true, completion: nil)
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Warnning!", message: "Please check your internet connection.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func loadingIndicator(){
        indicator=UIActivityIndicatorView(style: .medium)
        guard let indicator = indicator else{
            return
        }
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    func checkInternetConnection(){
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            self.showAlert()
            self.newsListOffline = self.coreData.getAllNewsFromNews(homeTableView: self.homeCollectionView, indicator: self.indicator)
            self.newsList = self.newsListOffline
            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
}
