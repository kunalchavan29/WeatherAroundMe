import Foundation

class AppUtility {
    
    class func getValueFromPlist(for key: String) -> Any? {
        if let url = Bundle.main.url(forResource:"Info", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:url)
                let swiftDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
                return swiftDictionary[key]
            } catch {
                return nil
            }
        }
        return nil
    }
}

extension Dictionary {
    var queryString: String? {
        return self.reduce("") { "\($0!)\($1.0)=\($1.1)&" }
    }
}
