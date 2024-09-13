import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart'; // Thư viện để tải file
import 'package:path_provider/path_provider.dart'; // Thư viện để lấy thư mục tạm
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
  bool _isPlaying = true;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Cập nhật trạng thái khi audio phát
    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted)
        setState(() {
          _duration = newDuration;
        });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted)
        setState(() {
          if (Platform.isIOS && _duration.inMilliseconds == 0)
            _duration = newPosition;
          _position = newPosition;
        });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) async {
      if (mounted)
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
    });

    _playPauseAudio(isInit: true);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _audioPlayer
          .setVolume(_isMuted ? 0 : 1); // 0 là mute, 1 là âm lượng tối đa
    });
  }

  Future<String> _downloadAudio(String url) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filePath = '$tempPath/audio.mp3';

    Dio dio = Dio();
    await dio.download(url, filePath);

    return filePath;
  }

  Future<void> _playPauseAudio({bool isInit = false}) async {
    if (isInit) {
      if (Platform.isIOS) {
        // Nếu là iOS thì tải file về trước khi phát
        String filePath = await _downloadAudio(widget.audioUrl);
        await _audioPlayer.setSource(DeviceFileSource(filePath));
      } else {
        // Android phát từ URL
        await _audioPlayer.setSourceUrl(widget.audioUrl);
      }
    }

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(Platform.isIOS
          ? DeviceFileSource(await _downloadAudio(widget.audioUrl))
          : UrlSource(widget.audioUrl));
    }
  }

  void _download() {
    launchInBrowser(Uri.parse(widget.audioUrl));
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
            max: _duration.inSeconds.toDouble(),
            value: _position.inSeconds.toDouble(),
            activeColor: getBackgroundWithIsCar(),
            thumbColor: getBackgroundWithIsCar(),
            inactiveColor: getBackgroundWithIsCar().withOpacity(0.4),
            onChanged: (value) async {
              _position = Duration(seconds: value.toInt());
              await _audioPlayer.seek(_position);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: AppStyle.DEFAULT_14,
                ),
                Text(
                  _formatDuration(_duration),
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
                padding: EdgeInsets.only(left: 16),
                child: GestureDetector(
                  onTap: _playPauseAudio,
                  child: Image.asset(
                    _isPlaying ? ICONS.IC_PAUSE_PNG : ICONS.IC_PLAY_PNG,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Icon(
                      _isMuted ? Icons.volume_off : Icons.volume_up,
                      color: COLORS.BLACK,
                    ),
                    onTap: _toggleMute,
                  ),
                  AppValue.hSpace10,
                  GestureDetector(
                    child: Icon(
                      Icons.download,
                      color: COLORS.BLACK,
                    ),
                    onTap: _download,
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
              onTap: _playPauseAudio,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  _isPlaying ? ICONS.IC_PAUSE_PNG : ICONS.IC_PLAY_PNG,
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
                    _formatDuration(_position) + ' / ',
                    style: AppStyle.DEFAULT_14,
                  ),
                  Text(
                    _formatDuration(_duration),
                    style: AppStyle.DEFAULT_14,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Slider(
                min: 0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds.toDouble(),
                activeColor: COLORS.PRIMARY_COLOR1,
                thumbColor: COLORS.PRIMARY_COLOR1,
                inactiveColor: COLORS.PRIMARY_COLOR1.withOpacity(0.4),
                onChanged: (value) async {
                  _position = Duration(seconds: value.toInt());
                  await _audioPlayer.seek(_position);
                },
              ),
            ),
            IconButton(
              icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
              onPressed: _toggleMute,
            ),
          ],
        ),
      );

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String oneDigits(int n) => n.toString().padLeft(1, '0');
    final minutes = duration.inMinutes > 9
        ? twoDigits(duration.inMinutes.remainder(60))
        : oneDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
