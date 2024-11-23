//
//  ManageWhiteboardObjectsUseCaseTests.swift
//  DomainTests
//
//  Created by 이동현 on 11/16/24.
//

import Combine
import Domain
import XCTest

final class ManageWhiteboardObjectsUseCaseTests: XCTestCase {
    private var useCase: ManageWhiteboardObjectUseCaseInterface!
    private var cancellables: Set<AnyCancellable>!
    private var myProfile: Profile!

    override func setUpWithError() throws {
        let profileRepository = MockProfileRepository()
        myProfile = profileRepository.loadProfile()

        useCase = ManageWhiteboardObjectUseCase(
            profileRepository: profileRepository,
            whiteboardRepository: MockWhiteObjectRepository())
        cancellables = []
    }

    override func tearDownWithError() throws {
        useCase = nil
    }

    // 화이트보드 오브젝트 추가가 성공하는지 테스트
    func testAddWhiteboardObjectSuccess() async {
        // 준비
        let targetObject = WhiteboardObject(
            id: UUID(),
            position: .zero,
            size: CGSize(width: 100, height: 100))
        var receivedObject: WhiteboardObject?

        useCase.addedObjectPublisher
            .sink { receivedObject = $0 }
            .store(in: &cancellables)

        // 실행
        let isSuccess = await useCase.addObject(whiteboardObject: targetObject)

        // 검증
        XCTAssertTrue(isSuccess)
        XCTAssertEqual(receivedObject, targetObject)
    }

    // 화이트보드 오브젝트 중복 추가가 실패하는지 테스트
    func testAddDuplicateObjectFails() async {
        // 준비
        let targetObject = WhiteboardObject(
            id: UUID(),
            position: .zero,
            size: CGSize(width: 100, height: 100))

        // 실행
        let isSuccess = await useCase.addObject(whiteboardObject: targetObject)
        let isFailure = await !useCase.addObject(whiteboardObject: targetObject)

        // 검증
        XCTAssertTrue(isSuccess)
        XCTAssertTrue(isFailure)
    }

    // 화이트보드 오브젝트 업데이트 성공하는지 테스트
    func testUpdateObjectSuccess() async {
        // 준비
        let uuid = UUID()
        let object = WhiteboardObject(
            id: uuid,
            position: .zero,
            size: CGSize(width: 100, height: 100))
        let updatedObject = WhiteboardObject(
            id: uuid,
            position: CGPoint(x: 50, y: 50),
            size: CGSize(width: 200, height: 200))
        var receivedObject: WhiteboardObject?

        useCase.updatedObjectPublisher
            .sink { receivedObject = $0 }
            .store(in: &cancellables)

        // 실행
        await useCase.addObject(whiteboardObject: object)
        let isSuccess = await useCase.updateObject(whiteboardObject: updatedObject)

        // 검증
        XCTAssertTrue(isSuccess)
        XCTAssertEqual(updatedObject, receivedObject)
    }

    // 존재하지 않는 화이트보드 오브젝트 업데이트 실패하는지 테스트
    func testUpdateNonExistentObjectFails() async {
        // 준비
        let targetObject = WhiteboardObject(
            id: UUID(),
            position: CGPoint(x: 50, y: 50),
            size: CGSize(width: 200, height: 200))
        var receivedObject: WhiteboardObject?

        useCase.updatedObjectPublisher
            .sink { receivedObject = $0 }
            .store(in: &cancellables)

        // 실행
        let isFailure = await !useCase.updateObject(whiteboardObject: targetObject)

        // 검증
        XCTAssertTrue(isFailure)
        XCTAssertNil(receivedObject)
    }

    // 화이트보드 오브젝트 삭제 성공하는지 테스트
    func testRemoveObjectSuccess() async {
        // 준비
        let object1 = WhiteboardObject(
            id: UUID(),
            position: .zero,
            size: CGSize(width: 100, height: 100))
        let object2 = WhiteboardObject(
            id: UUID(),
            position: .zero,
            size: CGSize(width: 100, height: 100))
        let targetObject = WhiteboardObject(
            id: UUID(),
            position: .zero,
            size: CGSize(width: 100, height: 100))
        var receivedObject: WhiteboardObject?

        useCase.removedObjectPublisher
            .sink { receivedObject = $0 }
            .store(in: &cancellables)

        // 실행
        await useCase.addObject(whiteboardObject: object1)
        await useCase.addObject(whiteboardObject: targetObject)
        await useCase.addObject(whiteboardObject: object2)
        let isSuceess = await useCase.removeObject(whiteboardObject: targetObject)

        // 검증
        XCTAssertTrue(isSuceess)
        XCTAssertEqual(targetObject, receivedObject)
    }

