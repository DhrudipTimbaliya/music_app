import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:marquee/marquee.dart';

class MusicPlayerPage extends StatefulWidget {
  final SongModel song;
  final List<SongModel> songList;
  final int startIndex;
  final AudioPlayer player;

  const MusicPlayerPage({
    super.key,
    required this.song,
    required this.songList,
    required this.startIndex,
    required this.player,
  });

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late int currentIndex;
  late AudioPlayer _player;
  bool isPlaying = true;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  double volume = 0.5;

  @override
  void initState() {
    super.initState();
    _player = widget.player;
    currentIndex = widget.startIndex;
    listenToDuration();
    initVolumeController();
  }

  void initVolumeController() async {
    double systemVolume = await VolumeController().getVolume();
    setState(() {
      volume = systemVolume;
    });
    _player.setVolume(systemVolume);
    VolumeController().listener((v) {
      setState(() {
        volume = v;
      });
      _player.setVolume(v);
    });
  }

  void listenToDuration() {
    _player.positionStream.listen((p) {
      setState(() {
        position = p;
      });
    });
    _player.durationStream.listen((d) {
      setState(() {
        duration = d ?? Duration.zero;
      });
    });
  }

  void togglePlayPause() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void playNext() {
    if (currentIndex < widget.songList.length - 1) {
      currentIndex++;
      _player.setAudioSource(
          AudioSource.uri(Uri.parse(widget.songList[currentIndex].uri!)));
      _player.play();
    }
  }

  void playPrevious() {
    if (currentIndex > 0) {
      currentIndex--;
      _player.setAudioSource(
          AudioSource.uri(Uri.parse(widget.songList[currentIndex].uri!)));
      _player.play();
    }
  }

  void changeVolume(double v) {
    setState(() {
      volume = v;
    });
    VolumeController().setVolume(v);
    _player.setVolume(v);
  }

  String shortTitle(String text) {
    final words = text.split(' ');
    return words.length <= 5 ? text : '${words.sublist(0, 5).join(' ')}...';
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.songList[currentIndex];

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Now Playing", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: QueryArtworkWidget(
                    id: currentSong.id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Image.asset(
                      "Assets/images/music_icon.png",
                      width: 280,
                      height: 280,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            Container(
             height: 40, // Adjust height as needed
             child: Marquee(
                text: currentSong.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                scrollAxis: Axis.horizontal,
                blankSpace: 20,
                velocity: 40, // speed of scroll
                pauseAfterRound: const Duration(seconds: 1),
                startPadding: 10,
                accelerationDuration: const Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(seconds: 1),
                decelerationCurve: Curves.easeOut,
              ),
        ),
              const SizedBox(height: 5),
              Text(currentSong.artist ?? "Unknown Artist",
                  style: const TextStyle(color: Colors.white70, fontSize: 18)),
              const SizedBox(height: 30),
              Slider(
                value: position.inSeconds
                    .toDouble()
                    .clamp(0.0, duration.inSeconds.toDouble() > 0
                    ? duration.inSeconds.toDouble()
                    : 1.0),
                min: 0,
                max: duration.inSeconds.toDouble() > 0
                    ? duration.inSeconds.toDouble()
                    : 1.0,
                activeColor: Colors.white,
                inactiveColor: Colors.white30,
                onChanged: (value) async {
                  await _player.seek(Duration(seconds: value.toInt()));
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(position),
                        style: const TextStyle(color: Colors.white70)),
                    Text(formatTime(duration),
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon: const Icon(Icons.skip_previous,
                          color: Colors.white, size: 40),
                      onPressed: playPrevious),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.black, size: 35),
                      onPressed: togglePlayPause,
                    ),
                  ),
                  IconButton(
                      icon:
                      const Icon(Icons.skip_next, color: Colors.white, size: 40),
                      onPressed: playNext),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    const Icon(Icons.volume_down, color: Colors.white70),
                    Expanded(
                      child: Slider(
                        value: volume,
                        min: 0,
                        max: 1,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white30,
                        onChanged: changeVolume,
                      ),
                    ),
                    const Icon(Icons.volume_up, color: Colors.white70),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
