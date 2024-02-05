import 'package:chat_web_app/util/shared_preferences.dart';

String get baseUrl {
  final cachedDomain = AppSharedPreference.myMetta.domain;
  return cachedDomain.isNotEmpty ? cachedDomain : testUrl;
}

bool get isTestDomain => !baseUrl.contains('manage');

const testUrl = 'lms.almas.education';
const liveUrl = 'manage.almas.education';
