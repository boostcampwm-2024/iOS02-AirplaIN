//
//  ChatRepository.swift
//  DataSource
//
//  Created by 박승찬 on 11/24/24.
//

import Combine
import Domain
import OSLog

public final class ChatRepository: ChatRepositoryInterface {
    public weak var delegate: ChatRepositoryDelegate?
    private var nearbyNetwork: NearbyNetworkInterface
    private let filePersistence: FilePersistenceInterface
    private var cancellables: Set<AnyCancellable>
    private let logger = Logger()

    public init(
        nearbyNetwork: NearbyNetworkInterface,
        filePersistence: FilePersistenceInterface
    ) {
        self.nearbyNetwork = nearbyNetwork
        self.filePersistence = filePersistence
        cancellables = []
        bindNearbyNetwork()
    }

    public func send(message: String, profile: Profile) async -> ChatMessage? {
        let chatMessage = ChatMessage(message: message, sender: profile)
        let chatMessageData = try? JSONEncoder().encode(chatMessage)
        let chatMessageInformation = DataInformationDTO(
            id: profile.id,
            type: .chat,
            isDeleted: false)
        guard
            let url = filePersistence.save(dataInfo: chatMessageInformation, data: chatMessageData)
        else {
            logger.log(level: .error, "url저장 실패: 데이터를 보내지 못했습니다.")
            return nil
        }
        await nearbyNetwork.send(fileURL: url, info: chatMessageInformation)

        return chatMessage
    }

    private func bindNearbyNetwork() {
        nearbyNetwork.reciptURLPublisher
            .sink { [weak self] url, dataInfo in
                switch dataInfo.type {
                case .chat:
                    self?.handleChatData(url: url, dataInfo: dataInfo)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func handleChatData(url: URL, dataInfo: DataInformationDTO) {
        guard let receivedData = filePersistence.load(path: url) else { return }
        filePersistence.save(
            dataInfo: dataInfo,
            data: receivedData)
        guard
            let chatMessage = try? JSONDecoder().decode(
                ChatMessage.self,
                from: receivedData)
        else {
            logger.log(level: .error, "WhiteboardObjectRepository: 전달받은 데이터 디코딩 실패")
            return
        }

        delegate?.chatRepository(self, didReceive: chatMessage)
    }
}
