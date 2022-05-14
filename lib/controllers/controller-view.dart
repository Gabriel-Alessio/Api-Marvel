import 'dart:convert';
import 'package:api_marvel/models/models.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;


class HomeController {
  String searchSuperHero = '';
  String apikey = "1c68c3733201764b1e55280d134113d512bc339a";
  String apiKeyPublic = '172350360deaadd06d3661e97c3dad70';
  int limit = 20;
  String heroImageUrl = '';
  String nameHero = '';
  String descriptionHero = '';

  Future<Data> getHeroes([String? param]) async {
    http.Response response;
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String temp = "$timestamp$apikey$apiKeyPublic";
    String hash = generateMd5(temp);

    final uri = param != null ? 
    Uri.parse("https://gateway.marvel.com:443/v1/public/characters?nameStartsWith=$param&ts=$timestamp&apikey=$apiKeyPublic&hash=$hash") :
    Uri.parse("https://gateway.marvel.com:443/v1/public/characters?ts=$timestamp&apikey=$apiKeyPublic&hash=$hash");

    response = await http.get(uri);

    return Data.fromJson(json.decode(response.body));
  }

  generateMd5(String data) {
    var content = const Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}