import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_voice/chat_model.dart';
import 'package:flutter_voice/colors.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_voice/api_services.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late stt.SpeechToText speechToText;
  var text = "Hold the button and start speaking";
  var isListening = false;
  final List<ChatMessage> messages = [];
  var scrollController = ScrollController();

  scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Widget chatBubble(
      {required String? chattext, required ChatMessageType? type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          child: type == ChatMessageType.bot
              ? Image.asset('assets/icon.png')
              : const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: type == ChatMessageType.bot ? bgColor : Colors.white,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
            ),
            child: Text(
              "$chattext",
              style: TextStyle(
                color: type == ChatMessageType.bot ? textColor : chatBgColor,
                fontSize: 15,
                fontWeight: type == ChatMessageType.bot
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    speechToText = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: bgColor,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
  onTapDown: (details) async {
    bool available = await speechToText.initialize(
        onError: (val) => print('onError: $val'),
        onStatus: (val) => print('onStatus: $val'),
    );

    // 사용 가능한 모든 로케일을 가져옵니다.
    var locales = await speechToText.locales();

    // 로케일 목록에서 한국어를 찾습니다.
    var koreanLocale = locales.firstWhere((locale) => locale.localeId.startsWith('ko'));
    
    if (available) {
      setState(() => isListening = true);
      speechToText.listen(
        onResult: (result) {
        setState(() {
          text = result.recognizedWords;
          print("Recognized words: $text");
        });
      },
      localeId: koreanLocale.localeId,  // 한국어 로케일을 설정합니다.
    );
    } else {
      setState(() => isListening = false);
      print("The user has denied the use of speech recognition.");
    }
          },
          onTapUp: (details) async {
            setState(() => isListening = false);
            speechToText.stop();
            messages.add(ChatMessage(text: text, type: ChatMessageType.user));
            var msg = await ApiServices().sendMessage(text);
            setState(() {
              messages.add(ChatMessage(text: msg, type: ChatMessageType.bot));
            });
          },
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: 35,
            child: Icon(isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white),
          ),
        ),
      ),
      appBar: AppBar(
        leading: const Icon(Icons.sort_rounded, color: Colors.white),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0.0,
        title: const Text(
          "Voice Assistant",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                  color: isListening ? Colors.black87 : Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 28),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: chatBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  reverse: false, // 이 부분을 수정했습니다.
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    var chat = messages[index];
                    return chatBubble(chattext: chat.text, type: chat.type);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Developed by Baaba Devs",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
