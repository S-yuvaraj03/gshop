import 'package:google_generative_ai/google_generative_ai.dart';

class Chat {
  final List<Content> history;

  Chat({required this.history});

  Future<GenerateContentResponse> sendMessage(
      GenerativeModel model, Content content) async {
    history.add(content);
    final response = await model.generateContent(history);
    history.add(Content.text(response.text!));

    return response;
  }
}
