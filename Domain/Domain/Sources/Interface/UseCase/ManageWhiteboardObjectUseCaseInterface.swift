//
//  ManageWhiteboardObjectUseCaseInterface.swift
//  Domain
//
//  Created by 이동현 on 11/16/24.
//

import Combine
import Foundation

public protocol ManageWhiteboardObjectUseCaseInterface {
    /// 화이트보드 객체가 추가될 때 이벤트를 방출합니다.
    var addedObjectPublisher: AnyPublisher<WhiteboardObject, Never> { get }

    /// 화이트보드 객체가 수정될 때 이벤트를 방출합니다.
    var updatedObjectPublisher: AnyPublisher<WhiteboardObject, Never> { get }

    /// 화이트보드 객체가 제거될 때 이벤트를 방출합니다.
    var removedObjectPublisher: AnyPublisher<WhiteboardObject, Never> { get }

    /// 화이트보드 객체가 선택/선택 해제될 때 이벤트를 방출합니다
    var selectedObjectIDPublisher: AnyPublisher<UUID?, Never> { get }

    /// 화이트보드 객체를 추가하는 메서드
    /// - Parameter whiteboardObject: 추가할 화이트보드 객체
    /// - Returns: 추가 성공 여부
    @discardableResult
    func addObject(whiteboardObject: WhiteboardObject) async -> Bool

    /// 화이트보드 객체를 수정하는 메서드
    /// - Parameter whiteboardObject: 수정할 화이트보드 객체
    /// - Returns: 추가 성공 여부
    @discardableResult
    func updateObject(whiteboardObject: WhiteboardObject) async -> Bool

    /// 화이트보드를 제거하는 메서드
    /// - Returns: 추가 성공 여부
    @discardableResult
    func removeObject(whiteboardObject: WhiteboardObject) async -> Bool

    /// 화이트보드 오브젝트를 선택합니다.
    /// - Parameter whiteboardObject: 선택할 오브젝트
    @discardableResult
    func select(whiteboardObjectID: UUID) async -> Bool

    /// 화이트보드 오브젝트를 선택 해제 합니다.
    @discardableResult
    func deselect() async -> Bool
}
