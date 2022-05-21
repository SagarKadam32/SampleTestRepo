//
//  DataService.swift
//  RestHub
//
//  Created by Sagar Kadam on 15/05/22.
//

import Foundation

class DataService {
    static let shared = DataService()
    fileprivate let baseURLString = "https://api.github.com"
    
    func fetchGists(completion: @escaping (Result<[Gist],Error>) -> Void) {
        var componentURL = URLComponents()
        componentURL.scheme = "https"
        componentURL.host = "api.github.com"
        componentURL.path = "/gists/public"

        guard let validURL = componentURL.url else{
            print("URL Creation failed...")
            return
        }
        
        URLSession.shared.dataTask(with: validURL) { (data,response,error) in
            if let httpResponse = response as? HTTPURLResponse {
                print("API Status \(httpResponse.statusCode)")
            }
            
            guard let validData = data, error == nil else{
                completion(.failure(error!))
                return
            }
            
            do {
                let gists = try JSONDecoder().decode([Gist].self, from:validData)
                completion(.success(gists))
            }catch let serializationError {
                print(serializationError.localizedDescription)
            }
        }.resume()
    }
    
    func createNewGist(completion: @escaping (Result<Any, Error>) -> Void) {
        let postComponents = createURLComponents(path: "/gists")
        guard let composedURL = postComponents.url else {
            print("URL creation failed..")
            return
        }
        
        var postRequest = URLRequest(url: composedURL)
        postRequest.httpMethod = "POST"
        postRequest.setValue("Basic \(createAuthCredentials())", forHTTPHeaderField: "Authorization")
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let newGist = Gist(id: nil, isPublic: true, description: "A Brand New Gist", files: ["test_file.txt": File(content: "Hello World!")])
        
        do{
            let gistData = try JSONEncoder().encode(newGist)
            postRequest.httpBody = gistData
        }catch{
            print("Gist Encoding Failed..")
        }
        
        URLSession.shared.dataTask(with: postRequest) { (data,resposne, error) in
            if let httpResponse = resposne as? HTTPURLResponse {
                print("Status Code = \(httpResponse.statusCode)")
            }
            
            guard let validData = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: validData, options: [])
                completion(.success(json))
            } catch let serializtionError {
                completion(.failure(serializtionError))
            }
            
        }.resume()
    }
    
    func createURLComponents(path: String) -> URLComponents {
         var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        
        return components
    }
    
    func createAuthCredentials() -> String {
        let authString = "SagarKadam32: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"
        var authStringBase64 = ""
        
        if let authData = authString.data(using: .utf8) {
            authStringBase64 = authData.base64EncodedString()
        }
        return authStringBase64
    }
    
    func starUnstarGist(id: String, star: Bool, completion: @escaping (Bool) -> Void){
        let starComponents = createURLComponents(path: "/gists/\(id)/star")
        
        guard let composeURL = starComponents.url else{
            print("Component Compopsition Failed..")
            return
        }
        
        var starRequest = URLRequest(url: composeURL)
        starRequest.httpMethod = star == true ? "PUT" : "DELETE"
        
        starRequest.setValue("0", forHTTPHeaderField: "Content-Length")
        starRequest.setValue("Basic \(createAuthCredentials())", forHTTPHeaderField: "Authorization")
        starRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        starRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: starRequest) { (data, response, error) in
            
            if let httpResponse = response as?  HTTPURLResponse {
                print("Status Code = \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 204{
                    completion(true)
                }else{
                    completion(false)
                }
            }
        }.resume()
        
    }
}
    
