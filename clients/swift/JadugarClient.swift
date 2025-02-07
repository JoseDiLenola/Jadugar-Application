import Foundation

public struct JadugarError: LocalizedError {
    public let id: String?
    public let status: Int
    public let code: String
    public let title: String
    public let detail: String?
    public let source: [String: Any]?
    public let meta: [String: Any]?
    public let links: [String: String]?
    public let handlingGuide: String?
    public let recoverySuggestion: String?
    
    public var errorDescription: String? {
        return title
    }
    
    public var failureReason: String? {
        return detail
    }
    
    public var recoverySuggestionText: String? {
        return recoverySuggestion
    }
    
    init(errorData: [String: Any]) {
        self.id = errorData["id"] as? String
        self.status = Int(errorData["status"] as? String ?? "500") ?? 500
        self.code = errorData["code"] as? String ?? "UNKNOWN_ERROR"
        self.title = errorData["title"] as? String ?? "Unknown error occurred"
        self.detail = errorData["detail"] as? String
        self.source = errorData["source"] as? [String: Any]
        self.meta = errorData["meta"] as? [String: Any]
        self.links = errorData["links"] as? [String: String]
        
        if let platformSpecific = (meta?["platform_specific"] as? [String: Any]) {
            self.handlingGuide = platformSpecific["handling_guide"] as? String
            self.recoverySuggestion = platformSpecific["recovery_suggestion"] as? String
        } else {
            self.handlingGuide = nil
            self.recoverySuggestion = nil
        }
    }
}

public class JadugarClient {
    private let baseURL: URL
    private let apiKey: String?
    private let version: String
    private let session: URLSession
    
    public init(baseURL: URL, apiKey: String? = nil, version: String = "1.0.0") {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.version = version
        self.session = URLSession.shared
    }
    
    public func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            completion(.failure(JadugarError(errorData: [
                "status": "400",
                "code": "INVALID_URL",
                "title": "Invalid URL"
            ])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        
        // Add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("ios", forHTTPHeaderField: "X-Client-Platform")
        request.addValue(version, forHTTPHeaderField: "X-Client-Version")
        request.addValue(UUID().uuidString, forHTTPHeaderField: "X-Request-ID")
        
        if let apiKey = apiKey {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(JadugarError(errorData: [
                    "status": "500",
                    "code": "NETWORK_ERROR",
                    "title": "Network request failed",
                    "detail": error.localizedDescription
                ])))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(JadugarError(errorData: [
                    "status": "500",
                    "code": "INVALID_RESPONSE",
                    "title": "Invalid response received"
                ])))
                return
            }
            
            guard let data = data else {
                completion(.failure(JadugarError(errorData: [
                    "status": "500",
                    "code": "NO_DATA",
                    "title": "No data received"
                ])))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let errors = json["errors"] as? [[String: Any]],
                       let firstError = errors.first {
                        completion(.failure(JadugarError(errorData: firstError)))
                    } else {
                        completion(.failure(JadugarError(errorData: [
                            "status": String(httpResponse.statusCode),
                            "code": "HTTP_ERROR",
                            "title": "HTTP error occurred"
                        ])))
                    }
                } catch {
                    completion(.failure(JadugarError(errorData: [
                        "status": String(httpResponse.statusCode),
                        "code": "PARSE_ERROR",
                        "title": "Failed to parse error response"
                    ])))
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(JadugarError(errorData: [
                    "status": "500",
                    "code": "DECODE_ERROR",
                    "title": "Failed to decode response",
                    "detail": error.localizedDescription
                ])))
            }
        }
        
        task.resume()
    }
}

// Example usage:
/*
let client = JadugarClient(baseURL: URL(string: "https://api.jadugar.com/v1")!)

client.request(endpoint: "/some-endpoint") { (result: Result<SomeDecodable, Error>) in
    switch result {
    case .success(let data):
        print("Success:", data)
    case .failure(let error):
        if let jadugarError = error as? JadugarError {
            print("Error:", jadugarError.title)
            if let guide = jadugarError.handlingGuide {
                print("Handling Guide:", guide)
            }
            if let recovery = jadugarError.recoverySuggestion {
                print("Recovery:", recovery)
            }
        }
    }
}
*/
