//
//  Beer.swift
//  BreweryApp
//
//  Created by HyeonSoo Kim on 2022/02/11.
//

import Foundation

struct Beer: Decodable {
    //값을 못받을수도 있으니 옵셔널로 하자.
    let id: Int?
    let name, taglineString, description, brewersTips, imageURL: String?
    let foodPairing: [String]?
    
    //tagline을 원하는 형태로 가꾸기.
    var tagLine: String {
        let tags = taglineString?.components(separatedBy: ". ")
        let hashtags = tags?.map {
            "#" + $0.replacingOccurrences(of: " ", with: "") //띄어쓰기 없애기.
                .replacingOccurrences(of: ".", with: "") //마지막 끝점 없애기.
                .replacingOccurrences(of: ",", with: " #") //?????
        }
        return hashtags?.joined(separator: " ") ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description //그대로 쓰는 애들.
        case taglineString = "tagline"
        case brewersTips = "brewers_tips"
        case imageURL = "image_url"
        case foodPairing = "food_pairing"
    }
}

//설정한 key값과 서버에서 오는 key값의 이름이 다를 경우, CondingKey 이용하여 원래이름 알려줘야함.
