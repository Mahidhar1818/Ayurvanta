import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';

// ═══════════════════════════════════════════════════════════
//  DIET DATA — Fully multilingual
// ═══════════════════════════════════════════════════════════

class DietItem {
  final Map<String, String> name; // lang -> name
  final Map<String, String> description;
  final Map<String, List<String>> nutrients;
  final Map<String, List<String>> benefits;
  final Map<String, List<String>> dishes;
  final String emoji;
  final String category;
  final Color color;
  final Color bgColor;
  final String icmrNote;

  const DietItem({
    required this.name, required this.description,
    required this.nutrients, required this.benefits,
    required this.dishes, required this.emoji,
    required this.category, required this.color,
    required this.bgColor, required this.icmrNote,
  });
}

// ── All diet items with translations ─────────────────────
final List<DietItem> allDiets = [

  DietItem(
    emoji: '🥦', category: 'Vegetables', color: const Color(0xFF0F6E56),
    bgColor: const Color(0xFFE1F5EE), icmrNote: 'ICMR: 3–5 servings/day',
    name: {
      'en': 'Green Leafy Vegetables',
      'te': 'ఆకు కూరలు',
      'hi': 'हरी पत्तेदार सब्जियां',
      'ta': 'கீரை வகைகள்',
      'mr': 'हिरव्या पालेभाज्या',
      'kn': 'ಸೊಪ್ಪು ತರಕಾರಿಗಳು',
      'ml': 'ഇലക്കറികൾ',
      'bn': 'সবুজ শাকসবজি',
      'pa': 'ਹਰੀਆਂ ਸਬਜ਼ੀਆਂ',
      'gu': 'લીલાં પાંદડાવાળી શાકભાજી',
    },
    description: {
      'en': 'Spinach, methi, drumstick leaves, moringa — superfoods for immunity and blood health.',
      'te': 'పాలకూర, మెంతికూర, మునగాకు — రోగ నిరోధకత మరియు రక్త ఆరోగ్యానికి అత్యుత్తమ ఆహారాలు.',
      'hi': 'पालक, मेथी, सहजन की पत्तियां — रोग प्रतिरोधक क्षमता और रक्त स्वास्थ्य के लिए सुपरफूड।',
      'ta': 'கீரை, வெந்தயக் கீரை, முருங்கைக் கீரை — நோய் எதிர்ப்பு மற்றும் இரத்த ஆரோக்கியத்திற்கு சிறந்தது.',
      'mr': 'पालक, मेथी, शेवग्याची पाने — प्रतिकारशक्ती आणि रक्त आरोग्यासाठी सुपरफूड.',
      'kn': 'ಪಾಲಕ್, ಮೆಂತ್ಯ, ನುಗ್ಗೆ ಸೊಪ್ಪು — ರೋಗ ನಿರೋಧಕ ಶಕ್ತಿ ಮತ್ತು ರಕ್ತ ಆರೋಗ್ಯಕ್ಕೆ ಉತ್ತಮ.',
      'ml': 'ചീര, ഉലുവ, മുരിങ്ങ ഇല — രോഗ പ്രതിരോധ ശേഷിക്കും രക്ത ആരോഗ്യത്തിനും ഉത്തമം.',
      'bn': 'পালং শাক, মেথি, সজনে পাতা — রোগ প্রতিরোধ ও রক্ত স্বাস্থ্যের জন্য সুপারফুড।',
      'pa': 'ਪਾਲਕ, ਮੇਥੀ, ਸਹਿਜਣ ਦੇ ਪੱਤੇ — ਇਮਿਊਨਿਟੀ ਅਤੇ ਖੂਨ ਦੀ ਸਿਹਤ ਲਈ ਸੁਪਰਫੂਡ।',
      'gu': 'પાલક, મેથી, સહજનનાં પાંદડાં — રોગ પ્રતિકારક શક્તિ અને લોહીના સ્વાસ્થ્ય માટે.',
    },
    nutrients: {
      'en': ['Iron', 'Folate', 'Vitamin K', 'Vitamin C', 'Calcium', 'Beta-carotene'],
      'te': ['ఐరన్', 'ఫోలేట్', 'విటమిన్ K', 'విటమిన్ C', 'కాల్షియం', 'బీటా-కెరోటిన్'],
      'hi': ['आयरन', 'फोलेट', 'विटामिन K', 'विटामिन C', 'कैल्शियम', 'बीटा-कैरोटीन'],
      'ta': ['இரும்பு', 'ஃபோலேட்', 'வைட்டமின் K', 'வைட்டமின் C', 'கால்சியம்'],
      'mr': ['लोह', 'फोलेट', 'व्हिटॅमिन K', 'व्हिटॅमिन C', 'कॅल्शियम'],
      'kn': ['ಕಬ್ಬಿಣ', 'ಫೋಲೇಟ್', 'ವಿಟಮಿನ್ K', 'ವಿಟಮಿನ್ C', 'ಕ್ಯಾಲ್ಸಿಯಂ'],
      'ml': ['ഇരുമ്പ്', 'ഫോളേറ്റ്', 'വിറ്റാമിൻ K', 'വിറ്റാമിൻ C', 'കാൽസ്യം'],
      'bn': ['আয়রন', 'ফোলেট', 'ভিটামিন K', 'ভিটামিন C', 'ক্যালসিয়াম'],
      'pa': ['ਆਇਰਨ', 'ਫੋਲੇਟ', 'ਵਿਟਾਮਿਨ K', 'ਵਿਟਾਮਿਨ C', 'ਕੈਲਸ਼ੀਅਮ'],
      'gu': ['આયર્ન', 'ફોલેટ', 'વિટામિન K', 'વિટામિન C', 'કેલ્શિયમ'],
    },
    benefits: {
      'en': ['Prevents anaemia', 'Boosts immunity', 'Strong bones', 'Eye health', 'Anti-cancer'],
      'te': ['రక్తహీనతను నివారిస్తుంది', 'రోగ నిరోధకతను పెంచుతుంది', 'బలమైన ఎముకలు', 'కంటి ఆరోగ్యం'],
      'hi': ['एनीमिया रोकता है', 'रोग प्रतिरोधक क्षमता बढ़ाता है', 'मजबूत हड्डियां', 'आंखों की सेहत'],
      'ta': ['இரத்த சோகையை தடுக்கிறது', 'நோய் எதிர்ப்பை அதிகரிக்கிறது', 'வலுவான எலும்புகள்'],
      'mr': ['अशक्तपणा रोखतो', 'रोगप्रतिकारशक्ती वाढवतो', 'मजबूत हाडे', 'डोळ्यांची काळजी'],
      'kn': ['ರಕ್ತಹೀನತೆ ತಡೆಯುತ್ತದೆ', 'ರೋಗ ನಿರೋಧಕ ಶಕ್ತಿ ಹೆಚ್ಚಿಸುತ್ತದೆ', 'ಕಣ್ಣಿನ ಆರೋಗ್ಯ'],
      'ml': ['വിളർച്ച തടയുന്നു', 'രോഗ പ്രതിരോധ ശേഷി കൂട്ടുന്നു', 'കണ്ണിന്റെ ആരോഗ്യം'],
      'bn': ['রক্তাল্পতা প্রতিরোধ', 'রোগ প্রতিরোধ ক্ষমতা বাড়ায়', 'শক্তিশালী হাড়'],
      'pa': ['ਅਨੀਮੀਆ ਰੋਕਦਾ ਹੈ', 'ਇਮਿਊਨਿਟੀ ਵਧਾਉਂਦਾ ਹੈ', 'ਮਜ਼ਬੂਤ ਹੱਡੀਆਂ'],
      'gu': ['એનીમિયા અટકાવે છે', 'રોગ પ્રતિકારક શક્તિ વધારે છે', 'હાડકાં મજબૂત'],
    },
    dishes: {
      'en': ['Palak dal', 'Methi paratha', 'Drumstick sambar', 'Spinach curry', 'Moringa soup'],
      'te': ['పాలకూర పప్పు', 'మెంతికూర పరోటా', 'మునగ సాంబార్', 'పాలకూర కూర', 'మునగాకు సూప్'],
      'hi': ['पालक दाल', 'मेथी परांठा', 'सहजन सांभर', 'पालक सब्जी', 'मोरिंगा सूप'],
      'ta': ['பாலக் பருப்பு', 'வெந்தய பரோட்டா', 'முருங்கை சாம்பார்', 'கீரை கறி'],
      'mr': ['पालक वरण', 'मेथी पराठा', 'शेवगा सांभर', 'पालक भाजी'],
      'kn': ['ಪಾಲಕ್ ದಾಲ್', 'ಮೆಂತ್ಯ ಪರೋಟಾ', 'ನುಗ್ಗೆ ಸಾಂಬಾರ್', 'ಪಾಲಕ್ ಪಲ್ಯ'],
      'ml': ['പാലക്ക് പരിപ്പ്', 'മുതിര പരോട്ട', 'മുരിങ്ങ സാമ്പാർ', 'ചീര കറി'],
      'bn': ['পালং ডাল', 'মেথি পরোটা', 'সজনে সাম্বার', 'পালং তরকারি'],
      'pa': ['ਪਾਲਕ ਦਾਲ', 'ਮੇਥੀ ਪਰਾਂਠਾ', 'ਸਹਿਜਣ ਸਾਂਭਰ', 'ਪਾਲਕ ਸਬਜ਼ੀ'],
      'gu': ['પાલક દાળ', 'મેથીના પરોઠા', 'સહજન સામ્બાર', 'પાલક શાક'],
    },
  ),

  DietItem(
    emoji: '🌾', category: 'Cereals & Millets', color: const Color(0xFFBA7517),
    bgColor: const Color(0xFFFAEEDA), icmrNote: 'ICMR: 6–11 servings/day',
    name: {
      'en': 'Millets & Whole Grains',
      'te': 'చిరుధాన్యాలు & తృణధాన్యాలు',
      'hi': 'मिलेट और साबुत अनाज',
      'ta': 'சிறுதானியங்கள் & முழு தானியங்கள்',
      'mr': 'ज्वारी-बाजरी आणि संपूर्ण धान्य',
      'kn': 'ರಾಗಿ & ಸಂಪೂರ್ಣ ಧಾನ್ಯ',
      'ml': 'ചെറുധാന്യങ്ങളും ധാന്യങ്ങളും',
      'bn': 'ছোট শস্য ও আস্ত শস্য',
      'pa': 'ਮਿਲੇਟ ਅਤੇ ਸਾਬਤ ਅਨਾਜ',
      'gu': 'બાજરી, જુવાર અને આખા અનાજ',
    },
    description: {
      'en': 'Ragi, bajra, jowar, brown rice, oats — low GI, high fibre supergrains endorsed by ICMR.',
      'te': 'రాగి, సజ్జ, జొన్న, బ్రౌన్ రైస్, ఓట్స్ — తక్కువ GI, అధిక ఫైబర్ సూపర్ గ్రెయిన్స్.',
      'hi': 'रागी, बाजरा, ज्वार, ब्राउन राइस, ओट्स — कम GI, उच्च फाइबर वाले सुपरग्रेन।',
      'ta': 'ராகி, கம்பு, சோளம், பழுப்பு அரிசி, ஓட்ஸ் — குறைந்த GI, அதிக நார்சத்து கொண்டவை.',
      'mr': 'नाचणी, बाजरी, ज्वारी, तपकिरी तांदूळ, ओट्स — कमी GI, जास्त तंतू असलेले सुपरग्रेन.',
      'kn': 'ರಾಗಿ, ಸಜ್ಜೆ, ಜೋಳ, ಕಂದು ಅಕ್ಕಿ, ಓಟ್ಸ್ — ಕಡಿಮೆ GI, ಹೆಚ್ಚು ನಾರಿನಂಶ.',
      'ml': 'റാഗി, ബജ്ര, ജ്വാർ, തവിടുകളഞ്ഞ അരി, ഓട്സ് — കുറഞ്ഞ GI, കൂടുതൽ നാരുകൾ.',
      'bn': 'রাগি, বাজরা, জোয়ার, বাদামি চাল, ওটস — কম GI, বেশি আঁশযুক্ত সুপারগ্রেইন।',
      'pa': 'ਰਾਗੀ, ਬਾਜਰਾ, ਜੁਆਰ, ਭੂਰਾ ਚਾਵਲ, ਓਟਸ — ਘੱਟ GI, ਵੱਧ ਫਾਈਬਰ ਵਾਲੇ ਸੁਪਰਗ੍ਰੇਨ।',
      'gu': 'રાગી, બાજરો, જુવાર, બ્રાઉન રાઇસ, ઓટ્સ — ઓછો GI, વધુ ફાઇબર.',
    },
    nutrients: {
      'en': ['Complex carbs', 'Dietary fibre', 'Calcium (ragi)', 'Iron', 'B-vitamins', 'Magnesium'],
      'te': ['కాంప్లెక్స్ కార్బ్స్', 'ఆహార ఫైబర్', 'కాల్షియం (రాగి)', 'ఐరన్', 'B-విటమిన్లు'],
      'hi': ['जटिल कार्बोहाइड्रेट', 'आहार फाइबर', 'कैल्शियम (रागी)', 'आयरन', 'B-विटामिन'],
      'ta': ['கார்போஹைட்ரேட்', 'நார்சத்து', 'கால்சியம் (ராகி)', 'இரும்பு', 'B-வைட்டமின்'],
      'mr': ['जटिल कार्बोहायड्रेट', 'आहार तंतू', 'कॅल्शियम', 'लोह', 'B-व्हिटॅमिन'],
      'kn': ['ಸಂಕೀರ್ಣ ಕಾರ್ಬ್', 'ಆಹಾರ ನಾರು', 'ಕ್ಯಾಲ್ಸಿಯಂ', 'ಕಬ್ಬಿಣ'],
      'ml': ['കോംപ്ലക്സ് കാർബ്', 'നാരുകൾ', 'കാൽസ്യം', 'ഇരുമ്പ്'],
      'bn': ['জটিল কার্বোহাইড্রেট', 'আঁশ', 'ক্যালসিয়াম', 'আয়রন'],
      'pa': ['ਕੰਪਲੈਕਸ ਕਾਰਬ', 'ਫਾਈਬਰ', 'ਕੈਲਸ਼ੀਅਮ', 'ਆਇਰਨ'],
      'gu': ['કોમ્પ્લેક્સ કાર્બ', 'ફાઇબર', 'કેલ્શિયમ', 'આયર્ન'],
    },
    benefits: {
      'en': ['Controls blood sugar', 'Lowers cholesterol', 'Sustained energy', 'Gut health', 'Weight management'],
      'te': ['రక్తంలో చక్కెరను నియంత్రిస్తుంది', 'కొలెస్ట్రాల్ తగ్గిస్తుంది', 'దీర్ఘకాలిక శక్తి', 'జీర్ణ ఆరోగ్యం'],
      'hi': ['ब्लड शुगर नियंत्रित करता है', 'कोलेस्ट्रॉल कम करता है', 'लंबे समय तक ऊर्जा', 'पाचन स्वास्थ्य'],
      'ta': ['இரத்த சர்க்கரை கட்டுப்படுத்துகிறது', 'கொழுப்பை குறைக்கிறது', 'நீடித்த ஆற்றல்'],
      'mr': ['रक्तातील साखर नियंत्रित करतो', 'कोलेस्टेरॉल कमी करतो', 'दीर्घकाळ ऊर्जा'],
      'kn': ['ರಕ್ತದ ಸಕ್ಕರೆ ನಿಯಂತ್ರಣ', 'ಕೊಲೆಸ್ಟ್ರಾಲ್ ಕಡಿಮೆ', 'ದೀರ್ಘ ಶಕ್ತಿ'],
      'ml': ['രക്തത്തിലെ പഞ്ചസാര നിയന്ത്രണം', 'കൊളസ്ട്രോൾ കുറക്കുന്നു', 'ദീർഘ ഊർജം'],
      'bn': ['রক্তের সুগার নিয়ন্ত্রণ', 'কোলেস্টেরল কমায়', 'দীর্ঘস্থায়ী শক্তি'],
      'pa': ['ਬਲੱਡ ਸ਼ੂਗਰ ਕੰਟਰੋਲ', 'ਕੋਲੈਸਟਰੋਲ ਘਟਾਉਂਦਾ', 'ਲੰਮੇ ਸਮੇਂ ਤੱਕ ਊਰਜਾ'],
      'gu': ['બ્લડ સુગર નિયંત્રણ', 'કોલેસ્ટ્રોલ ઘટાડે', 'ટકાઉ ઊર્જા'],
    },
    dishes: {
      'en': ['Ragi mudde', 'Bajra roti', 'Jowar bhakri', 'Oats upma', 'Millet khichdi', 'Ragi dosa'],
      'te': ['రాగి ముద్ద', 'సజ్జ రొట్టె', 'జొన్న రొట్టె', 'ఓట్స్ ఉప్మా', 'రాగి దోస'],
      'hi': ['रागी मुद्दे', 'बाजरा रोटी', 'ज्वार भाकरी', 'ओट्स उपमा', 'बाजरा खिचड़ी'],
      'ta': ['ராகி களி', 'கம்பு ரொட்டி', 'சோள ரொட்டி', 'ஓட்ஸ் உப்புமா', 'ராகி தோசை'],
      'mr': ['नाचणी मुद्दे', 'बाजरी भाकरी', 'ज्वारी भाकरी', 'ओट्स उपमा'],
      'kn': ['ರಾಗಿ ಮುದ್ದೆ', 'ಸಜ್ಜೆ ರೊಟ್ಟಿ', 'ಜೋಳದ ರೊಟ್ಟಿ', 'ರಾಗಿ ದೋಸೆ'],
      'ml': ['റാഗി മുദ്ദ', 'ബജ്ര റൊട്ടി', 'ഓട്സ് ഉപ്പുമ', 'റാഗി ദോശ'],
      'bn': ['রাগি মুদ্দে', 'বাজরার রুটি', 'জোয়ারের রুটি', 'ওটস উপমা'],
      'pa': ['ਰਾਗੀ ਮੁੱਦੇ', 'ਬਾਜਰੇ ਦੀ ਰੋਟੀ', 'ਜੁਆਰ ਭਾਕਰੀ', 'ਓਟਸ ਉਪਮਾ'],
      'gu': ['રાગી મુદ્દ', 'બાજરાની રોટલી', 'જુવારની ભાખરી', 'ઓટ્સ ઉપ્મા'],
    },
  ),

  DietItem(
    emoji: '🫘', category: 'Pulses & Legumes', color: const Color(0xFF185FA5),
    bgColor: const Color(0xFFE6F1FB), icmrNote: 'ICMR: 2–3 servings/day',
    name: {
      'en': 'Pulses, Dal & Legumes',
      'te': 'పప్పు, కాయధాన్యాలు',
      'hi': 'दालें और फलियां',
      'ta': 'பருப்பு வகைகள்',
      'mr': 'डाळी आणि शेंगा',
      'kn': 'ಬೇಳೆ ಮತ್ತು ದ್ವಿದಳ ಧಾನ್ಯ',
      'ml': 'പരിപ്പ് ഇനങ്ങൾ',
      'bn': 'ডাল ও শুঁটি',
      'pa': 'ਦਾਲਾਂ ਅਤੇ ਫਲੀਆਂ',
      'gu': 'કઠોળ અને દાળ',
    },
    description: {
      'en': 'Masoor, moong, chana, rajma, toor dal — India\'s richest plant protein sources, endorsed by NIN.',
      'te': 'మసూర్, మూంగ్, చనా, రాజ్మా, కందిపప్పు — భారతదేశంలో అత్యుత్తమ మొక్కల ప్రోటీన్ మూలాలు.',
      'hi': 'मसूर, मूंग, चना, राजमा, तूर दाल — भारत के सबसे अच्छे वनस्पति प्रोटीन स्रोत।',
      'ta': 'மசூர், பாசிப் பயிறு, கொண்டைக்கடலை, ராஜ்மா — தாவர புரதத்தின் சிறந்த மூலங்கள்.',
      'mr': 'मसूर, मूग, चणे, राजमा, तूर — भारतातील सर्वोत्तम वनस्पती प्रथिन स्रोत.',
      'kn': 'ಮಸೂರ, ಹೆಸರು, ಕಡಲೆ, ರಾಜ್ಮಾ, ತೊಗರಿ — ಭಾರತದ ಅತ್ಯುತ್ತಮ ಸಸ್ಯ ಪ್ರೋಟೀನ್ ಮೂಲಗಳು.',
      'ml': 'മസൂർ, ചെറുപയർ, കടല, രാജ്മ — ഭാരതത്തിലെ ഏറ്റവും ഉത്തമ സസ്യ പ്രോട്ടീൻ.',
      'bn': 'মসুর, মুগ, ছোলা, রাজমা — ভারতের সেরা উদ্ভিদ প্রোটিনের উৎস।',
      'pa': 'ਮਸਰ, ਮੂੰਗ, ਛੋਲੇ, ਰਾਜਮਾ — ਭਾਰਤ ਦੇ ਸਭ ਤੋਂ ਵਧੀਆ ਪੌਦੇ ਪ੍ਰੋਟੀਨ ਸਰੋਤ।',
      'gu': 'મસૂર, મગ, ચણા, રાજ્મ — ભારતનો શ્રેષ્ઠ વનસ્પતિ પ્રોટીન સ્ત્રોત.',
    },
    nutrients: {
      'en': ['Plant protein', 'Dietary fibre', 'Folate', 'Iron', 'Potassium', 'Zinc', 'Slow carbs'],
      'te': ['మొక్కల ప్రోటీన్', 'ఆహార ఫైబర్', 'ఫోలేట్', 'ఐరన్', 'పొటాషియం', 'జింక్'],
      'hi': ['वनस्पति प्रोटीन', 'आहार फाइबर', 'फोलेट', 'आयरन', 'पोटैशियम', 'जिंक'],
      'ta': ['தாவர புரதம்', 'நார்சத்து', 'ஃபோலேட்', 'இரும்பு', 'பொட்டாசியம்'],
      'mr': ['वनस्पती प्रथिन', 'तंतू', 'फोलेट', 'लोह', 'पोटॅशियम'],
      'kn': ['ಸಸ್ಯ ಪ್ರೋಟೀನ್', 'ನಾರು', 'ಫೋಲೇಟ್', 'ಕಬ್ಬಿಣ'],
      'ml': ['സസ്യ പ്രോട്ടീൻ', 'നാരുകൾ', 'ഫോളേറ്റ്', 'ഇരുമ്പ്'],
      'bn': ['উদ্ভিদ প্রোটিন', 'আঁশ', 'ফোলেট', 'আয়রন'],
      'pa': ['ਪੌਦਾ ਪ੍ਰੋਟੀਨ', 'ਫਾਈਬਰ', 'ਫੋਲੇਟ', 'ਆਇਰਨ'],
      'gu': ['વનસ્પતિ પ્રોટીન', 'ફાઇબર', 'ફોલેટ', 'આયર્ન'],
    },
    benefits: {
      'en': ['Muscle building', 'Heart health', 'Diabetes control', 'Digestive health', 'Pregnancy nutrition'],
      'te': ['కండరాల అభివృద్ధి', 'గుండె ఆరోగ్యం', 'మధుమేహ నియంత్రణ', 'జీర్ణ ఆరోగ్యం'],
      'hi': ['मांसपेशी निर्माण', 'हृदय स्वास्थ्य', 'मधुमेह नियंत्रण', 'पाचन स्वास्थ्य'],
      'ta': ['தசை வளர்ச்சி', 'இதய ஆரோக்கியம்', 'சர்க்கரை கட்டுப்பாடு'],
      'mr': ['स्नायू निर्मिती', 'हृदयाचे आरोग्य', 'मधुमेह नियंत्रण'],
      'kn': ['ಮಾಂಸಖಂಡ ನಿರ್ಮಾಣ', 'ಹೃದಯ ಆರೋಗ್ಯ', 'ಮಧುಮೇಹ ನಿಯಂತ್ರಣ'],
      'ml': ['മസിൽ ഉണ്ടാക്കൽ', 'ഹൃദയ ആരോഗ്യം', 'പ്രമേഹ നിയന്ത്രണം'],
      'bn': ['পেশী গঠন', 'হৃদয় স্বাস্থ্য', 'ডায়াবেটিস নিয়ন্ত্রণ'],
      'pa': ['ਮਾਸਪੇਸ਼ੀ ਨਿਰਮਾਣ', 'ਦਿਲ ਦੀ ਸਿਹਤ', 'ਸ਼ੂਗਰ ਕੰਟਰੋਲ'],
      'gu': ['સ્નાયુ નિર્માણ', 'હૃદય સ્વાસ્થ્ય', 'ડાયાબિટીસ નિયંત્રણ'],
    },
    dishes: {
      'en': ['Masoor dal', 'Chana masala', 'Rajma chawal', 'Moong dal cheela', 'Dal makhani', 'Sambar'],
      'te': ['మసూర్ పప్పు', 'చనా మసాలా', 'రాజ్మా చావల్', 'మూంగ్ దాల్ చీలా', 'సాంబార్'],
      'hi': ['मसूर दाल', 'छोले मसाला', 'राजमा चावल', 'मूंग दाल चीला', 'दाल मखनी'],
      'ta': ['பருப்பு', 'சோல மசாலா', 'ராஜ்மா சாதம்', 'பாசிப் பருப்பு தோசை', 'சாம்பார்'],
      'mr': ['मसूर वरण', 'छोले मसाला', 'राजमा भात', 'मूग डाळ चिला', 'सांभर'],
      'kn': ['ಮಸೂರ ದಾಲ್', 'ಕಡಲೆ ಮಸಾಲ', 'ರಾಜ್ಮಾ ಅನ್ನ', 'ಮುಳ್ಳು ದಾಲ್ ಚೀಲ', 'ಸಾಂಬಾರ್'],
      'ml': ['മസൂർ പരിപ്പ്', 'ചോളെ മസാല', 'രാജ്മ ചോറ്', 'സാമ്പാർ'],
      'bn': ['মসুর ডাল', 'ছোলার মাসালা', 'রাজমা ভাত', 'মুগ ডালের চিলা', 'সাম্বার'],
      'pa': ['ਮਸਰ ਦਾਲ', 'ਛੋਲੇ ਮਸਾਲਾ', 'ਰਾਜਮਾ ਚਾਵਲ', 'ਦਾਲ ਮਖਣੀ'],
      'gu': ['મસૂર દાળ', 'છોળે મસાલ', 'રાજ્મ ભાત', 'ઢોકળા', 'સામ્બાર'],
    },
  ),

  DietItem(
    emoji: '🍎', category: 'Fruits', color: const Color(0xFFD85A30),
    bgColor: const Color(0xFFFAECE7), icmrNote: 'ICMR: 2–3 servings/day',
    name: {
      'en': 'Seasonal Fruits',
      'te': 'సీజనల్ పండ్లు',
      'hi': 'मौसमी फल',
      'ta': 'பருவகால பழங்கள்',
      'mr': 'हंगामी फळे',
      'kn': 'ಋತುವಿನ ಹಣ್ಣುಗಳು',
      'ml': 'സീസണൽ പഴങ്ങൾ',
      'bn': 'মৌসুমি ফল',
      'pa': 'ਮੌਸਮੀ ਫਲ',
      'gu': 'મોસમી ફળ',
    },
    description: {
      'en': 'Guava, papaya, banana, amla, mango, citrus — eat seasonal local fruits for maximum nutrients.',
      'te': 'జామ, బొప్పాయి, అరటి, ఉసిరి, మామిడి — గరిష్ట పోషకాల కోసం స్థానిక పండ్లు తినండి.',
      'hi': 'अमरूद, पपीता, केला, आंवला, आम, खट्टे फल — अधिकतम पोषण के लिए मौसमी फल खाएं।',
      'ta': 'கொய்யா, பப்பாயா, வாழைப்பழம், நெல்லி, மாம்பழம் — அதிகமான ஊட்டச்சத்துக்கு மக்கள் உணவு.',
      'mr': 'पेरू, पपई, केळे, आवळे, आंबा — जास्त पोषणासाठी हंगामी फळे खा.',
      'kn': 'ಸೀಬೆ, ಪಪ್ಪಾಯ, ಬಾಳೆ, ನೆಲ್ಲಿ, ಮಾವು — ಗರಿಷ್ಠ ಪೋಷಣೆಗೆ ಋತು ಹಣ್ಣು ತಿನ್ನಿ.',
      'ml': 'പേര, പപ്പായ, വാഴപ്പഴം, നെല്ലി, മാമ്പഴം — ഏറ്റവും കൂടുതൽ പോഷകത്തിന് ഇടനൽ ഫലങ്ങൾ.',
      'bn': 'পেয়ারা, পেঁপে, কলা, আমলকী, আম — সর্বোচ্চ পুষ্টির জন্য মৌসুমি ফল।',
      'pa': 'ਅਮਰੂਦ, ਪਪੀਤਾ, ਕੇਲਾ, ਆਂਵਲਾ, ਅੰਬ — ਵੱਧ ਤੋਂ ਵੱਧ ਪੋਸ਼ਣ ਲਈ ਮੌਸਮੀ ਫਲ।',
      'gu': 'જામફળ, પપૈયા, કેળ, આમળા, કેરી — સૌથી વધુ પોષણ માટે સ્થાનિક ફળ.',
    },
    nutrients: {
      'en': ['Vitamin C', 'Potassium', 'Natural sugars', 'Antioxidants', 'Soluble fibre', 'Vitamin A'],
      'te': ['విటమిన్ C', 'పొటాషియం', 'ప్రకృతి చక్కెర', 'యాంటీఆక్సిడెంట్లు', 'కరిగే ఫైబర్'],
      'hi': ['विटामिन C', 'पोटैशियम', 'प्राकृतिक शर्करा', 'एंटीऑक्सीडेंट', 'घुलनशील फाइबर'],
      'ta': ['வைட்டமின் C', 'பொட்டாசியம்', 'இயற்கை சர்க்கரை', 'ஆன்டி-ஆக்சிடன்ட்'],
      'mr': ['व्हिटॅमिन C', 'पोटॅशियम', 'नैसर्गिक साखर', 'अँटिऑक्सिडंट'],
      'kn': ['ವಿಟಮಿನ್ C', 'ಪೊಟ್ಯಾಸಿಯಂ', 'ನೈಸರ್ಗಿಕ ಸಕ್ಕರೆ', 'ಆಂಟಿಆಕ್ಸಿಡೆಂಟ್'],
      'ml': ['വിറ്റാമിൻ C', 'പൊട്ടാസ്യം', 'ഫ്ലേവനോയ്ഡ്', 'ആന്റി ഓക്സിഡന്റ്'],
      'bn': ['ভিটামিন C', 'পটাশিয়াম', 'প্রাকৃতিক চিনি', 'অ্যান্টিঅক্সিডেন্ট'],
      'pa': ['ਵਿਟਾਮਿਨ C', 'ਪੋਟਾਸ਼ੀਅਮ', 'ਕੁਦਰਤੀ ਸ਼ੱਕਰ', 'ਐਂਟੀਆਕਸੀਡੈਂਟ'],
      'gu': ['વિટામિન C', 'પોટેશ્યમ', 'કુદરતી ખાંડ', 'ઍન્ટીઑક્સિડેન્ટ'],
    },
    benefits: {
      'en': ['Immunity boost', 'Skin health', 'Heart health', 'Prevents cancer', 'Blood pressure control'],
      'te': ['రోగ నిరోధకత', 'చర్మ ఆరోగ్యం', 'గుండె ఆరోగ్యం', 'క్యాన్సర్ నివారణ'],
      'hi': ['रोग प्रतिरोधक क्षमता', 'त्वचा का स्वास्थ्य', 'हृदय स्वास्थ्य', 'कैंसर से बचाव'],
      'ta': ['நோய் எதிர்ப்பு', 'சரும ஆரோக்கியம்', 'இதய ஆரோக்கியம்'],
      'mr': ['रोगप्रतिकारशक्ती', 'त्वचेचे आरोग्य', 'हृदयाचे आरोग्य'],
      'kn': ['ರೋಗ ನಿರೋಧಕ ಶಕ್ತಿ', 'ಚರ್ಮದ ಆರೋಗ್ಯ', 'ಹೃದಯ ಆರೋಗ್ಯ'],
      'ml': ['രോഗ പ്രതിരോധം', 'ചർമ ആരോഗ്യം', 'ഹൃദയ ആരോഗ്യം'],
      'bn': ['রোগ প্রতিরোধ', 'ত্বকের স্বাস্থ্য', 'হৃদয় স্বাস্থ্য'],
      'pa': ['ਇਮਿਊਨਿਟੀ', 'ਚਮੜੀ ਦੀ ਸਿਹਤ', 'ਦਿਲ ਦੀ ਸਿਹਤ'],
      'gu': ['ઈમ્યુનિટી', 'ત્વચા આરોગ્ય', 'હૃદય આરોગ્ય'],
    },
    dishes: {
      'en': ['Amla juice', 'Papaya salad', 'Banana lassi', 'Guava with salt-chilli', 'Mango smoothie', 'Fruit chaat'],
      'te': ['ఉసిరి జూస్', 'బొప్పాయి సలాడ్', 'అరటి లస్సీ', 'జామ పండు', 'మామిడి స్మూతీ', 'ఫ్రూట్ చాట్'],
      'hi': ['आंवला जूस', 'पपीता सलाद', 'केला लस्सी', 'अमरूद', 'आम की स्मूदी', 'फ्रूट चाट'],
      'ta': ['நெல்லி சாறு', 'பப்பாயா சாலட்', 'வாழைப்பழ லஸ்ஸி', 'கொய்யா', 'மாம்பழ ஸ்மூதி'],
      'mr': ['आवळा रस', 'पपई सलाद', 'केळे लस्सी', 'पेरू', 'आंबा स्मूदी'],
      'kn': ['ನೆಲ್ಲಿ ಜ್ಯೂಸ್', 'ಪಪ್ಪಾಯ ಸಲಾಡ್', 'ಬಾಳೆ ಲಸ್ಸಿ', 'ಮಾವಿನ ಸ್ಮೂತಿ'],
      'ml': ['നെല്ലിക്ക ജ്യൂസ്', 'പപ്പായ സലഡ്', 'വാഴപ്പഴ ലസ്സി', 'മാങ്ങ സ്മൂതി'],
      'bn': ['আমলকী রস', 'পেঁপে সালাদ', 'কলার লাচ্ছি', 'আমের স্মুদি'],
      'pa': ['ਆਂਵਲੇ ਦਾ ਜੂਸ', 'ਪਪੀਤੇ ਦਾ ਸਲਾਦ', 'ਕੇਲੇ ਦੀ ਲੱਸੀ', 'ਅੰਬ ਸਮੂਦੀ'],
      'gu': ['આમળા જ્યૂસ', 'પપૈયા સલાડ', 'કેળ લસ્સી', 'કેરી સ્મૂધી'],
    },
  ),

  DietItem(
    emoji: '🥛', category: 'Dairy', color: const Color(0xFF534AB7),
    bgColor: const Color(0xFFEEEDFE), icmrNote: 'ICMR: 2–3 servings/day',
    name: {
      'en': 'Dairy & Fermented Foods',
      'te': 'పాల ఉత్పత్తులు & పులిసిన ఆహారాలు',
      'hi': 'डेयरी और किण्वित खाद्य पदार्थ',
      'ta': 'பால் பொருட்கள் & புளித்த உணவுகள்',
      'mr': 'दुग्धजन्य पदार्थ आणि आंबवलेले खाद्यपदार्थ',
      'kn': 'ಡೈರಿ & ಹುಳಿಯಾದ ಆಹಾರ',
      'ml': 'ക്ഷീര ഉൽപ്പന്നങ്ങൾ & പുളിപ്പിച്ചത്',
      'bn': 'দুগ্ধজাত ও গাঁজনো খাবার',
      'pa': 'ਡੇਅਰੀ ਅਤੇ ਫਰਮੈਂਟਡ ਖਾਣੇ',
      'gu': 'ડેરી અને આથો આવ્યો ખોરાક',
    },
    description: {
      'en': 'Curd, buttermilk, paneer, milk — India\'s traditional fermented dairy is probiotic powerhouse.',
      'te': 'పెరుగు, మజ్జిగ, పనీర్, పాలు — భారత సంప్రదాయ పులిసిన పాల ఉత్పత్తులు ప్రోబయోటిక్ శక్తి.',
      'hi': 'दही, छाछ, पनीर, दूध — भारतीय किण्वित डेयरी एक प्रोबायोटिक पावरहाउस है।',
      'ta': 'தயிர், மோர், பனீர், பால் — இந்திய புளித்த பால் உணவுகள் புரோபயோடிக் சக்திகூடம்.',
      'mr': 'दही, ताक, पनीर, दूध — भारतीय आंबवलेली डेयरी प्रोबायोटिक शक्ती.',
      'kn': 'ಮೊಸರು, ಮಜ್ಜಿಗೆ, ಪನೀರ್, ಹಾಲು — ಭಾರತದ ಸಾಂಪ್ರದಾಯಿಕ ಡೈರಿ ಪ್ರೋಬಯೋಟಿಕ್.',
      'ml': 'തൈര്, മോര്, പനീർ, പാൽ — ഭാരതത്തിന്റെ പ്രോബയോട്ടിക് ഭക്ഷണം.',
      'bn': 'দই, ঘোল, পনির, দুধ — ভারতীয় গাঁজনো ডেয়ারি প্রোবায়োটিক শক্তিঘর।',
      'pa': 'ਦਹੀ, ਲੱਸੀ, ਪਨੀਰ, ਦੁੱਧ — ਭਾਰਤੀ ਫਰਮੈਂਟਡ ਡੇਅਰੀ ਪ੍ਰੋਬਾਇਓਟਿਕ ਤਾਕਤ।',
      'gu': 'દહીં, છાશ, પનીર, દૂધ — ભારતીય આથો ડેરી પ્રોબાયોટિક.',
    },
    nutrients: {
      'en': ['Calcium', 'Protein', 'Vitamin B12', 'Vitamin D', 'Probiotics', 'Phosphorus'],
      'te': ['కాల్షియం', 'ప్రోటీన్', 'విటమిన్ B12', 'విటమిన్ D', 'ప్రోబయోటిక్స్'],
      'hi': ['कैल्शियम', 'प्रोटीन', 'विटामिन B12', 'विटामिन D', 'प्रोबायोटिक्स'],
      'ta': ['கால்சியம்', 'புரதம்', 'வைட்டமின் B12', 'வைட்டமின் D', 'புரோபயோடிக்'],
      'mr': ['कॅल्शियम', 'प्रथिन', 'व्हिटॅमिन B12', 'व्हिटॅमिन D', 'प्रोबायोटिक्स'],
      'kn': ['ಕ್ಯಾಲ್ಸಿಯಂ', 'ಪ್ರೋಟೀನ್', 'ವಿಟಮಿನ್ B12', 'ಪ್ರೋಬಯೋಟಿಕ್'],
      'ml': ['കാൽസ്യം', 'പ്രോട്ടീൻ', 'വിറ്റാമിൻ B12', 'പ്രോബയോട്ടിക്'],
      'bn': ['ক্যালসিয়াম', 'প্রোটিন', 'ভিটামিন B12', 'প্রোবায়োটিক'],
      'pa': ['ਕੈਲਸ਼ੀਅਮ', 'ਪ੍ਰੋਟੀਨ', 'ਵਿਟਾਮਿਨ B12', 'ਪ੍ਰੋਬਾਇਓਟਿਕਸ'],
      'gu': ['કેલ્શિયમ', 'પ્રોટીન', 'વિટામિન B12', 'પ્રોબાયોટિક'],
    },
    benefits: {
      'en': ['Strong bones', 'Gut microbiome', 'Muscle recovery', 'Nerve health', 'Weight management'],
      'te': ['బలమైన ఎముకలు', 'గట్ మైక్రోబయోమ్', 'కండర పునరుద్ధరణ', 'నరాల ఆరోగ్యం'],
      'hi': ['मजबूत हड्डियां', 'आंत माइक्रोबायोम', 'मांसपेशियों की रिकवरी', 'तंत्रिका स्वास्थ्य'],
      'ta': ['வலுவான எலும்புகள்', 'குடல் ஆரோக்கியம்', 'தசை குணமாதல்'],
      'mr': ['मजबूत हाडे', 'आतड्याचे आरोग्य', 'स्नायू पुनर्प्राप्ती'],
      'kn': ['ಬಲಿಷ್ಠ ಮೂಳೆ', 'ಕರುಳಿನ ಆರೋಗ್ಯ', 'ಮಾಂಸಖಂಡ ಚೇತರಿಕೆ'],
      'ml': ['ശക്തമായ അസ്ഥികൾ', 'കുടൽ ആരോഗ്യം', 'മസിൽ ശക്തി'],
      'bn': ['শক্তিশালী হাড়', 'অন্ত্রের স্বাস্থ্য', 'পেশী পুনরুদ্ধার'],
      'pa': ['ਮਜ਼ਬੂਤ ਹੱਡੀਆਂ', 'ਅੰਤੜੀ ਦੀ ਸਿਹਤ', 'ਮਾਸਪੇਸ਼ੀ ਰਿਕਵਰੀ'],
      'gu': ['મજ઼બૂત હાડકાં', 'આંતરડા આરોગ્ય', 'સ્નાયુ પુનઃ પ્રાપ્તિ'],
    },
    dishes: {
      'en': ['Curd rice', 'Raita', 'Buttermilk (chaas)', 'Paneer bhurji', 'Lassi', 'Dahi vada'],
      'te': ['పెరుగు అన్నం', 'రాయితా', 'మజ్జిగ', 'పనీర్ భుర్జి', 'లస్సీ', 'దహి వడ'],
      'hi': ['दही चावल', 'रायता', 'छाछ', 'पनीर भुर्जी', 'लस्सी', 'दही वड़ा'],
      'ta': ['தயிர் சாதம்', 'ரைதா', 'மோர்', 'பனீர் புர்ஜி', 'லஸ்ஸி'],
      'mr': ['दही भात', 'रायता', 'ताक', 'पनीर भुर्जी', 'लस्सी'],
      'kn': ['ಮೊಸರನ್ನ', 'ರಾಯತಾ', 'ಮಜ್ಜಿಗೆ', 'ಪನೀರ್ ಭುರ್ಜಿ', 'ಲಸ್ಸಿ'],
      'ml': ['തൈര് ചോറ്', 'റൈത്ത', 'മോര്', 'പനീർ ഭുർജി', 'ലസ്സി'],
      'bn': ['দই ভাত', 'রায়তা', 'ঘোল', 'পনির ভুর্জি', 'লাচ্ছি'],
      'pa': ['ਦਹੀ ਚਾਵਲ', 'ਰਾਇਤਾ', 'ਲੱਸੀ', 'ਪਨੀਰ ਭੁਰਜੀ', 'ਦਹੀ ਭੱਲੇ'],
      'gu': ['દહીં ભાત', 'રાઇતું', 'છાશ', 'પનીર ભૂર્જી', 'લસ્સી'],
    },
  ),

  DietItem(
    emoji: '🐟', category: 'Protein', color: const Color(0xFF0F6E56),
    bgColor: const Color(0xFFE1F5EE), icmrNote: 'ICMR: 1–2 servings/day',
    name: {
      'en': 'Fish, Eggs & Lean Protein',
      'te': 'చేప, గుడ్లు & లీన్ ప్రోటీన్',
      'hi': 'मछली, अंडे और लीन प्रोटीन',
      'ta': 'மீன், முட்டை & மெல்லிய புரதம்',
      'mr': 'मासे, अंडी आणि दुबळे प्रथिन',
      'kn': 'ಮೀನು, ಮೊಟ್ಟೆ & ನೇರ ಪ್ರೋಟೀನ್',
      'ml': 'മത്സ്യം, മുട്ട & മെലിഞ്ഞ പ്രോട്ടീൻ',
      'bn': 'মাছ, ডিম ও চর্বিহীন প্রোটিন',
      'pa': 'ਮੱਛੀ, ਅੰਡੇ ਅਤੇ ਲੀਨ ਪ੍ਰੋਟੀਨ',
      'gu': 'માછলી, ઈંડા અને દુ઼બળો પ્રોટીન',
    },
    description: {
      'en': 'Rohu, pomfret, sardines, eggs, chicken — complete amino acids with omega-3 fatty acids for brain and heart.',
      'te': 'రోహు, పంఫ్రెట్, సార్డైన్లు, గుడ్లు — పూర్తి అమినో యాసిడ్స్ మరియు ఒమేగా-3 కొవ్వు ఆమ్లాలు.',
      'hi': 'रोहू, पंपरेट, सार्डिन, अंडे, चिकन — ओमेगा-3 के साथ पूरे अमीनो एसिड।',
      'ta': 'ரோஹு, பாம்பரெட், இல்லை, முட்டை — ஒமேகா-3 கொழுப்பு அமிலங்களுடன் அமினோ அமிலங்கள்.',
      'mr': 'रोहू, पांपलेट, सार्डिन, अंडी — ओमेगा-3 असलेले संपूर्ण अमिनो आम्ल.',
      'kn': 'ರೋಹು, ಪಾಂಫ್ರೆಟ್, ಸಾರ್ಡಿನ್, ಮೊಟ್ಟೆ — ಒಮೇಗಾ-3 ಕೊಬ್ಬಿನ ಆಮ್ಲಗಳು.',
      'ml': 'റോഹൂ, പൊംഫ്രെറ്റ്, ഇലക്ക, മുട്ട — ഒമേഗ-3 ഫാറ്റി ആസിഡ്.',
      'bn': 'রুই, পাঙাস, ইলিশ, ডিম — ওমেগা-৩ সহ সম্পূর্ণ অ্যামিনো অ্যাসিড।',
      'pa': 'ਰੋਹੂ, ਪੰਪਲੇਟ, ਸਾਰਡੀਨ, ਅੰਡੇ — ਓਮੇਗਾ-3 ਦੇ ਨਾਲ ਪੂਰੇ ਅਮੀਨੋ ਐਸਿਡ।',
      'gu': 'રોહુ, પોમ્ફ્રેટ, ઈલ, ઈંડા — ઓમેગા-3 ફેટી એસિડ.',
    },
    nutrients: {
      'en': ['Complete protein', 'Omega-3 fatty acids', 'Vitamin D', 'Vitamin B12', 'Iodine', 'Zinc', 'Selenium'],
      'te': ['పూర్తి ప్రోటీన్', 'ఒమేగా-3 కొవ్వు ఆమ్లాలు', 'విటమిన్ D', 'విటమిన్ B12', 'అయోడిన్'],
      'hi': ['पूर्ण प्रोटीन', 'ओमेगा-3 फैटी एसिड', 'विटामिन D', 'विटामिन B12', 'आयोडीन'],
      'ta': ['முழு புரதம்', 'ஒமேகா-3 கொழுப்பு', 'வைட்டமின் D', 'வைட்டமின் B12'],
      'mr': ['संपूर्ण प्रथिन', 'ओमेगा-3 फॅटी आम्ल', 'व्हिटॅमिन D', 'आयोडीन'],
      'kn': ['ಸಂಪೂರ್ಣ ಪ್ರೋಟೀನ್', 'ಒಮೇಗಾ-3', 'ವಿಟಮಿನ್ D', 'ಆಯೋಡಿನ್'],
      'ml': ['പൂർണ പ്രോട്ടീൻ', 'ഒമേഗ-3', 'വിറ്റാമിൻ D', 'അയഡിൻ'],
      'bn': ['সম্পূর্ণ প্রোটিন', 'ওমেগা-৩', 'ভিটামিন D', 'আয়োডিন'],
      'pa': ['ਪੂਰਨ ਪ੍ਰੋਟੀਨ', 'ਓਮੇਗਾ-3', 'ਵਿਟਾਮਿਨ D', 'ਆਇਓਡੀਨ'],
      'gu': ['સંપૂર્ણ પ્રોટીન', 'ઓમેગા-3', 'વિટામિન D', 'આઈઓડિન'],
    },
    benefits: {
      'en': ['Brain development', 'Heart health', 'Muscle growth', 'Eye health', 'Thyroid function', 'Anti-inflammatory'],
      'te': ['మెదడు అభివృద్ధి', 'గుండె ఆరోగ్యం', 'కండర వృద్ధి', 'కంటి ఆరోగ్యం'],
      'hi': ['मस्तिष्क विकास', 'हृदय स्वास्थ्य', 'मांसपेशी वृद्धि', 'आंखों का स्वास्थ्य'],
      'ta': ['மூளை வளர்ச்சி', 'இதய ஆரோக்கியம்', 'தசை வளர்ச்சி'],
      'mr': ['मेंदूचा विकास', 'हृदयाचे आरोग्य', 'स्नायूंची वाढ'],
      'kn': ['ಮೆದುಳಿನ ಬೆಳವಣಿಗೆ', 'ಹೃದಯ ಆರೋಗ್ಯ', 'ಮಾಂಸಖಂಡ ಬೆಳವಣಿಗೆ'],
      'ml': ['മസ്തിഷ്ക വികസനം', 'ഹൃദയ ആരോഗ്യം', 'മസ്കൽ വളർച്ച'],
      'bn': ['মস্তিষ্কের বিকাশ', 'হৃদয় স্বাস্থ্য', 'পেশী বৃদ্ধি'],
      'pa': ['ਦਿਮਾਗ਼ ਦਾ ਵਿਕਾਸ', 'ਦਿਲ ਦੀ ਸਿਹਤ', 'ਮਾਸਪੇਸ਼ੀ ਵਾਧਾ'],
      'gu': ['મગજ વિકાસ', 'હૃદય આરોગ્ય', 'સ્નાયુ વૃદ્ધિ'],
    },
    dishes: {
      'en': ['Fish curry', 'Egg bhurji', 'Grilled fish', 'Boiled egg salad', 'Fish biryani', 'Omelette'],
      'te': ['చేప కూర', 'గుడ్డు భుర్జీ', 'గ్రిల్డ్ ఫిష్', 'ఉడికించిన గుడ్డు సలాడ్', 'ఫిష్ బిర్యాని'],
      'hi': ['मछली करी', 'अंडा भुर्जी', 'ग्रिल्ड मछली', 'उबला अंडा सलाद', 'मछली बिरयानी'],
      'ta': ['மீன் குழம்பு', 'முட்டை புர்ஜி', 'மீன் வறுவல்', 'வேகவைத்த முட்டை சாலட்'],
      'mr': ['माशाची करी', 'अंडा भुर्जी', 'मासे तळलेले', 'उकडलेल्या अंड्याचे सलाड'],
      'kn': ['ಮೀನು ಸಾರು', 'ಮೊಟ್ಟೆ ಭುರ್ಜಿ', 'ಗ್ರಿಲ್ಡ್ ಮೀನು', 'ಮೊಟ್ಟೆ ಸಲಾಡ್'],
      'ml': ['മത്സ്യ കറി', 'മുട്ട ഭുർജി', 'ഗ്രിൽഡ് ഫിഷ്', 'വേവിച്ച മുട്ട സലഡ്'],
      'bn': ['মাছের ঝোল', 'ডিম ভুর্জি', 'মাছ ভাজা', 'সেদ্ধ ডিমের সালাদ'],
      'pa': ['ਮੱਛੀ ਕੜੀ', 'ਅੰਡਾ ਭੁਰਜੀ', 'ਗ੍ਰਿੱਲਡ ਮੱਛੀ', 'ਉਬਲੇ ਅੰਡੇ ਸਲਾਦ'],
      'gu': ['માછલી કઢ઼ી', 'ઈંડા ભૂર્જી', 'ગ્રિલ્ડ ફિશ', 'ઉકળ્યા ઈંડા સૅલ઼ડ'],
    },
  ),

  DietItem(
    emoji: '🫒', category: 'Healthy Fats', color: const Color(0xFF3B6D11),
    bgColor: const Color(0xFFEAF3DE), icmrNote: 'ICMR: 3–4 tsp oil + handful nuts',
    name: {
      'en': 'Nuts, Seeds & Healthy Oils',
      'te': 'గింజలు, విత్తనాలు & ఆరోగ్యకరమైన నూనెలు',
      'hi': 'मेवे, बीज और स्वस्थ तेल',
      'ta': 'கொட்டைகள், விதைகள் & ஆரோக்கிய எண்ணெய்கள்',
      'mr': 'सुकामेवा, बिया आणि निरोगी तेले',
      'kn': 'ಒಣ ಹಣ್ಣು, ಬೀಜ & ಆರೋಗ್ಯಕರ ತೈಲ',
      'ml': 'നട്സ്, വിത്തുകൾ & ആരോഗ്യകരമായ എണ്ണ',
      'bn': 'বাদাম, বীজ ও স্বাস্থ্যকর তেল',
      'pa': 'ਮੇਵੇ, ਬੀਜ ਅਤੇ ਸਿਹਤਮੰਦ ਤੇਲ',
      'gu': 'ડ્રાયફ્રૂટ, બીજ અને તંદુ઼રસ્ત તેલ',
    },
    description: {
      'en': 'Almonds, walnuts, flaxseeds, sesame, groundnut oil, mustard oil — essential fats from traditional Indian sources.',
      'te': 'బాదం, వాల్నట్, అవిసె గింజలు, నువ్వులు, వేరుసెనగ నూనె — సాంప్రదాయ భారతీయ మూలాల నుండి అవసరమైన కొవ్వులు.',
      'hi': 'बादाम, अखरोट, अलसी, तिल, मूंगफली का तेल — पारंपरिक भारतीय स्रोतों से आवश्यक वसा।',
      'ta': 'பாதாம், வால்நட், ஆளி விதை, எள், நிலக்கடலை எண்ணெய் — தேவையான கொழுப்புகள்.',
      'mr': 'बदाम, अक्रोड, जवस, तीळ, शेंगदाणा तेल — आवश्यक चरबी.',
      'kn': 'ಬಾದಾಮಿ, ವಾಲ್ನಟ್, ಅಗಸೆ, ಎಳ್ಳು, ಕಡಲೆ ಎಣ್ಣೆ — ಅವಶ್ಯಕ ಕೊಬ್ಬುಗಳು.',
      'ml': 'ബദാം, വാൽനട്ട്, ചണ്ണ, എള്ള്, നിലക്കടല എണ്ണ — ആവശ്യ കൊഴുപ്പുകൾ.',
      'bn': 'বাদাম, আখরোট, তিসি, তিল, চিনাবাদাম তেল — প্রয়োজনীয় চর্বি।',
      'pa': 'ਬਦਾਮ, ਅਖਰੋਟ, ਅਲਸੀ, ਤਿਲ, ਮੂੰਗਫਲੀ ਦਾ ਤੇਲ — ਜ਼ਰੂਰੀ ਚਰਬੀ।',
      'gu': 'બદામ, અખ઼રોટ, અળસી, તળ, સ઼ੁmm̀ñ, ĵ ʰ-³êcੀ, ñ ਤੇਲ.',
    },
    nutrients: {
      'en': ['Omega-3 & Omega-6', 'Vitamin E', 'Magnesium', 'Selenium', 'Phytosterols', 'Monounsaturated fats'],
      'te': ['ఒమేగా-3 & ఒమేగా-6', 'విటమిన్ E', 'మెగ్నీషియం', 'సెలీనియం'],
      'hi': ['ओमेगा-3 और ओमेगा-6', 'विटामिन E', 'मैग्नीशियम', 'सेलेनियम'],
      'ta': ['ஒமேகா-3 & ஒமேகா-6', 'வைட்டமின் E', 'மெக்னீசியம்'],
      'mr': ['ओमेगा-3 आणि ओमेगा-6', 'व्हिटॅमिन E', 'मॅग्नेशियम'],
      'kn': ['ಒಮೇಗಾ-3 & ಒಮೇಗಾ-6', 'ವಿಟಮಿನ್ E', 'ಮೆಗ್ನೀಷಿಯಂ'],
      'ml': ['ഒമേഗ-3 & ഒമേഗ-6', 'വിറ്റാമിൻ E', 'മഗ്നീഷ്യം'],
      'bn': ['ওমেগা-৩ ও ওমেগা-৬', 'ভিটামিন E', 'ম্যাগনেসিয়াম'],
      'pa': ['ਓਮੇਗਾ-3 ਅਤੇ ਓਮੇਗਾ-6', 'ਵਿਟਾਮਿਨ E', 'ਮੈਗਨੀਸ਼ੀਅਮ'],
      'gu': ['ઓમેગા-3 અને ઓમેગા-6', 'વિટામિન E', 'મેગ્નેશ઼ियમ'],
    },
    benefits: {
      'en': ['Heart health', 'Brain function', 'Reduces inflammation', 'Skin health', 'Hormone balance'],
      'te': ['గుండె ఆరోగ్యం', 'మెదడు పనితీరు', 'వాపు తగ్గిస్తుంది', 'చర్మ ఆరోగ్యం'],
      'hi': ['हृदय स्वास्थ्य', 'मस्तिष्क कार्य', 'सूजन कम करता है', 'त्वचा स्वास्थ्य'],
      'ta': ['இதய ஆரோக்கியம்', 'மூளை செயல்பாடு', 'வீக்கம் குறைக்கிறது'],
      'mr': ['हृदयाचे आरोग्य', 'मेंदूचे कार्य', 'जळजळ कमी करते'],
      'kn': ['ಹೃದಯ ಆರೋಗ್ಯ', 'ಮೆದುಳಿನ ಕಾರ್ಯ', 'ಉರಿಯೂತ ಕಡಿಮೆ'],
      'ml': ['ഹൃദയ ആരോഗ്യം', 'മസ്തിഷ്ക പ്രവർത്തനം', 'നീർക്കെട്ട് കുറക്കൽ'],
      'bn': ['হৃদয় স্বাস্থ্য', 'মস্তিষ্কের কার্যকারিতা', 'প্রদাহ কমায়'],
      'pa': ['ਦਿਲ ਦੀ ਸਿਹਤ', 'ਦਿਮਾਗ਼ ਦਾ ਕੰਮ', 'ਸੋਜ਼ਸ਼ ਘਟਾਉਂਦਾ'],
      'gu': ['હૃ઼દ਼ય આ਼ર਼ોગ਼ય', 'મ਼ગ਼਼ઝ ક਼લ਼્ણ', 'શૂઝ ઘ਼ટાડૅ'],
    },
    dishes: {
      'en': ['Almond milk', 'Walnut halwa', 'Sesame chikki', 'Flaxseed roti', 'Til ladoo', 'Mixed nut trail mix'],
      'te': ['బాదం పాలు', 'వాల్నట్ హల్వా', 'నువ్వుల చిక్కి', 'అవిసె రొట్టె', 'తిల లడ్డు'],
      'hi': ['बादाम दूध', 'अखरोट हलवा', 'तिल चिक्की', 'अलसी रोटी', 'तिल लड्डू'],
      'ta': ['பாதாம் பால்', 'வால்நட் ஹல்வா', 'எள் சிக்கி', 'ஆளி விதை ரொட்டி'],
      'mr': ['बदाम दूध', 'अक्रोड हलवा', 'तीळ चिक्की', 'जवस रोटी', 'तीळ लाडू'],
      'kn': ['ಬಾದಾಮಿ ಹಾಲು', 'ವಾಲ್ನಟ್ ಹಲ್ವಾ', 'ಎಳ್ಳು ಚಿಕ್ಕಿ', 'ತಿಲ ಲಾಡು'],
      'ml': ['ബദാം പാൽ', 'വാൽനട്ട് ഹൽവ', 'എള്ള് ചിക്കി', 'തിൽ ലഡ്ഡു'],
      'bn': ['বাদামের দুধ', 'আখরোটের হালুয়া', 'তিলের চিক্কি', 'তিলের লাড্ডু'],
      'pa': ['ਬਦਾਮ ਦੁੱਧ', 'ਅਖਰੋਟ ਹਲਵਾ', 'ਤਿਲ ਚਿੱਕੀ', 'ਤਿਲ ਲੱਡੂ'],
      'gu': ['બ઼દ਼ામ દ਼ૂ਼ધ', 'અ਼ખ਼਼ર਼ોટ હ਼લ਼਼વ਼਼ા', 'ત਼િલ ચ਼િ਼ક਼਼ી', 'ત਼િ਼લ લ਼਼ડ઼ુ'],
    },
  ),
];

