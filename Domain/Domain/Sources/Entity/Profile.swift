//
//  Profile.swift
//  Domain
//
//  Created by 최정인 on 11/12/24.
//

import Foundation

public struct Profile: Codable, Hashable {
    public let id: UUID
    public let nickname: String
    public let profileIcon: ProfileIcon

    public init(
        id: UUID,
        nickname: String,
        profileIcon: ProfileIcon
    ) {
        self.id = id
        self.nickname = nickname
        self.profileIcon = profileIcon
    }

    public init(nickname: String, profileIcon: ProfileIcon) {
        self.init(
            id: UUID(),
            nickname: nickname,
            profileIcon: profileIcon)
    }
}

extension Profile {
    static let adjectives = [
        "날쌘",
        "용감한",
        "귀여운",
        "활발한",
        "영리한",
        "씩씩한",
        "똑똑한",
        "빠른",
        "당찬",
        "호기심 많은"
    ]
    static let animals = [
        "여우",
        "늑대",
        "토끼",
        "사자",
        "다람쥐",
        "독수리",
        "곰돌이",
        "호랑이",
        "표범",
        "고양이",
        "올빼미",
        "펭귄",
        "부엉이",
        "두더지",
        "물개",
        "강아지"
    ]
    public static func randomNickname() -> String {
        return "\(adjectives.randomElement() ?? "용감한") \(animals.randomElement() ?? "강아지")"
    }
}

// MARK: - Equatable
extension Profile: Equatable {
    public static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.id == rhs.id
    }
}
