class FaqItem {
  final String id;
  final String icon;
  final String questionEn;
  final String questionSi;
  final String questionTa;
  final String answerEn;
  final String answerSi;
  final String answerTa;
  final List<String> keywords;

  const FaqItem({
    required this.id,
    required this.icon,
    required this.questionEn,
    required this.questionSi,
    required this.questionTa,
    required this.answerEn,
    required this.answerSi,
    required this.answerTa,
    required this.keywords,
  });
}

class FaqData {
  FaqData._();

  static const String supportPhone = '+94 76 123 4567';
  static const String supportEmail = 'support@vpnexues.com';
  static const String appName = 'VPNexues';

  static const String welcomeTitleEn = 'Hi there! 👋';
  static const String welcomeTitleSi = 'ආයුබෝවන්! 👋';
  static const String welcomeTitleTa = 'வணக்கம்! 👋';
  static const String welcomeSubEn =
      'I\'m your VPNexues assistant. How can I help you today?';
  static const String welcomeSubSi =
      'මම ඔබේ VPNexues සහායකයා. අද මම ඔබට කෙසේ උදව් කළ හැකිද?';
  static const String welcomeSubTa =
      'நான் உங்கள் VPNexues உதவியாளர். இன்று நான் உங்களுக்கு எவ்வாறு உதவ முடியும்?';

  static const String noMatchEn =
      'I couldn\'t find a specific answer for that. Let me connect you with our support team:';
  static const String noMatchSi =
      'ඒ සඳහා මට නිශ්චිත පිළිතුරක් සොයාගත නොහැකි විය. මම ඔබව අපගේ සහාය කණ්ඩායම හා සම්බන්ධ කරමි:';
  static const String noMatchTa =
      'அதற்கு என்னால் குறிப்பிட்ட பதிலைக் கண்டுபிடிக்க முடியவில்லை. எங்கள் ஆதரவு குழுவுடன் இணைக்கிறேன்:';

  static const String contactUsEn = 'Contact Support';
  static const String contactUsSi = 'සහාය අමතන්න';
  static const String contactUsTa = 'ஆதரவைத் தொடர்பு கொள்ளுங்கள்';
  static const String phoneLabelEn = 'Call us';
  static const String phoneLabelSi = 'අප අමතන්න';
  static const String phoneLabelTa = 'எங்களை அழையுங்கள்';
  static const String emailLabelEn = 'Email us';
  static const String emailLabelSi = 'ඊමේල් කරන්න';
  static const String emailLabelTa = 'மின்னஞ்சல் செய்யுங்கள்';

