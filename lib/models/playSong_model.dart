import 'package:audioplayers/audioplayers.dart';

class playSongs {
  // audio player
  final AudioPlayer audioPlayer = AudioPlayer();

  // Duration
  Duration currentDuration = Duration.zero;
  Duration totalDuration = Duration.zero;

  // Constructor
  PlaySong() {
    ListenToDuration();
  }

  // Listen to duration
  void ListenToDuration() {
    // Listenn for total duration
    audioPlayer.onDurationChanged.listen((duration) {
      totalDuration = duration;
      // notifyListeners();
    });
  }

  // Update UI

  int? get currentSongIndex => currentSongIndex;
  set currentSongIndex(int? index) {
    currentSongIndex = index;
    // notifyListeners();
  }
}
