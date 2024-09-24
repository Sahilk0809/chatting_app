import 'package:chatting_app/controller/chat_controller.dart';
import 'package:chatting_app/modal/chat_modal.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  final bool isVideoCall;

  const CallPage({
    super.key,
    required this.isVideoCall,
  });

  @override
  Widget build(BuildContext context) {
    String? sender = AuthService.authService.getCurrentUser()!.email;
    String? receiver = chatController.receiverEmail.value;
    List doc = [sender, receiver];
    doc.sort();
    String callId = doc.join("_");

    return ZegoUIKitPrebuiltCall(
      appID: 2062097465,
      // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
          '3096bafb0fc85022d64b2dff2856e0d4cde7c763b0d0d8288a2b751871bfcb87',
      // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: chatController.receiverEmail.value,
      userName: chatController.receiverName.value,
      callID: callId,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: (isVideoCall)? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall() : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }
}