  static const List<FaqItem> faqs = [
    FaqItem(
      id: 'track_order',
      icon: '📦',
      questionEn: 'Where is my order?',
      questionSi: 'මගේ ඇණවුම කොහෙද?',
      questionTa: 'என் ஆர்டர் எங்கே?',
      answerEn:
          'Track your order easily:\n\n'
          '1. Open the Orders tab at the bottom\n'
          '2. See all your orders with live status\n'
          '3. Tap any order for full tracking details\n\n'
          'You\'ll see if it\'s being prepared, out for delivery, or delivered.',
      answerSi:
          'ඔබේ ඇණවුම පහසුවෙන් නිරීක්ෂණය කරන්න:\n\n'
          '1. පහත ඇණවුම් ටැබ් විවෘත කරන්න\n'
          '2. සජීවී තත්ත්වය සමඟ ඔබේ සියලුම ඇණවුම් බලන්න\n'
          '3. සම්පූර්ණ නිරීක්ෂණ විස්තර සඳහා ඕනෑම ඇණවුමක් තට්ටු කරන්න\n\n'
          'එය සකස් කරමින් පවතිනවාද, බෙදාහැරීමට යමින් පවතිනවාද, හෝ බෙදාහැර ඇතිද ඔබට පෙනෙනු ඇත.',
      answerTa:
          'உங்கள் ஆர்டரை எளிதாகக் கண்காணிக்கவும்:\n\n'
          '1. கீழே உள்ள ஆர்டர்கள் தாப்பைத் திறக்கவும்\n'
          '2. நேரடி நிலையுடன் உங்கள் அனைத்து ஆர்டர்களையும் பார்க்கவும்\n'
          '3. முழுமையான கண்காணிப்பு விவரங்களுக்கு எந்த ஆர்டரையும் தட்டவும்\n\n'
          'அது தயாரிக்கப்படுகிறதா, டெலிவரிக்குச் செல்கிறதா, அல்லது டெலிவரி செய்யப்பட்டதா என்பதை நீங்கள் பார்ப்பீர்கள்.',
      keywords: [
        'order', 'track', 'where', 'delivery', 'status', 'my order',
        'ඇණවුම', 'නිරීක්ෂණ', 'කොහෙද', 'බෙදාහැරීම', 'තත්ත්වය',
        'ஆர்டர்', 'கண்காணிப்பு', 'எங்கே', 'டெலிவரி', 'நிலை',
      ],
    ),
    FaqItem(
      id: 'delivery_time',
      icon: '🚚',
      questionEn: 'When will my order arrive?',
      questionSi: 'මගේ ඇණවුම කවදා එනවාද?',
      questionTa: 'என் ஆர்டர் எப்போது வரும்?',
      answerEn:
          'Delivery schedule:\n\n'
          '⏰ Daily: 8:00 AM – 8:00 PM\n\n'
          '• Orders before 2:00 PM → Same day delivery\n'
          '• Orders after 2:00 PM → Next day delivery\n\n'
          'You can pick your preferred time slot during checkout.',
      answerSi:
          'බෙදාහැරීමේ කාලසටහන:\n\n'
          '⏰ සෑම දිනකම: උදෑසන 8:00 – රාත්‍රී 8:00\n\n'
          '• පෙ.ව. 2:00 ට පෙර ඇණවුම් → එම දිනයේම බෙදාහැරීම\n'
          '• පෙ.ව. 2:00 පසු ඇණවුම් → ඊළඟ දිනයේ බෙදාහැරීම\n\n'
          'බිල්පත් තුළ ඔබේ කැමති වේලාව තෝරාගත හැක.',
      answerTa:
          'டெலிவரி அட்டவணை:\n\n'
          '⏰ தினமும்: காலை 8:00 – இரவு 8:00\n\n'
          '• மதியம் 2:00 க்கு முன் ஆர்டர்கள் → அதே நாள் டெலிவரி\n'
          '• மதியம் 2:00 க்குப் பின் ஆர்டர்கள் → அடுத்த நாள் டெலிவரி\n\n'
          'சரிபார்ப்புப் புள்ளியின் போது உங்கள் விருப்பமான நேர இடத்தைத் தேர்வு செய்யலாம்.',
      keywords: [
        'delivery', 'time', 'when', 'arrive', 'reach', 'same day', 'next day',
        'බෙදාහැරීම', 'වේලාව', 'කවදාද', 'එනවා', 'පැමිණෙනවා',
        'டெலிவரி', 'நேரம்', 'எப்போது', 'வரும்', 'சென்றடையும்',
      ],
    ),
    FaqItem(
      id: 'delivery_fee',
      icon: '💰',
      questionEn: 'Do you charge for delivery?',
      questionSi: 'බෙදාහැරීමට මුදල් අය කරනවාද?',
      questionTa: 'டெலிவரிக்கு கட்டணம் வசூலிக்கிறீர்களா?',
      answerEn:
          'Delivery charges:\n\n'
          '✅ Free delivery for orders above Rs. 1,000\n'
          '💳 Rs. 100 delivery fee for orders under Rs. 1,000\n\n'
          'Look out for free delivery promotions!',
      answerSi:
          'බෙදාහැරීමේ ගාස්තු:\n\n'
          '✅ රු. 1,000 ට වැඩි ඇණවුම් සඳහා නොමිලේ\n'
          '💳 රු. 1,000 ට අඩු ඇණවුම් සඳහා රු. 100\n\n'
          'නොමිලේ බෙදාහැරීම් ප්‍රවර්ධන සඳහා බලා සිටින්න!',
      answerTa:
          'டெலிவரி கட்டணங்கள்:\n\n'
          '✅ ₹1,000 க்கு மேல் ஆர்டர்களுக்கு இலவச டெலிவரி\n'
          '💳 ₹1,000 க்குக் குறைவான ஆர்டர்களுக்கு ₹100 டெலிவரி கட்டணம்\n\n'
          'இலவச டெலிவரி விளம்பரங்களுக்கு கவனம் செலுத்துங்கள்!',
      keywords: [
        'delivery', 'fee', 'charge', 'cost', 'free', 'price', 'how much',
        'බෙදාහැරීම', 'ගාස්තුව', 'මිල', 'නොමිලේ', 'කීයද',
        'டெலிவரி', 'கட்டணம்', 'செலவு', 'இலவசம்', 'விலை', 'எவ்வளவு',
      ],
    ),
    FaqItem(
      id: 'payment',
      icon: '💳',
      questionEn: 'How can I pay?',
      questionSi: 'මම ගෙවන්නේ කෙසේද?',
      questionTa: 'நான் எவ்வாறு செலுத்த முடியும்?',
      answerEn:
          'We accept:\n\n'
          '💵 Cash on Delivery (COD)\n'
          '💳 Credit & Debit Cards\n'
          '🏦 Online Bank Transfer\n'
          '📱 Mobile Payment Apps\n\n'
          'All payments are 100% secure.',
      answerSi:
          'අපි පිළිගනිමු:\n\n'
          '💵 බෙදාහැරීමේදී මුදල් (COD)\n'
          '💳 ණය සහ ගෙවුම් කාඩ්\n'
          '🏦 මාර්ගගත බැංකු හුවමාරුව\n'
          '📱 ජංගම ගෙවීම් යෙදුම්\n\n'
          'සියලුම ගෙවීම් 100% ආරක්ෂිතයි.',
      answerTa:
          'நாங்கள் ஏற்கிறோம்:\n\n'
          '💵 டெலிவரியில் பணம் (COD)\n'
          '💳 கிரெடிட் & டெபிட் கார்டுகள்\n'
          '🏦 ஆன்லைன் வங்கி பரிமாற்றம்\n'
          '📱 மொபைல் பணம் செலுத்தும் ஆப்ஸ்\n\n'
          'அனைத்து பணம் செலுத்தல்களும் 100% பாதுகாப்பானவை.',
      keywords: [
        'payment', 'pay', 'cod', 'cash', 'card', 'credit', 'debit', 'method',
        'ගෙවීම', 'මුදල්', 'කාඩ්', 'COD', 'ගෙවන්නේ',
        'பணம்', 'செலுத்து', 'கார்டு', 'கிரெடிட்', 'டெபிட்',
      ],
    ),
    FaqItem(
      id: 'return_refund',
      icon: '🔄',
      questionEn: 'Can I return an item?',
      questionSi: 'මට භාණ්ඩයක් ආපසු දෙන්න පුළුවන්ද?',
      questionTa: 'நான் ஒரு பொருளைத் திரும்பப் பெற முடியுமா?',
      answerEn:
          'Yes! Our return policy:\n\n'
          '📋 Return within 24 hours of delivery\n'
          '✅ Items must be unused & in original packaging\n'
          '💰 Refund in 3-5 business days\n\n'
          'To return: Orders → Select order → Request Return',
      answerSi:
          'ඔව්! අපගේ ආපසු දීමේ ප්‍රතිපත්තිය:\n\n'
          '📋 බෙදාහැරීමෙන් පැය 24 ක් ඇතුළත ආපසු දෙන්න\n'
          '✅ භාණ්ඩ භාවිතා නොකර මුල් ඇසුරුමේ තිබිය යුතුය\n'
          '💰 ව්‍යාපාරික දින 3-5 ක් ඇතුළත මුදල් ආපසු\n\n'
          'ආපසු දීමට: ඇණවුම් → ඇණවුම තෝරන්න → ආපසු දීම ඉල්ලන්න',
      answerTa:
          'ஆம்! எங்கள் திரும்பப் பெறும் கொள்கை:\n\n'
          '📋 டெலிவரி செய்த 24 மணி நேரத்திற்குள் திரும்பப் பெறவும்\n'
          '✅ பொருள்கள் பயன்படுத்தப்படாமல் & அசல் பேக்கேஜிங்கில் இருக்க வேண்டும்\n'
          '💰 3-5 வணிக நாட்களில் பணம் திரும்பப் பெறுதல்\n\n'
          'திரும்பப் பெற: ஆர்டர்கள் → ஆர்டரைத் தேர்ந்தெடுக்கவும் → திரும்பப் பெறுதலைக் கோரவும்',
      keywords: [
        'return', 'refund', 'exchange', 'money back', 'broken', 'wrong',
        'ආපසු', 'මුදල් ආපසු', 'හුවමාරුව', 'කැඩුණු', 'වැරදි',
        'திரும்ப', 'பணம் திரும்ப', 'மாற்றம்', 'உடைந்த', 'தவறான',
      ],
    ),
    FaqItem(
      id: 'cancel_order',
      icon: '❌',
      questionEn: 'How to cancel my order?',
      questionSi: 'මගේ ඇණවුම අවලංගු කරන්නේ කෙසේද?',
      questionTa: 'என் ஆர்டரை எவ்வாறு ரத்து செய்வது?',
      answerEn:
          'Cancel your order in 3 steps:\n\n'
          '1. Go to Orders tab\n'
          '2. Tap on the order\n'
          '3. Press "Cancel Order"\n\n'
          '⚠️ Note: Only orders not yet dispatched can be cancelled.',
      answerSi:
          'ඔබේ ඇණවුම පියවර 3 කින් අවලංගු කරන්න:\n\n'
          '1. ඇණවුම් ටැබ් වෙත යන්න\n'
          '2. ඇණවුම තට්ටු කරන්න\n'
          '3. "ඇණවුම අවලංගු කරන්න" ඔබන්න\n\n'
          '⚠️ සටහන: යවා නැති ඇණවුම් පමණක් අවලංගු කළ හැක.',
      answerTa:
          'உங்கள் ஆர்டரை 3 படிகளில் ரத்து செய்யவும்:\n\n'
          '1. ஆர்டர்கள் தாப்பிற்குச் செல்லவும்\n'
          '2. ஆர்டரைத் தட்டவும்\n'
          '3. "ஆர்டரை ரத்து செய்" என்பதை அழுத்தவும்\n\n'
          '⚠️ குறிப்பு: அனுப்பப்படாத ஆர்டர்கள் மட்டுமே ரத்து செய்யப்படலாம்.',
      keywords: [
        'cancel', 'cancellation', 'stop', 'remove', 'cancel order',
        'අවලංගු', 'නවත්වන්න', 'ඉවත් කරන්න',
        'ரத்து', 'நிறுத்து', 'நீக்கு',
      ],
    ),
    FaqItem(
      id: 'account_help',
      icon: '👤',
      questionEn: 'How to update my profile?',
      questionSi: 'මගේ පැතිකඩ යාවත්කාලීන කරන්නේ කෙසේද?',
      questionTa: 'என் சுயவிவரத்தை எவ்வாறு புதுப்பிப்பது?',
      answerEn:
          'Update your profile:\n\n'
          '1. Go to Profile tab\n'
          '2. Tap the edit icon on your photo\n'
          '3. Update name or phone number\n'
          '4. Save changes\n\n'
          'For addresses: Profile → Addresses → Add or edit',
      answerSi:
          'ඔබේ පැතිකඩ යාවත්කාලීන කරන්න:\n\n'
          '1. පැතිකඩ ටැබ් වෙත යන්න\n'
          '2. ඔබේ ඡායාරූපයේ සංස්කරණ අයිකනය තට්ටු කරන්න\n'
          '3. නම හෝ දුරකථන අංකය යාවත්කාලීන කරන්න\n'
          '4. වෙනස්කම් සුරකින්න\n\n'
          'ලිපින සඳහා: පැතිකඩ → ලිපින → එකතු හෝ සංස්කරණය',
      answerTa:
          'உங்கள் சுயவிவரத்தைப் புதுப்பிக்கவும்:\n\n'
          '1. சுயவிவரம் தாப்பிற்குச் செல்லவும்\n'
          '2. உங்கள் புகைப்படத்தில் உள்ள திருத்த ஐகானைத் தட்டவும்\n'
          '3. பெயர் அல்லது தொலைபேசி எண்ணைப் புதுப்பிக்கவும்\n'
          '4. மாற்றங்களைச் சேமிக்கவும்\n\n'
          'முகவரிகளுக்கு: சுயவிவரம் → முகவரிகள் → சேர் அல்லது திருத்து',
      keywords: [
        'account', 'profile', 'update', 'edit', 'name', 'phone',
        'ගිණුම', 'පැතිකඩ', 'යාවත්කාලීන', 'සංස්කරණය', 'නම',
        'கணக்கு', 'சுயவிவரம்', 'புதுப்பி', 'திருத்து', 'பெயர்',
      ],
    ),
  ];

  static const List<String> quickRepliesEn = [
    '📦 Track Order',
    '🚚 Delivery Time',
    '💰 Delivery Fee',
    '💳 Payment',
    '🔄 Returns',
    '❌ Cancel Order',
    '👤 My Account',
  ];

  static const List<String> quickRepliesSi = [
    '📦 ඇණවුම නිරීක්ෂණය',
    '🚚 බෙදාහැරීමේ වේලාව',
    '💰 බෙදාහැරීමේ ගාස්තුව',
    '💳 ගෙවීම',
    '🔄 ආපසු දීම',
    '❌ ඇණවුම අවලංගු',
    '👤 මගේ ගිණුම',
  ];

  static const List<String> quickRepliesTa = [
    '📦 ஆர்டரைக் கண்காணி',
    '🚚 டெலிவரி நேரம்',
    '💰 டெலிவரி கட்டணம்',
    '💳 பணம் செலுத்துதல்',
    '🔄 திரும்பப் பெறுதல்',
    '❌ ஆர்டரை ரத்து செய்',
    '👤 என் கணக்கு',
  ];
}
