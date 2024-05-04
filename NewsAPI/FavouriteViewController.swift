//
//  FavouriteViewController.swift
//  NewsAPI
//
//  Created by Mina Emad on 29/04/2024.
//

import UIKit
import CoreData
import SDWebImage

class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    @IBOutlet weak var noFavImage: UIImageView!
    
    @IBOutlet weak var favTableView: UITableView!
    
    var coreData = CoreDataAccessObject()

    var newsList: [New] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favTableView.delegate = self
        favTableView.dataSource = self
        newsList=coreData.getAllNewsFromFavourite(favTableView: favTableView)
        isFavViewEmpty()
        favTableView.reloadData()
        print("will appear")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favTableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)
        
        cell.textLabel?.text = newsList[indexPath.row].title
        
        cell.imageView?.layer.cornerRadius = 30
        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
        cell.imageView?.layer.shadowOpacity = 0.5
        cell.imageView?.layer.shadowOffset = CGSize(width: 4, height: 4)
        cell.imageView?.layer.shadowRadius = 5.0
        cell.imageView?.layer.masksToBounds = true
        
        if let imageUrl = newsList[indexPath.row].imageUrl, let url = URL(string: imageUrl) {
              let transformer = SDImageResizingTransformer(size: CGSize(width: 100, height: 100), scaleMode: .aspectFill)
              cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "man"), context: [.imageTransformer: transformer])
          } else {
              cell.imageView?.image = UIImage(named: "man")
          }

        return cell
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        showAlert(title: "Are You Sure?", message: "Do you want delete this New?", indexPath: indexPath)
        coreData.deleteFromFavourite(new: newsList[indexPath.row])
        favTableView.reloadData()
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DetailsViewController.isFav = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsController = storyboard.instantiateViewController(withIdentifier: "HomeDetailVC") as? DetailsViewController{
            detailsController.new = newsList[indexPath.row]
            present(detailsController, animated: true, completion: nil)
        }
    }
    
    func isFavViewEmpty(){
        if !newsList.isEmpty {
            noFavImage.isHidden = true
        }else{
            noFavImage.isHidden = false
        }
    }
    
    func showAlert(title: String, message: String, indexPath: IndexPath) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.newsList.remove(at: indexPath.row)
            self.favTableView.deleteRows(at: [indexPath], with: .fade)
            self.isFavViewEmpty()
            self.favTableView.reloadData()
        }))
        present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
