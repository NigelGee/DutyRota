//
//  URLSession-Codable.swift
//  DutyRota
//
//  Created by Nigel Gee on 21/02/2024.
//

import Foundation

/// A URLSession extension that fetches data from a URL and decodes to some Decodable type.
/// Usage: let user = try await URLSession.shared.decode(UserData.self, from: someURL)
/// Note: this requires Swift 5.5.
extension URLSession {
    func decode<T: Decodable>(
        _ type: T.Type = T.self,
        from urlString: String,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
    ) async throws  -> T {
        guard let url = URL(string: urlString) else {
            fatalError("Unable to get URL")
        }

        let (data, _) = try await data(from: url)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dataDecodingStrategy = dataDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy

        let decoded = try decoder.decode(T.self, from: data)
        return decoded
    }
}
