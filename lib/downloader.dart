import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';

class Download{

  Future<void> downloadVideo(String youTubeLink , String title) async {
    final result = await FlutterYoutubeDownloader.downloadVideo(
        youTubeLink, title, 22);
         print(result);
  }
}