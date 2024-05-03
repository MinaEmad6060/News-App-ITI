//
//  DetailsViewController.swift
//  NewsAPI
//
//  Created by Mina Emad on 29/04/2024.
//

import UIKit
import SDWebImage
import CoreData


class DetailsViewController: UIViewController {
    
    
    var new : New?
    var appDelegate : AppDelegate?
    var managedObjContext: NSManagedObjectContext?
    let coreData = CoreDataAccessObject()
    static var isFav = false
    
    
    @IBOutlet weak var btnFavImage: UIButton!
    @IBAction func btnFav(_ sender: Any) {
        if DetailsViewController.isFav == false{
            DetailsViewController.isFav = true
            let image = UIImage(systemName: "heart.fill")
            btnFavImage.setImage(image, for: .normal)
            coreData.insertToFavourite(new: new)
        }else{
            DetailsViewController.isFav = false
            let image = UIImage(systemName: "heart")
            btnFavImage.setImage(image, for: .normal)
            coreData.deleteFromFavourite(new: new)
        }
        
    }
    @IBOutlet weak var imageDetailes: UIImageView!
    
    @IBOutlet weak var authorDetailes: UILabel!
    
    
    @IBOutlet weak var titleDetailes: UILabel!
    
    @IBOutlet weak var dateDetailes: UILabel!
    
    
    @IBOutlet weak var descDetailes: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let unwrappedNew = new {
            authorDetailes.text = new?.author
            titleDetailes.text = new?.title
            dateDetailes.text = new?.publishedAt
            descDetailes.text = new?.desription
            
            if let imageUrl = unwrappedNew.imageUrl, let url = URL(string: imageUrl) {
                imageDetailes.sd_setImage(with: url, placeholderImage: UIImage(named: "man"))
            } else {
                imageDetailes.image = UIImage(named: "man")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjContext = appDelegate?.persistentContainer.viewContext
        if DetailsViewController.isFav == false{
            let image = UIImage(systemName: "heart")
            btnFavImage.setImage(image, for: .normal)
        }else{
            let image = UIImage(systemName: "heart.fill")
            btnFavImage.setImage(image, for: .normal)
        }
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
