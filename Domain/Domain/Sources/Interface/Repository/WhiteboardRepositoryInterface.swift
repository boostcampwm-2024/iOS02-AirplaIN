//
//  WhiteboardRepository.swift
//  Domain
//
//  Created by 최다경 on 11/12/24.
//

public protocol WhiteboardRepositoryInterface {
    var delegate: WhiteboardRepositoryDelegate? { get set }

    /// 주변에 내 기기를 참여자의 아이콘 정보와 함께 화이트보드를 알립니다.
    func startPublishing(with info: [Profile])

    /// 주변 화이트보드를 탐색합니다.
    func startSearching()
}

public protocol WhiteboardRepositoryDelegate: AnyObject {
    /// 주변 화이트보드를 찾았을 때 실행됩니다.
    /// - Parameters:
    ///   - whiteboards: 탐색된 화이트보드 배열
    func whiteboardRepository(_ sender: WhiteboardRepositoryInterface, didFind whiteboards: [Whiteboard])
}
