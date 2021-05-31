import CoreNFC

@objc(ReactNativeNFC)
class ReactNativeNFC: RCTEventEmitter, NFCNDEFReaderSessionDelegate {

  let nfcHelper = NFCHelper()

  @objc override static func requiresMainQueueSetup() -> Bool {
    return true
  }

  @objc func isSupported() -> Void {
    if #available(iOS 11.0, *) {
      if NFCNDEFReaderSession.readingAvailable {
        sendNFCEnabledEvent({})
        return
      } else {
        sendNFCMissingEvent({})
        return
      }
    }
    sendNFCUnavailableEvent({})
  }

  @objc func initialize() -> Void {
    if #available(iOS 11.0, *) {
      if NFCNDEFReaderSession.readingAvailable {
        let session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
        session.begin()
      } else {
        sendNFCMissingEvent({})
      }
    } else {
      sendNFCUnavailableEvent({})
    }
  }

  override func supportedEvents() -> [String]! {
    return ["__NFC_DISCOVERED", "__NFC_ERROR", "__NFC_MISSING", "__NFC_UNAVAILABLE", "__NFC_ENABLED"]
  }

  func sendEvent(_ data: Any) -> Void {
    sendEvent(withName: "__NFC_DISCOVERED", body: data)
  }

  func sendErrorEvent(_ data: Any) -> Void {
    sendEvent(withName: "__NFC_ERROR", body: data)
  }

  func sendNFCEnabledEvent(_ data: Any) -> Void {
    sendEvent(withName: "__NFC_ENABLED", body: data)
  }

  func sendNFCUnavailableEvent(_ data: Any) -> Void {
    sendEvent(withName: "__NFC_UNAVAILABLE", body: data)
  }

  func sendNFCMissingEvent(_ data: Any) -> Void {
    sendEvent(withName: "__NFC_MISSING", body: data)
  }

  @available(iOS 11.0, *)
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) -> Void {
    let data = nfcHelper.formatError(error)
    sendErrorEvent(data)
  }

  @available(iOS 11.0, *)
  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) -> Void {
    let data = nfcHelper.formatData(messages)
    sendEvent(data)
  }
}
