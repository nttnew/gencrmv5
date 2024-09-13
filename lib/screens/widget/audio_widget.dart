import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/src_index.dart';
import '../../widgets/item_file.dart';

class AudioWidget extends StatelessWidget {
  const AudioWidget({
    Key? key,
    required this.audioUrl,
  }) : super(key: key);
  final String audioUrl;

  @override
  Widget build(BuildContext context) {
    return audioUrl.toString().trim() == ''
        ? SizedBox(
            height: 8,
          )
        : AudioBase(
            audioUrl: audioUrl,
            isDetail: false,
          );
  }
}

class AudioBase extends StatefulWidget {
  final String audioUrl;
  final bool isDetail;

  AudioBase({
    required this.audioUrl,
    required this.isDetail,
  });

  @override
  _AudioBaseState createState() => _AudioBaseState();
}

class _AudioBaseState extends State<AudioBase> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = true;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Cập nhật trạng thái khi audio phát
    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted)
        setState(() {
          duration = newDuration;
        });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted)
        setState(() {
          position = newPosition;
        });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted)
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
    });
    playPauseAudio(isInit: true);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
      _audioPlayer
          .setVolume(isMuted ? 0 : 1); // 0 là mute, 1 là âm lượng tối đa
    });
  }

  void download() {
    launchInBrowser(Uri.parse(widget.audioUrl));
  }

  Future<void> playPauseAudio({bool isInit = false}) async {
    if (isInit) {
      // Set URL để có thể lấy duration ngay lập tức
      await _audioPlayer.setSourceUrl(widget.audioUrl);

      // Lấy duration ngay sau khi set URL (nếu đã có sẵn)
      if (_audioPlayer.source != null) {
        final totalDuration = await _audioPlayer.getDuration();
        if (totalDuration != null && mounted) {
          setState(() {
            duration = totalDuration;
          });
        }
      }
    }

    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: widget.isDetail ? itemDetail() : itemWidget(),
    );
  }

  Widget itemDetail() => Column(
        children: [
          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            activeColor: getBackgroundWithIsCar(),
            thumbColor: getBackgroundWithIsCar(),
            inactiveColor: getBackgroundWithIsCar().withOpacity(0.4),
            onChanged: (value) async {
              position = Duration(seconds: value.toInt());
              await _audioPlayer.seek(position);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(position),
                  style: AppStyle.DEFAULT_14,
                ),
                Text(
                  formatDuration(duration),
                  style: AppStyle.DEFAULT_14,
                ),
              ],
            ),
          ),
          AppValue.vSpace20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                ),
                child: GestureDetector(
                  onTap: playPauseAudio,
                  child: Image.asset(
                    isPlaying ? ICONS.IC_PAUSE_PNG : ICONS.IC_PLAY_PNG,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Icon(
                      isMuted ? Icons.volume_off : Icons.volume_up,
                      color: COLORS.BLACK,
                    ),
                    onTap: toggleMute,
                  ),
                  AppValue.hSpace10,
                  GestureDetector(
                    child: Icon(
                      Icons.download,
                      color: COLORS.BLACK,
                    ),
                    onTap: download,
                  ),
                  AppValue.hSpace10,
                ],
              ),
            ],
          ),
        ],
      );

  Widget itemWidget() => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: playPauseAudio,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                ),
                child: Image.asset(
                  isPlaying ? ICONS.IC_PAUSE_PNG : ICONS.IC_PLAY_PNG,
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Text(
                    formatDuration(position) + ' / ',
                    style: AppStyle.DEFAULT_14,
                  ),
                  Text(
                    formatDuration(duration),
                    style: AppStyle.DEFAULT_14,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                activeColor: COLORS.PRIMARY_COLOR1,
                thumbColor: COLORS.PRIMARY_COLOR1,
                inactiveColor: COLORS.PRIMARY_COLOR1.withOpacity(0.4),
                onChanged: (value) async {
                  position = Duration(seconds: value.toInt());
                  await _audioPlayer.seek(position);
                },
              ),
            ),
            IconButton(
              icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
              onPressed: toggleMute,
            ),
          ],
        ),
      );

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String oneDigits(int n) => n.toString().padLeft(1, '0');
    final minutes = duration.inMinutes > 9
        ? twoDigits(duration.inMinutes.remainder(60))
        : oneDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
