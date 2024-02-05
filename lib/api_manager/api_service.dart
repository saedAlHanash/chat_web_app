import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:chat_web_app/fire_chat/extensions.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../go_route_pages.dart';
import '../util/shared_preferences.dart';
import 'api_url.dart';

// const baseUrl = 'live.qareeb-maas.com';
// const baseUrl = '192.168.1.44:44311';

var loggerObject = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    // number of method calls to be displayed
    errorMethodCount: 0,
    // number of method calls if stacktrace is provided
    lineLength: 300,
    // width of the output
    colors: true,
    // Colorful log messages
    printEmojis: false,
    // Print an emoji for each log message
    printTime: false,
  ),
);

DateTime? _serverDate;

DateTime get getServerDate => _serverDate ?? DateTime.now();

class APIService {
  static APIService _singleton = APIService._internal();

  factory APIService() => _singleton;

  factory APIService.reInitial() {
    AppSharedPreference.reload();
    _singleton = APIService._internal();
    return _singleton;
  }

  Map<String, String> get innerHeader => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AppSharedPreference.myMetta.userToken}',
      };

  APIService._internal();

  Uri getUri({
    required String url,
    Map<String, dynamic>? query,
    Map<String, String>? header,
    String? path,
    String? hostName,
  }) {
    if (query != null) query.removeWhere((key, value) => value == null);

    innerHeader.addAll(header ?? {});

    if (path != null) url = '$url/$path';

    if (query != null) {
      query.removeWhere((key, value) => value == null);
      query.forEach((key, value) => query[key] = value.toString());
    }

    logRequest('${hostName ?? ''}$url', query);

    final uri = Uri.https(hostName ?? baseUrl, url, query);

    return uri;
  }

  Future<http.Response> getApi({
    required String url,
    Map<String, dynamic>? query,
    Map<String, String>? header,
    String? path,
    String? hostName,
  }) async {
    innerHeader.addAll(header ?? {});

    if (path != null) url = '$url/$path';

    if (query != null) {
      query.removeWhere((key, value) => (value == null || value.toString().isEmpty));
      query.forEach((key, value) => query[key] = value.toString());
    }

    logRequest('${hostName ?? ''}$url', query);

    final uri = Uri.https(hostName ?? baseUrl, url, query);

    try {
      final response = await http.get(uri, headers: innerHeader).timeout(
            const Duration(seconds: 40),
            onTimeout: () => http.Response('connectionTimeOut', 481),
          );

      logResponse(url, response);
      _serverDate = getDateTimeFromHeaders(response);

      return response;
    } on Exception {
      return http.Response('{}', 481);
    }
  }

  Future<http.Response> getApiProxy({
    required String url,
    Map<String, dynamic>? query,
    Map<String, String>? header,
    String? path,
    String? hostName,
  }) async {
    innerHeader.addAll(header ?? {});

    if (path != null) url = '$url/$path';

    if (query != null) {
      query.removeWhere((key, value) => (value == null || value.toString().isEmpty));
      query.forEach((key, value) => query[key] = value.toString());
    }

    logRequest('${hostName ?? ''}$url', query);

    final uri = Uri.https(hostName ?? baseUrl, url, query);
    final proxyUri = Uri.https('api.allorigins.win', 'raw', {'url': uri.toString()});

    try {
      final response = await http.get(proxyUri, headers: innerHeader).timeout(
            const Duration(seconds: 40),
            onTimeout: () => http.Response('connectionTimeOut', 481),
          );

      logResponse(url, response);
      _serverDate = getDateTimeFromHeaders(response);
      return response;
    } on Exception {
      return http.Response('{}', 481);
    }
  }

  Future<http.Response> getApiProxyPayed({
    required String url,
    Map<String, dynamic>? query,
    Map<String, String>? header,
    String? path,
  }) async {
    if (path != null) url = '$url/$path';

    if (query != null) {
      query.removeWhere((key, value) => (value == null || value.toString().isEmpty));
      query.forEach((key, value) => query[key] = value.toString());
    }

    final uri = Uri.https('proxy.cors.sh', url, query);

    try {
      final response =
          await http.get(uri, headers: innerHeader).timeout(const Duration(seconds: 40));
      _serverDate = getDateTimeFromHeaders(response);
      return response;
    } on Exception {
      return http.Response('{}', 481);
    }
  }

  Future<http.Response> postApi({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? header,
    String? hostName,
  }) async {
    if (body != null) body.removeWhere((key, value) => value == null);

    if (query != null) {
      query.removeWhere((key, value) => (value == null || value.toString().isEmpty));
      query.forEach((key, value) {
        if (value is! List) query[key] = value.toString();
      });
    }

    innerHeader.addAll(header ?? {});

    final uri = Uri.https(hostName ?? baseUrl, url, query);
    loggerObject.w(uri);
    logRequest(url, (body ?? {})..addAll(query ?? {}));

    try {
      final response =
          await http.post(uri, body: jsonEncode(body), headers: innerHeader).timeout(
                const Duration(seconds: 40),
                onTimeout: () => http.Response('connectionTimeOut', 481),
              );

      logResponse(url, response);
      _serverDate = getDateTimeFromHeaders(response);
      return response;
    } on Exception {
      return http.Response('{}', 481);
    }
  }

  Future<http.Response> puttApi({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? header,
  }) async {
    body?.removeWhere((key, value) => (value == null || value.toString().isEmpty));

    innerHeader.addAll(header ?? {});

    if (query != null) {
      query.removeWhere((key, value) => (value == null || value.toString().isEmpty));
      query.forEach((key, value) => query[key] = value.toString());
    }

    final uri = Uri.https(baseUrl, url, query);

    logRequest(url, body);

    try {
      final response =
          await http.put(uri, body: jsonEncode(body), headers: innerHeader).timeout(
                const Duration(seconds: 40),
                onTimeout: () => http.Response('connectionTimeOut', 481),
              );

      logResponse(url, response);
      _serverDate = getDateTimeFromHeaders(response);
      return response;
    } on Exception {
      return http.Response('{}', 481);
    }
  }

  Future<http.Response> patchApi({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? header,
  }) async {
    if (body != null) body.removeWhere((key, value) => value == null);

    innerHeader.addAll(header ?? {});

    if (query != null) {
      query.removeWhere((key, value) => (value == null || value.toString().isEmpty));
      query.forEach((key, value) => query[key] = value.toString());
    }

    final uri = Uri.https(baseUrl, url, query);

    logRequest(url, body);

    try {
      final response =
          await http.patch(uri, body: jsonEncode(body), headers: innerHeader).timeout(
                const Duration(seconds: 40),
                onTimeout: () => http.Response('connectionTimeOut', 481),
              );

      logResponse(url, response);
      _serverDate = getDateTimeFromHeaders(response);
      return response;
    } on Exception {
      return http.Response('{}', 481);
    }
  }

  Future<http.Response> deleteApi({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? header,
  }) async {
    if (body != null) body.removeWhere((key, value) => value == null);

    if (query != null) {
      query.removeWhere((key, value) => (value == null || value.toString().isEmpty));
      query.forEach((key, value) => query[key] = value.toString());
    }

    innerHeader.addAll(header ?? {});

    final uri = Uri.https(baseUrl, url, query);

    logRequest(url, query);

    try {
      final response =
          await http.delete(uri, body: jsonEncode(body), headers: innerHeader).timeout(
                const Duration(seconds: 40),
                onTimeout: () => http.Response('connectionTimeOut', 481),
              );

      logResponse(url, response);
      _serverDate = getDateTimeFromHeaders(response);
      return response;
    } on Exception {
      return http.Response('{}', 481);
    }
  }

  Future<http.Response> uploadMultiPart({
    required String url,
    String type = 'POST',
    List<UploadFile?>? files,
    Map<String, dynamic>? fields,
    Map<String, String>? header,
  }) async {
    Map<String, String> f = {};
    fields?.removeWhere((key, value) => (value == null || value.toString().isEmpty));
    (fields ?? {}).forEach((key, value) => f[key] = value.toString());

    innerHeader.addAll(header ?? {});
    final uri = Uri.https(baseUrl, url);

    loggerObject.w(uri);
    var request = http.MultipartRequest(type, uri);

    logRequest(url, fields, additional: files?.firstOrNull?.nameField);

    for (var uploadFile in (files ?? <UploadFile?>[])) {
      if (uploadFile?.fileBytes == null) continue;

      final multipartFile = http.MultipartFile.fromBytes(
        uploadFile!.nameField,
        uploadFile.fileBytes!,
        filename: '${getRandomString(10)}.jpg',
      );

      request.files.add(multipartFile);
    }

    request.headers.addAll(innerHeader);

    request.fields.addAll(f);

    try {
      final stream = await request.send();

      final response = await http.Response.fromStream(stream);

      logResponse(url, response);
      _serverDate = getDateTimeFromHeaders(response);
      return response;
    } on Exception catch (e) {
      loggerObject.e(e);
      return http.Response('{}', 481);
    }
  }

  Future<DateTime> getServerTime() async {
    if (_serverDate != null) return _serverDate!;
    var uri = Uri.https(baseUrl);

    final response = await http.get(uri, headers: innerHeader).timeout(
          const Duration(seconds: 40),
          onTimeout: () => http.Response('connectionTimeOut', 481),
        );

    _serverDate = getDateTimeFromHeaders(response);

    return _serverDate!;
  }
}

