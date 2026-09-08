import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../data/faq_data.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  String _language = 'en'; // 'en', 'si', 'ta'

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  String get language => _language;
  bool get isEnglish => _language == 'en';

  void toggleLanguage() {
    // Cycle: en → si → ta → en
    if (_language == 'en') {
      _language = 'si';
    } else if (_language == 'si') {
      _language = 'ta';
    } else {
      _language = 'en';
    }
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void initChat() {
    if (_messages.isNotEmpty) return;

    String title;
    String sub;
    switch (_language) {
      case 'si':
        title = FaqData.welcomeTitleSi;
        sub = FaqData.welcomeSubSi;
        break;
      case 'ta':
        title = FaqData.welcomeTitleTa;
        sub = FaqData.welcomeSubTa;
        break;
      default:
        title = FaqData.welcomeTitleEn;
        sub = FaqData.welcomeSubEn;
    }

    _messages.add(ChatMessage(
      id: 'greeting',
      text: '$title\n$sub',
      sender: MessageSender.bot,
      type: MessageType.greeting,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  List<String> get quickReplies {
    switch (_language) {
      case 'si':
        return FaqData.quickRepliesSi;
      case 'ta':
        return FaqData.quickRepliesTa;
      default:
        return FaqData.quickRepliesEn;
    }
  }

  void sendMessage(String text) {
    _messages.add(ChatMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      sender: MessageSender.user,
      type: MessageType.text,
      timestamp: DateTime.now(),
    ));
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 600), () {
      _processMessage(text);
    });
  }

  void _processMessage(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    // Remove emoji prefix from quick replies for matching
    final cleanMessage = lowerMessage.replaceAll(RegExp(r'[^\w\s]'), '').trim();

    FaqItem? bestMatch;
    int bestScore = 0;

    for (final faq in FaqData.faqs) {
      int score = 0;
      for (final keyword in faq.keywords) {
        if (cleanMessage.contains(keyword.toLowerCase()) ||
            lowerMessage.contains(keyword.toLowerCase())) {
          score++;
        }
      }
      // Exact question match gets bonus
      if (cleanMessage.contains(faq.questionEn.toLowerCase()) ||
          lowerMessage.contains(faq.questionEn.toLowerCase())) {
        score += 3;
      }
      if (score > bestScore) {
        bestScore = score;
        bestMatch = faq;
      }
    }

    if (bestMatch != null && bestScore > 0) {
      String answer;
      switch (_language) {
        case 'si':
          answer = bestMatch.answerSi;
          break;
        case 'ta':
          answer = bestMatch.answerTa;
          break;
        default:
          answer = bestMatch.answerEn;
      }
      _messages.add(ChatMessage(
        id: 'faq_${DateTime.now().millisecondsSinceEpoch}',
        text: answer,
        sender: MessageSender.bot,
        type: MessageType.faq,
        timestamp: DateTime.now(),
      ));
    } else {
      String noMatch;
      String phoneLabel;
      String emailLabel;
      switch (_language) {
        case 'si':
          noMatch = FaqData.noMatchSi;
          phoneLabel = FaqData.phoneLabelSi;
          emailLabel = FaqData.emailLabelSi;
          break;
        case 'ta':
          noMatch = FaqData.noMatchTa;
          phoneLabel = FaqData.phoneLabelTa;
          emailLabel = FaqData.emailLabelTa;
          break;
        default:
          noMatch = FaqData.noMatchEn;
          phoneLabel = FaqData.phoneLabelEn;
          emailLabel = FaqData.emailLabelEn;
      }

      final contactText = '$noMatch\n\n'
          '📞 $phoneLabel: ${FaqData.supportPhone}\n'
          '✉️ $emailLabel: ${FaqData.supportEmail}';

      _messages.add(ChatMessage(
        id: 'contact_${DateTime.now().millisecondsSinceEpoch}',
        text: contactText,
        sender: MessageSender.bot,
        type: MessageType.contact,
        timestamp: DateTime.now(),
      ));
    }
    notifyListeners();
  }
}
