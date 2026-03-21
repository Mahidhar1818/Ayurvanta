import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String emoji;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.emoji,
  });
}

class LanguageService extends ChangeNotifier {
  static const _keyLang = 'selected_language';
  static const _keyLangSet = 'language_set';

  String _currentCode = 'en';
  String get currentCode => _currentCode;

  // All Indian languages
  static const languages = [
    AppLanguage(
        code: 'en',
        name: 'English',
        nativeName: 'English',
        emoji: '🇬🇧'),
    AppLanguage(
        code: 'hi',
        name: 'Hindi',
        nativeName: 'हिन्दी',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'te',
        name: 'Telugu',
        nativeName: 'తెలుగు',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'ta',
        name: 'Tamil',
        nativeName: 'தமிழ்',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'kn',
        name: 'Kannada',
        nativeName: 'ಕನ್ನಡ',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'ml',
        name: 'Malayalam',
        nativeName: 'മലയാളം',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'mr',
        name: 'Marathi',
        nativeName: 'मराठी',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'bn',
        name: 'Bengali',
        nativeName: 'বাংলা',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'gu',
        name: 'Gujarati',
        nativeName: 'ગુજરાતી',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'pa',
        name: 'Punjabi',
        nativeName: 'ਪੰਜਾਬੀ',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'or',
        name: 'Odia',
        nativeName: 'ଓଡ଼ିଆ',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'as',
        name: 'Assamese',
        nativeName: 'অসমীয়া',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'ur',
        name: 'Urdu',
        nativeName: 'اردو',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'sa',
        name: 'Sanskrit',
        nativeName: 'संस्कृतम्',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'kok',
        name: 'Konkani',
        nativeName: 'कोंकणी',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'mai',
        name: 'Maithili',
        nativeName: 'मैथिली',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'mni',
        name: 'Manipuri',
        nativeName: 'মৈতৈলোন্',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'ne',
        name: 'Nepali',
        nativeName: 'नेपाली',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'si',
        name: 'Sindhi',
        nativeName: 'سنڌي',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'ks',
        name: 'Kashmiri',
        nativeName: 'कॉशुर',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'doi',
        name: 'Dogri',
        nativeName: 'डोगरी',
        emoji: '🇮🇳'),
    AppLanguage(
        code: 'sat',
        name: 'Santali',
        nativeName: 'ᱥᱟᱱᱛᱟᱲᱤ',
        emoji: '🇮🇳'),
  ];

