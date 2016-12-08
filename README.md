# AC3.2-MidtermElements

## Setup

1. Fork this repo.
1. Clone this repo to your laptop.
1. Create a new project (Single View Application) inside it called "AC3.2-MidtermElements".
1. Work on the assessment as described below.
1. Commit your work.
1. Push it to your fork.
1. Create a pull request.

## Objective

* Build a table view that loads and displays a list of the Elements, one per cell/row. Use the built in Subtitle
    UITableViewCell setting the title and the subtitle/detail as follows:

    ```
    Name
    Symbol(Number) Atomic Weight

    e.g.

    Sodium
    Na(11) 22.9897
    ```
    
    Load a thumbnail image on each row as described below under Endpoints > Images.
    
* Tapping a cell segues to a detail view that:
    * sets the title to the ```name``` of the element
    * shows the larger image 
    * and the following data:
        * symbol
        * number
        * weight
        * melting point
        * boiling point

    * has a button that, when pressed, selects this element as your favorite. This
    should be implemented by a POST to the ```favorites``` endpoint.

* Extra credit
    1. Try to include as much of the data as you can in the detail
    1. Try to format the detail view as much like an individual element on a traditional periodic table as you can. Refer to http://sciencenotes.org/wp-content/uploads/2013/06/PeriodicTable-NoBackground2.png or any online resource you like.
    **Be sure to still include
    the image, melting and boiling points, which are part of the basic requirements.** In fact, to meet the 
    basic requirements and both of these extra credits I'd recommend generating the traditional representation and then
    just putting the extra info outside of it.

## Endpoints

**Elements**

```
https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/elements
```

This is a public read-only GET endpoint so no authentication is necessary.

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

Use the file naming convention illustrated here to generate urls for images.

**Favorites**

```
POST https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/favorites
```

This endpoint expects JSON with the following two keys: "my_name" and "favorite_element".
Values should be your own name, and the symbol of the element currently displayed by the detail page, respectively.
These are passed in via the second parameter of the ```postRequest(endPoint:data:)``` method 
of the APIRequestManager.

## Data structure

Elements looks like this:

```javascript
    {
    "id": 1,
    "record_url": "https://fieldbook.com/records/5848deac37802c0400b17c6b",
    "number": 1,
    "weight": 1.0079,
    "name": "Hydrogen",
    "symbol": "H",
    "melting_c": -259,
    "boiling_c": -253,
    "density": 0.09,
    "crust_percent": 0.14,
    "discovery_year": "1776",
    "group": 1,
    "electrons": "1s1",
    "ion_energy": 13.5984
    },
    {
    "id": 109,
    "record_url": "https://fieldbook.com/records/5848dead37802c0400b17cd7",
    "number": 109,
    "weight": 268,
    "name": "Meitnerium",
    "symbol": "Mt",
    "melting_c": null,
    "boiling_c": null,
    "density": null,
    "crust_percent": null,
    "discovery_year": "1982",
    "group": 9,
    "electrons": null,
    "ion_energy": null
    }
```

Note the types of the variables and how many keys in the second example have null values.
You should process the JSON data into your object in such a way that those fields are 
allowed to be null, and that the object is still instantiated.

## API Request Manager

Here is the APIRequestManager in its entirety. ```getData(endPoint:callback)``` is the
familiar call.

```postRequest(endPoint:data)``` POSTs the data dictionary ( ```[String:Any]``` ) to the 
endpoint passed to it. There is no closure so the calling context won't know when its done
nor will it receive any data. This is fine. **Check your console for confirmation** for the
one data call you'll need this for.

The needed headers are included in this method so you don't need to worry about your own FieldBook
account.
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
