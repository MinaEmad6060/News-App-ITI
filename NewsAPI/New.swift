//
//  New.swift
//  NewsAPI
//
//  Created by Mina Emad on 29/04/2024.
//

import Foundation


class New: Codable{
    var author: String?
    var title: String?
    var desription: String?
    var imageUrl: String?
    var url: String?
    var publishedAt: String?
}




func getDataFromAPI(handler: @escaping (([New]) -> Void)){
    print("getDataFromAPI")
    let url = URL(string: "https://raw.githubusercontent.com/DevTides/NewsApi/master/news.json")
    
    guard let urlAPI = url else{
        print("urlAPI")
        return
    }
    
    let request = URLRequest(url: urlAPI)
    let session = URLSession(configuration: .default)
    
    let task = session.dataTask(with: request) { (data, response, error) in
        
        guard let data = data else{
            print("data is null")
            return
        }
        
        do{
            let news = try JSONDecoder().decode([New].self, from: data)
            print(news[0].title ?? "Success but no data")
            handler(news)
        }catch{
            print("Error when hit Api")
        }
    }
    
    task.resume()
}