void logRequest(String url, Map<String, dynamic>? q, {String? additional}) {
  if (url.contains('api.php')) return;
  loggerObject.i('$url \n ${jsonEncode(q)}${additional == null ? '' : '\n$additional'}');
}

void logResponse(String url, http.Response response) {
  if (url.contains('api.php')) return;
  var r = [];
  var res = '';
  if (response.body.length > 800) {
    r = response.body.splitByLength1(800);
    for (var e in r) {
      res += '$e\n';
    }
  } else {
    res = response.body;
  }

  loggerObject.v('${response.statusCode} \n $res');
}

DateTime getDateTimeFromHeaders(http.Response response) {
  final headers = response.headers;

  if (headers.containsKey('date')) {
    final dateString = headers['date']!;

    final dateTime = parseGMTDate(dateString);
    return dateTime.addFromNow();
  } else {
    return DateTime.now();
  }
}

DateTime parseGMTDate(String dateString) {
  final formatter = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
  return formatter.parseUTC(dateString);
}

class UploadFile {
  final Uint8List? fileBytes;
  final String nameField;
  final String? initialImage;

  UploadFile({
    required this.fileBytes,
    this.initialImage,
    this.nameField = 'File',
  });

  UploadFile copyWith({
    Uint8List? fileBytes,
    String? nameField,
  }) {
    return UploadFile(
      fileBytes: fileBytes ?? this.fileBytes,
      nameField: nameField ?? this.nameField,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'filelBytes': fileBytes,
      'nameField': nameField,
    };
  }

  factory UploadFile.fromMap(Map<String, dynamic> map) {
    return UploadFile(
      fileBytes: map['filelBytes'] as Uint8List,
      nameField: map['nameField'] as String,
    );
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
final _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
