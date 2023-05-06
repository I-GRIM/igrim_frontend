import 'dart:io';

import 'package:dart_openai/openai.dart';
import 'package:http/http.dart' as http;
import 'package:igrim/api_keys.dart';
import 'package:igrim/exceptions/base_exception.dart';
import 'package:igrim/exceptions/error_code.dart';
import 'dart:developer' as developer;

void main(List<String> args) async {
  // OpenAI.apiKey = GPT_API_KEY;
  // OpenAIImageVariationModel imageVariation =
  //     await OpenAI.instance.image.variation(
  //   image: File("C:/Users/99san/Desktop/KakaoTalk_20230503_202308084.png"),
  //   n: 1,
  //   size: OpenAIImageSize.size1024,
  //   responseFormat: OpenAIImageResponseFormat.url,
  // );
// print(imageVariation.data);
  OpenApiService.getCharacterPrompt(
      "옛날 옛날 어느 비가 오는 날 어느 깊은 산골의 한 마을에 동연이가 상윤이에게 괴롭힘을 당하고 있었어요요");
}

class OpenApiService {
  static String BaseURL = "https://api.openai.com/v1";

  static availableModels() async {
    final url = Uri.parse('$BaseURL/models');
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'Bearer $GPT_API_KEY'},
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
      throw BaseException(ErrorCode.NEED_SIGN_IN, "오류");
    }
  }

  static Future<String> getCharacterPrompt(String story) async {
    OpenAI.apiKey = GPT_API_KEY;
    String prompt =
        "Can you describe emotions and behavior of each characters in the following story in this format? {a boy : sad, happy} DON'T INCLUDE ANY OTHER DESCRIPTION and answer in English \n";

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: prompt + story,
          role: OpenAIChatMessageRole.user,
        ),
      ],
    );

    String response = chatCompletion.choices[0].message.content;
    developer.log(response, name: "StoryService");

    return response;
  }

  static Future<String> getKeywords(String story) async {
    OpenAI.apiKey = GPT_API_KEY;
    String prompt =
        "Can you make me a DALL-E prompt for the background scene of the following story in English? Don't include any character related keyword like Boy, girl. I just want to make a background Image. \n $story";

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: prompt,
          role: OpenAIChatMessageRole.user,
        ),
      ],
    );

    String response = chatCompletion.choices[0].message.content;
    developer.log(response, name: "StoryService");

    return response;
  }

  static Future<String> generateImage(String prompt) async {
    OpenAIImageModel image = await OpenAI.instance.image.create(
      prompt: "ghibli style $prompt",
      n: 1,
      size: OpenAIImageSize.size1024,
      responseFormat: OpenAIImageResponseFormat.url,
    );
    developer.log(image.data[0].toString(), name: "StoryService");
    print(image.data[0].url);
    if (image.data[0].url == null) {
      return "default Url";
    } else {
      return image.data[0].url!;
    }
  }
}
