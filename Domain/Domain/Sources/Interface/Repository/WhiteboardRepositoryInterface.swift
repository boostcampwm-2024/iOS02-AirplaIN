//
//  WhiteboardRepository.swift
//  Domain
//
//  Created by 최다경 on 11/12/24.
//
import Combine
import Foundation

public protocol WhiteboardRepositoryInterface {
    var delegate: WhiteboardRepositoryDelegate? { get set }
    var recentPeerPublisher: AnyPublisher<Profile, Never> { get }
    var connectionResultPublisher: AnyPublisher<Bool, Never> { get }

    /// 주변에 내 기기를 참여자의 아이콘 정보와 함께 화이트보드를 알립니다.
    /// - Parameter myProfile: 나의 프로필
    func startPublishing(myProfile: Profile)

    /// 화이트보드 탐색을 중지합니다.
    func stopSearching()

    /// 화이트보드 탐색을 시작합니다. 
    func startSearching()

    /// 화이트보드와 연결을 끊습니다. 
    func disconnectWhiteboard()

    /// 선택한 화이트보드와 연결을 시도합니다.
    /// - Parameter whiteboard: 연결할 화이트보드
    func joinWhiteboard(whiteboard: Whiteboard, myProfile: Profile) throws
}

public protocol WhiteboardRepositoryDelegate: AnyObject {
    /// 주변 화이트보드를 찾았을 때 실행됩니다.
    /// - Parameters:
    ///   - whiteboards: 탐색된 화이트보드 배열
    func whiteboardRepository(_ sender: WhiteboardRepositoryInterface, didFind whiteboards: [Whiteboard])

    /// 주변 화이트보드가 사라졌을 때 실행됩니다.
    /// - Parameters:
    ///   - whiteboard: 사라진 화이트보드
    func whiteboardRepository(_ sender: WhiteboardRepositoryInterface, didLost whiteboardID: UUID)
}
