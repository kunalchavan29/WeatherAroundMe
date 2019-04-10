import Foundation

struct PlacesResponse : Codable {
    
    let cod : String?
    let count : Int?
    let list : [Place]?
    let message : String?
    
    
    enum CodingKeys: String, CodingKey {
        case cod = "cod"
        case count = "count"
        case list = "list"
        case message = "message"
    }
}

struct Place : Codable {
    let dt : Int?
    let id : Int?
    let main : Main?
    let name : String?
    let rain : String?
    let snow : String?
    let sys : Sy?
    let weather : [Weather]?
    let wind : Wind?
    
    enum CodingKeys: String, CodingKey {
//        case clouds
//        case coord
        case dt = "dt"
        case id = "id"
        case main
        case name = "name"
        case rain = "rain"
        case snow = "snow"
        case sys
        case weather = "weather"
        case wind
    }
}

struct Wind : Codable {
    let deg : Float?
    let speed : Float?
        
    enum CodingKeys: String, CodingKey {
        case deg = "deg"
        case speed = "speed"
    }
}

struct Weather : Codable {
    let descriptionField : String?
    let icon : String?
    let id : Int?
    let main : String?
    
    enum CodingKeys: String, CodingKey {
        case descriptionField = "description"
        case icon
        case id
        case main
    }
}

struct Sy : Codable {
    let country : String?
    
    enum CodingKeys: String, CodingKey {
        case country
    }
}

struct Main : Codable {
    
    let grndLevel: Float?
    let humidity: Int?
    let pressure : Float?
    let seaLevel : Float?
    let temp : Float?
    let tempMax : Float?
    let tempMin : Float?
    
    enum CodingKeys: String, CodingKey {
        case grndLevel = "grnd_level"
        case humidity = "humidity"
        case pressure = "pressure"
        case seaLevel = "sea_level"
        case temp = "temp"
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }
}

protocol AppLocationPresentable {
    var latitude: Double { get set }
    var longitude: Double { get set }
}

struct AppLocation: AppLocationPresentable {
    var latitude: Double
    var longitude: Double
}
