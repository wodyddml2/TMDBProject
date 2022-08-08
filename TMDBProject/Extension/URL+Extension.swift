import Foundation

extension URL {
    static let baseURL = "https://api.themoviedb.org/3/"
    
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}
