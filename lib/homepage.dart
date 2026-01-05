import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'single_music.dart';
import 'playlist_folder.dart';
import 'search.dart';
import 'youtube.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> allSongs = [];

  // Audio Player
  final AudioPlayer _player = AudioPlayer();
  SongModel? currentSong;
  bool isPlaying = false;
  int currentIndex = 0;

  // Draggable mini-player position
  double offsetX = 20;
  double offsetY = 500;

  @override
  void initState() {
    super.initState();
    requestPermissionAndLoadSongs();
  }

  Future<void> requestPermissionAndLoadSongs() async {
    if (await Permission.audio.request().isGranted ||
        await Permission.storage.request().isGranted) {
      loadSongs();
    } else {
      await Permission.audio.request();
    }
  }

  Future<void> loadSongs() async {
    List<SongModel> songs = await _audioQuery.querySongs(
        sortType: SongSortType.DATE_ADDED,
        orderType: OrderType.DESC_OR_GREATER);

    setState(() {
      allSongs = songs;
    });
  }

  // Play selected song
  Future<void> playSong(SongModel song, [int? index]) async {
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(song.uri!)));
      await _player.play();
      setState(() {
        currentSong = song;
        isPlaying = true;
        currentIndex = index ?? 0;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  // Toggle Play/Pause
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

  // Next Song
  void playNext() {
    if (currentIndex < allSongs.length - 1) {
      currentIndex++;
      playSong(allSongs[currentIndex], currentIndex);
    }
  }

  // Previous Song
  void playPrevious() {
    if (currentIndex > 0) {
      currentIndex--;
      playSong(allSongs[currentIndex], currentIndex);
    }
  }

  // Close mini player
  void closeMiniPlayer() async {
    await _player.stop();
    setState(() {
      isPlaying = false;
      currentSong = null;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // Mini-player widget
  Widget miniPlayerWidget() {
    if (currentSong == null) return const SizedBox();
    return GestureDetector(
      onTap: () {
        // Open full music player
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicPlayerPage(
              song: currentSong!,
              songList: allSongs,
              startIndex: currentIndex,
              player: _player,
            ),
          ),
        );
      },
      child: Container(
        width: 410,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blueAccent, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            QueryArtworkWidget(
              id: currentSong!.id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: Image.asset(
                "Assets/images/music_icon.png",
                width: 55,
                height: 55,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                currentSong!.title.split(' ').take(3).join(' '),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 8),
              ),
            ),
            IconButton(
              icon: Icon(Icons.skip_previous, color: Colors.white),
              onPressed: playPrevious,
            ),
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white),
              onPressed: togglePlayPause,
            ),
            IconButton(
              icon: Icon(Icons.skip_next, color: Colors.white),
              onPressed: playNext,
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.redAccent),
              onPressed: closeMiniPlayer,
            ),
          ],
        ),
      ),
    );
  }

  // Bottom navigation bar
  Widget buildBottomBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF2356D8), width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.library_music, color: Colors.white),
                SizedBox(height: 4),
                Text("My Music", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.search, color: Colors.white),
                SizedBox(height: 4),
                Text("Search", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.video_collection_rounded, color: Colors.white),
                SizedBox(height: 4),
                Text("YouTube", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(85.0),
            child: AppBar(
              backgroundColor: Colors.black,
              centerTitle: true,
              title: const Text(
                "Music",
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.settings, color: Colors.white60, size: 35),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlaylistFolder()),
                    );
                  },
                  child: Row(
                    children: const [
                      SizedBox(width: 20),
                      Icon(Icons.folder_copy_rounded,
                          color: Colors.white60, size: 70),
                      SizedBox(width: 80),
                      Text("Playlist",
                          style:
                          TextStyle(fontSize: 35, color: Colors.white60)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your Music',
                style: TextStyle(
                  fontSize: 45,
                  color: Color(0xFF2356D8),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: allSongs.isEmpty
                    ? const Center(
                  child:
                  CircularProgressIndicator(color: Colors.blueAccent),
                )
                    : ListView.separated(
                  itemCount: allSongs.length,
                  itemBuilder: (context, index) {
                    final song = allSongs[index];
                    return ListTile(
                      leading: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: Image.asset(
                            "Assets/images/music_icon.png"),
                      ),
                      title: Text(
                        song.title,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 17),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(song.artist ?? "Unknown Artist",
                          style:
                          const TextStyle(color: Colors.white70)),
                      trailing: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 40),
                      onTap: () {
                        playSong(song, index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MusicPlayerPage(
                              song: song,
                              songList: allSongs,
                              startIndex: index,
                              player: _player,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.white24,
                    thickness: 1,
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: buildBottomBar(),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
        ),

        // Draggable mini player
        if (currentSong != null)
          Positioned(
            left: offsetX,
            top: offsetY,
            child: Draggable(
              feedback: miniPlayerWidget(),
              childWhenDragging: const SizedBox(),
              onDragEnd: (details) {
                setState(() {
                  offsetX = details.offset.dx
                      .clamp(0, MediaQuery.of(context).size.width - 250);
                  offsetY = details.offset.dy
                      .clamp(100, MediaQuery.of(context).size.height - 100);
                });
              },
              child: miniPlayerWidget(),
            ),
          ),
      ],
    );
  }
}
