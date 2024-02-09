import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

String apiKey = "your OpenAI Key";

class ApiServices {
  final _openAI = OpenAI.instance.build(
    token: apiKey,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
        seconds: 5
      ),
    ),
    enableLog: true,
  );

  List<Map<String, dynamic>> _messagesHistory = [];

  Future<String?> sendMessage(String? message) async {
    // 사용자 메시지를 대화 내역에 추가
    _messagesHistory.insert(0, {"role": "user", "content": message});

    // OpenAI에 대화 완료 요청을 보냄
    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(), 
      messages: _messagesHistory, 
      maxToken: 200
    );
    final response = await _openAI.onChatCompletion(request: request);

    // 응답을 받아 대화 내역에 추가하고 반환
    for (var element in response!.choices) {
      if (element.message !=null) {
        _messagesHistory.insert(0, {"role": "assistant", "content": element.message!.content});
        return element.message!.content;
      }
    }

    return null;
  }
}
