//
//  URLProtocolMock.swift
//  OpenTmdbTests
//
//  Created by ingenico on 28/04/2022.
//

import Foundation

class URLProtocolMock : URLProtocol {
    static var data = [URL?: Data]()

    override class func canInit(with request: URLRequest) -> Bool {
      return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
       return request
    }

    override func startLoading() {
      if let url = request.url {
        if let data = URLProtocolMock.data[url] {
          client?.urlProtocol(self, didLoad: data)
        }
      }
      
      client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