    // 존재하지 않는 화이트보드 오브젝트 삭제 실패하는지 테스트
    func testRemoveNonExistentObjectFails() async {
        // 준비
        let object = WhiteboardObject(
            id: UUID(),
            position: .zero,
            size: CGSize(width: 100, height: 100))
        var receivedObject: WhiteboardObject?

        useCase.removedObjectPublisher
            .sink { receivedObject = $0 }
            .store(in: &cancellables)

        // 실행
        let isFailure = await !useCase.removeObject(whiteboardObject: object)

        // 검증
        XCTAssertTrue(isFailure)
        XCTAssertNil(receivedObject)
    }

    // 화이트보드 오브젝트 선택 성공하는지 테스트
    func testSelectWhiteboardObjectSuccess() async {
        // 준비
        let targetObject = WhiteboardObject(
            id: UUID(),
            position: .zero,
            size: CGSize(width: 100, height: 100),
            selectedBy: nil)

        // 실행
        await useCase.addObject(whiteboardObject: targetObject)
        let isSuccess = await useCase.select(whiteboardObjectID: targetObject.id)

        // 검증
        XCTAssertTrue(isSuccess)
        XCTAssertEqual(targetObject.selectedBy, myProfile)
    }

    // 이미 선택된 객체를 선택할 때 실패하는지 테스트
    func testSelectAlreadySelectedObjectFails() async {
        // 준비
        let myProfile = Profile(nickname: "test", profileIcon: .angel)
        let strangerProfile = Profile(nickname: "strangerProfile", profileIcon: .cold)
        let targetObject = WhiteboardObject(
            id: UUID(),
            position: .zero,
            size: CGSize(width: 100, height: 100),
            selectedBy: strangerProfile)

        // 실행
        await useCase.addObject(whiteboardObject: targetObject)
        let isFailure = await !useCase.select(whiteboardObjectID: targetObject.id)

        // 검증
        XCTAssertTrue(isFailure)
        XCTAssertNotEqual(targetObject.selectedBy, myProfile)
        XCTAssertEqual(targetObject.selectedBy, strangerProfile)
    }

    // 존재하지 않는 객체를 선택할 때 실패하는지 테스트
    func testSelectNonExistentObjectFails() async {
        // 준비
        let nonExistentObjectID = UUID()
        var selectedObjectID: UUID?
        useCase.selectedObjectIDPublisher
            .sink { selectedObjectID = $0 }
            .store(in: &cancellables)

        // 검증
        let isFailure = await !useCase.select(whiteboardObjectID: nonExistentObjectID)

        // 실행
        XCTAssertTrue(isFailure)
        XCTAssertNil(selectedObjectID)
    }

    // 객체 선택 해제 성공하는지 테스트
    func testDeselectWhiteboardObjectSuccess() async {
        // 준비
        let targetObject = WhiteboardObject(
            id: UUID(),
            position: .zero,
            size: CGSize(width: 100, height: 100),
            selectedBy: nil)

        // 실행
        await useCase.addObject(whiteboardObject: targetObject)
        await useCase.select(whiteboardObjectID: targetObject.id)
        let isSuccess = await useCase.deselect()

        // 검증
        XCTAssertTrue(isSuccess)
    }

    // TODO: - 객체 수신, 삭제 테스트 코드 추가
}

final class MockProfileRepository: ProfileRepositoryInterface {
    private let mockProfile = Profile(nickname: "test", profileIcon: .angel)

    func loadProfile() -> Profile {
        return mockProfile
    }

    func saveProfile(profile: Profile) {
        return
    }
}

final class MockWhiteObjectRepository: WhiteboardObjectRepositoryInterface {
    var delegate: (any Domain.WhiteboardObjectRepositoryDelegate)?

    func send(whiteboardObject: Domain.WhiteboardObject, isDeleted: Bool) async {
        return
    }
}
