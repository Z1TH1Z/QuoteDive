import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  static final AudioService instance = AudioService._init();
  AudioService._init();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;

  Future<void> initialize() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speakQuote(String text, String author) async {
    if (_isPlaying) {
      await stop();
    }

    _isPlaying = true;
    final fullText = '$text. By $author';
    await _flutterTts.speak(fullText);
  }

  Future<void> stop() async {
    _isPlaying = false;
    await _flutterTts.stop();
  }

  Future<void> pause() async {
    _isPlaying = false;
    await _flutterTts.pause();
  }

  bool get isPlaying => _isPlaying;

  void dispose() {
    _flutterTts.stop();
  }
}