// ═══════════════════════════════════════════════════════════
// NUTRITION SCREEN
// ═══════════════════════════════════════════════════════════

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});
  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  String _lang = 'en';
  String _selectedCategory = 'All';

  static const _categories = [
    'All', 'Vegetables', 'Cereals & Millets', 'Pulses & Legumes',
    'Fruits', 'Dairy', 'Protein', 'Healthy Fats',
  ];

  @override
  void initState() {
    super.initState();
    _loadLang();
  }

  Future<void> _loadLang() async {
    final p = await SharedPreferences.getInstance();
    setState(() => _lang = p.getString('app_language') ?? 'en');
  }

  String _t(Map<String, String> map) =>
      map[_lang] ?? map['en'] ?? '';

  List<String> _tl(Map<String, List<String>> map) =>
      map[_lang] ?? map['en'] ?? [];

  List<DietItem> get _filtered {
    if (_selectedCategory == 'All') return allDiets;
    return allDiets.where((d) => d.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(children: [
        _buildTopBar(),
        _buildBanner(),
        _buildCategoryChips(),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _filtered.length,
          itemBuilder: (_, i) => FadeInUp(
            delay: Duration(milliseconds: i * 60),
            child: _DietCard(
              item: _filtered[i],
              lang: _lang,
              tName: _t(_filtered[i].name),
              tDesc: _t(_filtered[i].description),
              tNutrients: _tl(_filtered[i].nutrients),
              tBenefits: _tl(_filtered[i].benefits),
              tDishes: _tl(_filtered[i].dishes),
            )))),
      ]),
    );
  }

  Widget _buildTopBar() => Container(
    color: AppColors.navyDark,
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16, right: 16, bottom: 14),
    child: Row(children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(width: 36, height: 36,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 16))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        const Text('Nutrition Guide', style: TextStyle(color: Colors.white,
            fontSize: 18, fontWeight: FontWeight.w700)),
        Text('ICMR 2024 · Language: ${_langName(_lang)}',
            style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
      ])),
      GestureDetector(
        onTap: () async {
          final uri = Uri.parse(
              'https://main.icmr.nic.in/sites/default/files/upload_documents/DGI_07th_May_2024_fin.pdf');
          if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: AppColors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.teal, width: 0.5)),
          child: const Text('📄 ICMR PDF', style: TextStyle(color: AppColors.teal,
              fontSize: 10, fontWeight: FontWeight.w700)))),
    ]));

  Widget _buildBanner() => Container(
    color: AppColors.navyDark,
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF0F6E56),
          borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        const Text('🥗', style: TextStyle(fontSize: 32)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          const Text('ICMR-NIN Dietary Guidelines 2024',
              style: TextStyle(color: Colors.white, fontSize: 13,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text('Dishes shown in your language: ${_langName(_lang)}',
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ])),
      ])));

  Widget _buildCategoryChips() => Container(
    color: Colors.white,
    height: 48,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _categories.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, i) {
        final c = _categories[i];
        final active = c == _selectedCategory;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: active ? const Color(0xFF0F6E56) : AppColors.bgPage,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: active ? const Color(0xFF0F6E56)
                  : const Color(0xFFE3EAF2), width: 0.5)),
            child: Text(c, style: TextStyle(fontSize: 11,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : AppColors.navyLight))));
      }));

  String _langName(String code) {
    const names = {
      'en': 'English', 'te': 'తెలుగు', 'hi': 'हिन्दी',
      'ta': 'தமிழ்', 'mr': 'मराठी', 'kn': 'ಕನ್ನಡ',
      'ml': 'മലയാളം', 'bn': 'বাংলা', 'pa': 'ਪੰਜਾਬੀ', 'gu': 'ગુજરાતી',
    };
    return names[code] ?? 'English';
  }
}

