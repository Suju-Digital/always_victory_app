import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceHelper {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      // Set to Indian English by default
      List<String> langs = ["en-IN", "en-US", "hi-IN"];
      String selectedLang = "en-IN";
      
      for (var lang in langs) {
        if (await _flutterTts.isLanguageAvailable(lang) as bool) {
          selectedLang = lang;
          break;
        }
      }
      
      await _flutterTts.setLanguage(selectedLang); 
      await _flutterTts.setSpeechRate(0.5); 
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0); 
      
      _isInitialized = true;
      debugPrint("TTS Initialized with language: $selectedLang");
    } catch (e) {
      debugPrint("TTS Init Error: $e");
    }
  }

  static Future<void> speak(String text) async {
    try {
      if (!_isInitialized) await init();
      
      debugPrint("TTS: Attempting to speak -> $text");
      var result = await _flutterTts.speak(text);
      if (result == 1) {
        debugPrint("TTS: Speaking successful");
      } else {
        debugPrint("TTS: Speaking failed with code $result");
      }
    } catch (e) {
      debugPrint("TTS Speak Exception: $e");
    }
  }

  static Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint("TTS Stop Error: $e");
    }
  }
}
