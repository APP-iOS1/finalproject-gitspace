//
//  EncryptionUpdateView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/07/04.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct EncryptionUpdateView: View {

    var viewModel: EncryptionUpdateViewModel

    @State private var isShowingReadChatAlert = false
    @State private var isShowingReadMessageAlert = false

    @State private var isShowingEncryptChatAlert = false
    @State private var isShowingEncryptMessageAlert = false

    var body: some View {


      GSButton.CustomButtonView(style: .secondary(isDisabled: false)) {
          isShowingReadChatAlert = true
      } label: {
          GSText.CustomTextView(
              style: .buttonTitle1,
              string: "read chat"
          )
      }
      .alert("chat Document들의 knockContent와 lastContent를 콘솔에 보여줍니다", isPresented: $isShowingReadChatAlert) {
          Button("OK", role: .destructive) {
              Task {
                  await viewModel.readChatDocuments()
              }
          }

          Button("Cancel", role: .cancel) { }
      }

      GSButton.CustomButtonView(style: .secondary(isDisabled: false)) {
          isShowingEncryptChatAlert = true
      } label: {
          GSText.CustomTextView(
              style: .buttonTitle1,
              string: "update(encrypt) chat"
          )
          .background(Color.gsRed)
      }
      .alert("모든 Chat Document의 knockContent와 lastContent를 base64 인코딩하시겠습니까?", isPresented: $isShowingEncryptChatAlert) {
          Button("Encode now", role: .destructive) {
              Task {
                  await viewModel.applyChatContentEncryption()
              }
          }

          Button("Cancel", role: .cancel) { }
      }

      GSButton.CustomButtonView(style: .secondary(isDisabled: false)) {
          isShowingReadMessageAlert = true
      } label: {
          GSText.CustomTextView(
              style: .buttonTitle1,
              string: "read message"
          )
      }
      .alert("message들의 textContent를 콘솔에 보여줍니다", isPresented: $isShowingReadMessageAlert) {
          Button("OK", role: .destructive) {
              Task {
                  await viewModel.readMessageDocuments()
              }
          }

          Button("Cancel", role: .cancel) { }
      }

      GSButton.CustomButtonView(style: .secondary(isDisabled: false)) {
          isShowingEncryptMessageAlert = true
      } label: {
          GSText.CustomTextView(
              style: .buttonTitle1,
              string: "encrypt message"
          )
          .background(Color.gsRed)
      }
      .alert("모든 Message의 textContent를 base64 인코딩하시겠습니까?", isPresented: $isShowingEncryptMessageAlert) {
          Button("Encode now", role: .destructive) {
              Task {
                  await viewModel.applyMessageContentEncryption()
              }
          }

          Button("Cancel", role: .cancel) { }
      }

    }

}