  // Translations map
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'home': 'Home',
      'records': 'Records',
      'chat': 'Chat',
      'orders': 'Orders',
      'profile': 'Profile',
      'good_morning': 'Good morning,',
      'search_hint': 'Search doctors, medicines, tests...',
      'emergency_sos': 'Emergency SOS',
      'emergency_sub': 'Tap for immediate help',
      'quick_access': 'Quick Access',
      'book_appt': 'Book Appt',
      'medicines': 'Medicines',
      'lab_tests': 'Lab Tests',
      'ai_doctor': 'AI Doctor',
      'upcoming_appt': 'Upcoming Appointment',
      'health_summary': 'Health Summary',
      'recent_records': 'Recent Records',
      'find_doctor': 'Find a Doctor',
      'pharmacy': 'Pharmacy',
      'my_profile': 'My Profile',
      'nearby_hospitals': 'Nearby Hospitals',
      'confirmed': 'Confirmed',
      'normal': 'Normal',
      'borderline': 'Borderline',
    },
    'hi': {
      'home': 'होम',
      'records': 'रिकॉर्ड',
      'chat': 'चैट',
      'orders': 'ऑर्डर',
      'profile': 'प्रोफ़ाइल',
      'good_morning': 'सुप्रभात,',
      'search_hint': 'डॉक्टर, दवाएं, टेस्ट खोजें...',
      'emergency_sos': 'आपातकालीन SOS',
      'emergency_sub': 'तुरंत मदद के लिए टैप करें',
      'quick_access': 'त्वरित पहुँच',
      'book_appt': 'अपॉइंटमेंट',
      'medicines': 'दवाएं',
      'lab_tests': 'लैब टेस्ट',
      'ai_doctor': 'AI डॉक्टर',
      'upcoming_appt': 'आगामी अपॉइंटमेंट',
      'health_summary': 'स्वास्थ्य सारांश',
      'recent_records': 'हाल के रिकॉर्ड',
      'find_doctor': 'डॉक्टर खोजें',
      'pharmacy': 'फार्मेसी',
      'my_profile': 'मेरी प्रोफ़ाइल',
      'nearby_hospitals': 'नजदीकी अस्पताल',
      'confirmed': 'पुष्टि',
      'normal': 'सामान्य',
      'borderline': 'सीमारेखा',
    },
    'te': {
      'home': 'హోమ్',
      'records': 'రికార్డులు',
      'chat': 'చాట్',
      'orders': 'ఆర్డర్లు',
      'profile': 'ప్రొఫైల్',
      'good_morning': 'శుభోదయం,',
      'search_hint': 'డాక్టర్లు, మందులు వెతకండి...',
      'emergency_sos': 'అత్యవసర SOS',
      'emergency_sub': 'వెంటనే సహాయం కోసం నొక్కండి',
      'quick_access': 'త్వరిత యాక్సెస్',
      'book_appt': 'అపాయింట్మెంట్',
      'medicines': 'మందులు',
      'lab_tests': 'లాబ్ పరీక్షలు',
      'ai_doctor': 'AI డాక్టర్',
      'upcoming_appt': 'రాబోయే అపాయింట్మెంట్',
      'health_summary': 'ఆరోగ్య సారాంశం',
      'recent_records': 'ఇటీవలి రికార్డులు',
      'find_doctor': 'డాక్టర్ వెతకండి',
      'pharmacy': 'ఫార్మసీ',
      'my_profile': 'నా ప్రొఫైల్',
      'nearby_hospitals': 'సమీప ఆసుపత్రులు',
      'confirmed': 'నిర్ధారించబడింది',
      'normal': 'సాధారణ',
      'borderline': 'సరిహద్దు',
    },
    'ta': {
      'home': 'முகப்பு',
      'records': 'பதிவுகள்',
      'chat': 'அரட்டை',
      'orders': 'ஆர்டர்கள்',
      'profile': 'சுயவிவரம்',
      'good_morning': 'காலை வணக்கம்,',
      'search_hint': 'மருத்துவர், மருந்துகள் தேடுங்கள்...',
      'emergency_sos': 'அவசர SOS',
      'emergency_sub': 'உடனடி உதவிக்கு தட்டவும்',
      'quick_access': 'விரைவு அணுகல்',
      'book_appt': 'நியமனம்',
      'medicines': 'மருந்துகள்',
      'lab_tests': 'ஆய்வக சோதனைகள்',
      'ai_doctor': 'AI மருத்துவர்',
      'upcoming_appt': 'வரவிருக்கும் நியமனம்',
      'health_summary': 'சுகாதார சுருக்கம்',
      'recent_records': 'சமீபத்திய பதிவுகள்',
      'find_doctor': 'மருத்துவர் தேடுங்கள்',
      'pharmacy': 'மருந்தகம்',
      'my_profile': 'என் சுயவிவரம்',
      'nearby_hospitals': 'அருகிலுள்ள மருத்துவமனைகள்',
      'confirmed': 'உறுதிப்படுத்தப்பட்டது',
      'normal': 'சாதாரண',
      'borderline': 'எல்லைரேகை',
    },
    'kn': {
      'home': 'ಮನೆ',
      'records': 'ದಾಖಲೆಗಳು',
      'chat': 'ಚಾಟ್',
      'orders': 'ಆದೇಶಗಳು',
      'profile': 'ಪ್ರೊಫೈಲ್',
      'good_morning': 'ಶುಭೋದಯ,',
      'search_hint': 'ವೈದ್ಯರು, ಔಷಧಿಗಳನ್ನು ಹುಡುಕಿ...',
      'emergency_sos': 'ತುರ್ತು SOS',
      'emergency_sub': 'ತಕ್ಷಣ ಸಹಾಯಕ್ಕಾಗಿ ಟ್ಯಾಪ್ ಮಾಡಿ',
      'quick_access': 'ತ್ವರಿತ ಪ್ರವೇಶ',
      'book_appt': 'ಅಪಾಯಿಂಟ್ಮೆಂಟ್',
      'medicines': 'ಔಷಧಿಗಳು',
      'lab_tests': 'ಲ್ಯಾಬ್ ಪರೀಕ್ಷೆಗಳು',
      'ai_doctor': 'AI ವೈದ್ಯ',
      'upcoming_appt': 'ಮುಂಬರುವ ಅಪಾಯಿಂಟ್ಮೆಂಟ್',
      'health_summary': 'ಆರೋಗ್ಯ ಸಾರಾಂಶ',
      'recent_records': 'ಇತ್ತೀಚಿನ ದಾಖಲೆಗಳು',
      'find_doctor': 'ವೈದ್ಯರನ್ನು ಹುಡುಕಿ',
      'pharmacy': 'ಫಾರ್ಮಸಿ',
      'my_profile': 'ನನ್ನ ಪ್ರೊಫೈಲ್',
      'nearby_hospitals': 'ಹತ್ತಿರದ ಆಸ್ಪತ್ರೆಗಳು',
      'confirmed': 'ದೃಢಪಡಿಸಲಾಗಿದೆ',
      'normal': 'ಸಾಮಾನ್ಯ',
      'borderline': 'ಗಡಿರೇಖೆ',
    },
    'ml': {
      'home': 'ഹോം',
      'records': 'രേഖകൾ',
      'chat': 'ചാറ്റ്',
      'orders': 'ഓർഡറുകൾ',
      'profile': 'പ്രൊഫൈൽ',
      'good_morning': 'സുപ്രഭാതം,',
      'search_hint': 'ഡോക്ടർ, മരുന്നുകൾ തിരയുക...',
      'emergency_sos': 'അടിയന്തര SOS',
      'emergency_sub': 'ഉടനടി സഹായത്തിന് ടാപ്പ് ചെയ്യുക',
      'quick_access': 'ദ്രുത ആക്സസ്',
      'book_appt': 'അപ്പോയിന്റ്മെന്റ്',
      'medicines': 'മരുന്നുകൾ',
      'lab_tests': 'ലാബ് പരിശോധനകൾ',
      'ai_doctor': 'AI ഡോക്ടർ',
      'upcoming_appt': 'വരാനിരിക്കുന്ന അപ്പോയിന്റ്മെന്റ്',
      'health_summary': 'ആരോഗ്യ സംഗ്രഹം',
      'recent_records': 'സമീപകാല രേഖകൾ',
      'find_doctor': 'ഡോക്ടറെ കണ്ടെത്തുക',
      'pharmacy': 'ഫാർമസി',
      'my_profile': 'എന്റെ പ്രൊഫൈൽ',
      'nearby_hospitals': 'സമീപത്തുള്ള ആശുപത്രികൾ',
      'confirmed': 'സ്ഥിരീകരിച്ചു',
      'normal': 'സാധാരണ',
      'borderline': 'അതിർത്തിരേഖ',
    },
    'mr': {
      'home': 'मुख्यपृष्ठ',
      'records': 'नोंदी',
      'chat': 'चॅट',
      'orders': 'ऑर्डर',
      'profile': 'प्रोफाइल',
      'good_morning': 'शुभ प्रभात,',
      'search_hint': 'डॉक्टर, औषधे शोधा...',
      'emergency_sos': 'आणीबाणी SOS',
      'emergency_sub': 'तात्काळ मदतीसाठी टॅप करा',
      'quick_access': 'जलद प्रवेश',
      'book_appt': 'अपॉइंटमेंट',
      'medicines': 'औषधे',
      'lab_tests': 'लॅब चाचण्या',
      'ai_doctor': 'AI डॉक्टर',
      'upcoming_appt': 'आगामी भेट',
      'health_summary': 'आरोग्य सारांश',
      'recent_records': 'अलीकडील नोंदी',
      'find_doctor': 'डॉक्टर शोधा',
      'pharmacy': 'फार्मसी',
      'my_profile': 'माझी प्रोफाइल',
      'nearby_hospitals': 'जवळील रुग्णालये',
      'confirmed': 'पुष्टी केली',
      'normal': 'सामान्य',
      'borderline': 'सीमारेषा',
    },
    'bn': {
      'home': 'হোম',
      'records': 'রেকর্ড',
      'chat': 'চ্যাট',
      'orders': 'অর্ডার',
      'profile': 'প্রোফাইল',
      'good_morning': 'শুভ সকাল,',
      'search_hint': 'ডাক্তার, ওষুধ খুঁজুন...',
      'emergency_sos': 'জরুরি SOS',
      'emergency_sub': 'তাৎক্ষণিক সাহায্যের জন্য ট্যাপ করুন',
      'quick_access': 'দ্রুত অ্যাক্সেস',
      'book_appt': 'অ্যাপয়েন্টমেন্ট',
      'medicines': 'ওষুধ',
      'lab_tests': 'ল্যাব পরীক্ষা',
      'ai_doctor': 'AI ডাক্তার',
      'upcoming_appt': 'আসন্ন অ্যাপয়েন্টমেন্ট',
      'health_summary': 'স্বাস্থ্য সারসংক্ষেপ',
      'recent_records': 'সাম্প্রতিক রেকর্ড',
      'find_doctor': 'ডাক্তার খুঁজুন',
      'pharmacy': 'ফার্মেসি',
      'my_profile': 'আমার প্রোফাইল',
      'nearby_hospitals': 'কাছের হাসপাতাল',
      'confirmed': 'নিশ্চিত',
      'normal': 'স্বাভাবিক',
      'borderline': 'সীমারেখা',
    },
  };

  // Get translation
  String translate(String key) {
    final langMap = _translations[_currentCode];
    if (langMap == null) return _translations['en']![key] ?? key;
    return langMap[key] ?? _translations['en']![key] ?? key;
  }

  // Load saved language
  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentCode = prefs.getString(_keyLang) ?? 'en';
    notifyListeners();
  }

  // Check if language already selected
  static Future<bool> isLanguageSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLangSet) ?? false;
  }

  // Save language selection
  Future<void> setLanguage(String code) async {
    _currentCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLang, code);
    await prefs.setBool(_keyLangSet, true);
    notifyListeners();
  }
}
