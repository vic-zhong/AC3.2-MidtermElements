# AC3.2-MidtermElements

## Objective

* Build a table view application that loads a list of the Elements. Use the built in detail
    cell, with a thumnail image, setting the title and the detail as follows:

    ```
    Name
    Symbol(Number) Atomic Weight

    e.g.

    Sodium
    Na(11) 22.9897
    ```

* Tapping a cell segue's to a detail view that shows a larger image and all collected
  data fields.

* The Favorite 

## Endpoints

**Elements**

```
https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/elements
```

**Images**

```
thumbnail
https://s3.amazonaws.com/ac3.2-elements/<symbol>_200.png
e.g.
https://s3.amazonaws.com/ac3.2-elements/Sn_200.png

full size
https://s3.amazonaws.com/ac3.2-elements/<symbol>.png
e.g.
https://s3.amazonaws.com/ac3.2-elements/Sn.png
```

**Favorite**

```
POST https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/favorites
```

## API Request Manager

Here is the APIRequestManager in its entirety. ```getData(endPoint:callback)``` is the
familiar call.

```postRequest(endPoint:data)``` POSTs the data dictionary ( ```[String:Any]``` ) to the 
endpoint passed to it. There is no closure so the calling context won't know when its done
nor will it receive any data. This is fine. **Check your console for confirmation** for the
one data call you'll need this for.

```swift
import Foundation

class APIRequestManager {
    
    static let manager = APIRequestManager()
    private init() {}
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
            }.resume()
    }
    
    func postRequest(endPoint: String, data: [String:Any]) {
        guard let url = URL(string: endPoint) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // this is specifically for the midterm  -- don't change if you want to write there
        request.addValue("Basic a2V5LTE6dHdwTFZPdm5IbEc2ajFBZndKOWI=", forHTTPHeaderField: "Authorization")
        
        do {
            let body = try JSONSerialization.data(withJSONObject: data, options: [])
            request.httpBody = body
        } catch {
            print("Error posting body: \(error)")
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error encountered during post request: \(error)")
            }
            if response != nil {
                let httpResponse = (response! as! HTTPURLResponse)
                print("Response status code: \(httpResponse.statusCode)")
            }
            guard let validData = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: []) as? [String:Any]
                if let validJson = json {
                    print(validJson)
                }
            } catch {
                print("Error converting json: \(error)")
            }
            }.resume()
    }
}
```
