//
//  ChatViewController.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/12/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatViewController: MessagesViewController {
    
    var sender: Sender!
    
    var league: League!
    
    var messages: [Message] = []
    
    var messagesListener: ListenerRegistration?
    
    deinit {
        messagesListener?.remove()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = league.name
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        messagesCollectionView.backgroundColor = .appBackground
        
        messageInputBar.inputTextView.tintColor = .appAccent
        messageInputBar.sendButton.setTitleColor(.appAccent, for: .normal)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        configure()
        
        addListener()
    }
    
    func configure() {
        scrollsToLastItemOnKeyboardBeginsEditing = true
        showMessageTimestampOnSwipeLeft = true
        additionalSafeAreaInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        additionalBottomInset = 10
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageOutgoingAvatarSize(.zero)
        }
    }
    
    func addListener() {
        var initial = true
        messagesListener = Firestore.firestore().chatsForLeague(league.id).addSnapshotListener { querySnapshot, error in
            if let error = error {
                self.presentSimpleAlert(title: "Database Error", message: error.localizedDescription)
            } else if let querySnapshot = querySnapshot {
                self.messages = querySnapshot.documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Message.self)
                }.sorted { lhs, rhs in lhs.sentDate < rhs.sentDate }
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: !initial)
            }
            initial = false
        }
    }
    
    func isSameSender(index: Int, displacement: Int) -> Bool {
        let other = index + displacement
        if 0 <= other && other < messages.count {
            return messages[index].sender.senderId == messages[index + displacement].sender.senderId
        } else {
            return false
        }
    }

}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let document = Firestore.firestore().chatsForLeague(league.id).document()
        do {
            try document.setData(from: Message(messageId: document.documentID, sender: sender, content: text))
            inputBar.inputTextView.text = ""
        } catch {
            presentSimpleAlert(title: "Send Error", message: error.localizedDescription)
        }
    }
    
}

extension ChatViewController: MessagesDataSource {
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    func currentSender() -> SenderType {
        sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isFromCurrentSender(message: message) || isSameSender(index: indexPath.section, displacement: -1) {
            return nil
        } else {
            return NSAttributedString(string: message.sender.displayName, attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor.systemGray,
            ])
        }
    }
    
}

extension ChatViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        isFromCurrentSender(message: message) ? .appAccent : .systemGray6
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if isFromCurrentSender(message: message) || isSameSender(index: indexPath.section, displacement: 1) {
            avatarView.isHidden = true
        } else {
            avatarView.kf.setImage(with: URL(string: messages[indexPath.section].senderPhotoURL), placeholder: UIImage(systemName: "photo.circle"))
            avatarView.isHidden = false
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        .bubbleTail(isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft, .curved)
    }
    
}

extension ChatViewController: MessagesLayoutDelegate {
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        isFromCurrentSender(message: message) || isSameSender(index: indexPath.section, displacement: -1) ? 0 : 20
    }
    
}
