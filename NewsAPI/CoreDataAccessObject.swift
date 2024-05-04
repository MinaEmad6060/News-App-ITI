//
//  CoreDataAccessObject.swift
//  NewsAPI
//
//  Created by Mina Emad on 02/05/2024.
//

import Foundation
import CoreData
import UIKit

class CoreDataAccessObject{
    
    var appDelegate : AppDelegate?
    var managedObjContext: NSManagedObjectContext?
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjContext = appDelegate?.persistentContainer.viewContext
    }
    
    
    //News table
    func insertToNews(newsList: [New]){
        let entity = NSEntityDescription.entity(forEntityName: "News", in: managedObjContext!)
        
        for i in 0..<newsList.count {
            let new = NSManagedObject(entity: entity!, insertInto: managedObjContext)
            new.setValue(newsList[i].author, forKey: "author")
            new.setValue(newsList[i].title, forKey: "title")
            new.setValue(newsList[i].desription, forKey: "desription")
            new.setValue(newsList[i].imageUrl, forKey: "imageUrl")
            new.setValue(newsList[i].url, forKey: "url")
            new.setValue(newsList[i].publishedAt, forKey: "publishedAt")
            do{
                try managedObjContext?.save()
                print("Insert")
            }catch{
                print("Can't Insert")
            }
        }
    }
    
    
    func getAllNewsFromNews(homeTableView: UICollectionView?, indicator : UIActivityIndicatorView?) -> [New]{
        var newsListOffline : [New] = []
        let fetchNews = NSFetchRequest<NSManagedObject>(entityName: "News")
        
        do{
            let news = try managedObjContext?.fetch(fetchNews)
            guard let count = news?.count else{return []}
            for i in 0..<count{
                let myNew = New()
                myNew.title = news?[i].value(forKey: "title") as? String ?? ""
                myNew.imageUrl = news?[i].value(forKey: "imageUrl") as? String ?? ""
                myNew.author = news?[i].value(forKey: "author") as? String ?? ""
                myNew.desription = news?[i].value(forKey: "desription") as? String ?? ""
                myNew.url = news?[i].value(forKey: "url") as? String ?? ""
                myNew.publishedAt = news?[i].value(forKey: "publishedAt") as? String ?? ""
                newsListOffline.append(myNew)
            }

            guard let homeTableView = homeTableView
            else{return []}
            indicator?.stopAnimating()
            homeTableView.reloadData()
            print("Get All News \( news?.count ?? 0)")
            print("newsListOffline \(newsListOffline.count)")
        }catch let error as NSError{
            print("Can't Get All News\(error)")
        }
        return newsListOffline
    }
    
    
    
    func deleteAllNewsFromNews(){
        let fetchForDeletion = NSFetchRequest<NSManagedObject>(entityName: "News")
        
        do{
            guard let news = try managedObjContext?.fetch(fetchForDeletion) else{return}
            for i in 0..<news.count{
                managedObjContext?.delete((news[i]))
            }
            try managedObjContext?.save()
            print("Delete New")
        }catch let error as NSError{
            print("Can't Delete New\(error)")
        }
    }
    
    
    //Fav. table
    func insertToFavourite(new: New?){
        let entity = NSEntityDescription.entity(forEntityName: "Favourites", in: managedObjContext!)
        guard let new = new else{return}
        let news = NSManagedObject(entity: entity!, insertInto: managedObjContext)
        news.setValue(new.author, forKey: "author")
        news.setValue(new.title, forKey: "title")
        news.setValue(new.desription, forKey: "desription")
        news.setValue(new.imageUrl, forKey: "imageUrl")
        news.setValue(new.url, forKey: "url")
        news.setValue(new.publishedAt, forKey: "publishedAt")
        do{
            try managedObjContext?.save()
        }catch{
            print("Can't Insert")
        }
    }
    
    
    func getAllNewsFromFavourite(favTableView: UITableView) -> [New]{
        var newList : [New] = []
                
        let fetchNews = NSFetchRequest<NSManagedObject>(entityName: "Favourites")
        
        do{
            let news = try managedObjContext?.fetch(fetchNews)
            
            guard let count = news?.count else{return []}
            for i in 0..<count{
                let myNew = New()
                myNew.title = news?[i].value(forKey: "title") as? String ?? ""
                myNew.imageUrl = news?[i].value(forKey: "imageUrl") as? String ?? ""
                myNew.author = news?[i].value(forKey: "author") as? String ?? ""
                myNew.desription = news?[i].value(forKey: "desription") as? String ?? ""
                myNew.url = news?[i].value(forKey: "url") as? String ?? ""
                myNew.publishedAt = news?[i].value(forKey: "publishedAt") as? String ?? ""
                
                newList.append(myNew)
            }
            print("Get fav newsList \( newList.count)")
        }catch let error as NSError{
            print("Can't Get All News\(error)")
        }
        
        return newList
    }
    
    func isNewInFavList(new: New?) -> Bool{
        let fetchNew = NSFetchRequest<NSManagedObject>(entityName: "Favourites")
        guard let new = new else{return false}
        let myPredicate = NSPredicate(format: "title == %@", new.title ?? "")
        fetchNew.predicate = myPredicate
        do{
            guard let news = try managedObjContext?.fetch(fetchNew) else{return false}
            print("Get a New from favourits \(news.count)")
            if(news.count > 0){
                return true
            }
        }catch let error as NSError{
            print("Can't Delete New\(error)")
        }
        return false
    }
    
    
    func deleteFromFavourite(new: New?){
        let fetchForDeletion = NSFetchRequest<NSManagedObject>(entityName: "Favourites")
        guard let new = new else{return}
        let myPredicate = NSPredicate(format: "title == %@", new.title ?? "")
        fetchForDeletion.predicate = myPredicate
        do{
            guard let news = try managedObjContext?.fetch(fetchForDeletion) else{return}
            for i in 0..<news.count{
                managedObjContext?.delete((news[i]))
            }
            try managedObjContext?.save()
            print("Delete New news.count \(news.count)")
        }catch let error as NSError{
            print("Can't Delete New\(error)")
        }
    }

}
