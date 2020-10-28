//
//  Request.swift
//  VisionAPIClient
//
//  Created by Cagri Sahan on 6/19/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

public struct Request: Codable {
    let requests: [AnnotateImageRequest]
    
    public init(requests: [AnnotateImageRequest]) {
        self.requests = requests
    }
    
    public func perform(completionHandler: @escaping (Response) -> Void) {
        let session = URLSession.shared
        let path = Config.requestPath + Config.key
        let url = URL(string: path)
        
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            request.httpBody = data
            
            let task = session.dataTask(with: request) { data, response, error in
                guard error == nil else {
//                    fatalError(error.debugDescription)
                    return
                }
                guard data != nil else { fatalError("kerane") }
                let a = String(data: data!, encoding: .utf8)
                print("This is the response: \(a)")
                
                let decoder = JSONDecoder()
                do {
                let responseObj = try decoder.decode(Response.self, from: data!)
                completionHandler(responseObj)
                } catch { print(error) }
            }
            task.resume()
            
        } catch { fatalError("hayacanboy") }
        
    }
}