// ═══════════════════════════════════════════════════════════
// DIET CARD
// ═══════════════════════════════════════════════════════════

class _DietCard extends StatefulWidget {
  final DietItem item;
  final String lang, tName, tDesc;
  final List<String> tNutrients, tBenefits, tDishes;
  const _DietCard({required this.item, required this.lang,
    required this.tName, required this.tDesc,
    required this.tNutrients, required this.tBenefits,
    required this.tDishes});
  @override
  State<_DietCard> createState() => _DietCardState();
}

class _DietCardState extends State<_DietCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5)),
      child: Column(children: [
        // Header
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 52, height: 52,
                  decoration: BoxDecoration(color: item.bgColor,
                      borderRadius: BorderRadius.circular(14)),
                  child: Center(child: Text(item.emoji,
                      style: const TextStyle(fontSize: 26)))),
                const SizedBox(width: 12),
                Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.tName, style: const TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Row(children: [
                    Container(padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: item.bgColor,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(item.category,
                          style: TextStyle(fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: item.color))),
                    const SizedBox(width: 6),
                    Text(item.icmrNote, style: const TextStyle(
                        fontSize: 9, color: AppColors.textHint)),
                  ]),
                  const SizedBox(height: 6),
                  Text(widget.tDesc, style: const TextStyle(fontSize: 11,
                      color: AppColors.textSecondary, height: 1.4),
                      maxLines: _expanded ? 10 : 2,
                      overflow: TextOverflow.ellipsis),
                ])),
                Icon(_expanded ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textHint, size: 20),
              ]),

              if (!_expanded) ...[
                const SizedBox(height: 10),
                // Quick nutrients preview
                Wrap(spacing: 5, runSpacing: 5,
                    children: widget.tNutrients.take(3).map((n) =>
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: item.bgColor,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(n, style: TextStyle(fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: item.color)))).toList()),
              ],
            ])),
        ),

        // Expanded content
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Divider(color: Color(0xFFF0F4F8), height: 1),
              const SizedBox(height: 12),

              // Nutrients
              _sectionTitle('🔬 Nutrients', item.color),
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6,
                  children: widget.tNutrients.map((n) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: item.bgColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(n, style: TextStyle(fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: item.color)))).toList()),
              const SizedBox(height: 14),

              // Benefits
              _sectionTitle('✅ Health Benefits', item.color),
              const SizedBox(height: 8),
              ...widget.tBenefits.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(children: [
                  Icon(Icons.check_circle_rounded, size: 14, color: item.color),
                  const SizedBox(width: 7),
                  Expanded(child: Text(b, style: const TextStyle(fontSize: 12,
                      color: AppColors.textSecondary))),
                ]))),
              const SizedBox(height: 14),

              // Dishes in user language
              _sectionTitle('🍽️ Dishes in your language', item.color),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: item.bgColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.tDishes.map((d) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(children: [
                        Text('• ', style: TextStyle(color: item.color,
                            fontWeight: FontWeight.w700)),
                        Expanded(child: Text(d, style: TextStyle(fontSize: 12,
                            color: item.color,
                            fontWeight: FontWeight.w600))),
                      ]))).toList())),
            ])),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250)),
      ]));
  }

  Widget _sectionTitle(String t, Color c) => Text(t,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c));
}
