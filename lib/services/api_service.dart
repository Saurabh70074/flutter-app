import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:radio/models/video_model.dart';

const String API_KEY = "AIzaSyD4OWp_WN7I1s2EXsf8wMk_HfyoMYLB1Uw";

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'www.googleapis.com';

  Future<List<Video>> fetchVideosFromPlaylist(
      {required String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '10',
      'key': API_KEY,
    };

    Uri uri = Uri.https(_baseUrl, '/youtube/v3/playlistItems', parameters);
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> videosJson = data['items'];

      List<Video> videos =
          videosJson.map((json) => Video.fromMap(json['snippet'])).toList();

      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
