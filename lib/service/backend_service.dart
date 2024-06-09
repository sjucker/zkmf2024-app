import 'dart:async';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/app_page.dart';
import 'package:zkmf2024_app/dto/emergency_message.dart';
import 'package:zkmf2024_app/dto/festprogramm_day.dart';
import 'package:zkmf2024_app/dto/judge.dart';
import 'package:zkmf2024_app/dto/location.dart';
import 'package:zkmf2024_app/dto/ranking_list.dart';
import 'package:zkmf2024_app/dto/sponsoring.dart';
import 'package:zkmf2024_app/dto/timetable_overview.dart';
import 'package:zkmf2024_app/dto/unterhaltung_entry.dart';
import 'package:zkmf2024_app/dto/unterhaltung_type.dart';
import 'package:zkmf2024_app/dto/verein_detail.dart';
import 'package:zkmf2024_app/dto/verein_member_info.dart';
import 'package:zkmf2024_app/dto/verein_overview.dart';

final _box = GetStorage();

Future<T> fetch<T>(String endpoint, String cacheKey, T Function(String response) mapper) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));
    if (response.statusCode == 200) {
      var body = utf8.decode(response.bodyBytes);
      _box.write(cacheKey, body);
      return mapper(body);
    }
    throw Exception("could not fetch from backend, try cache");
  } on Exception {
    String? cachedBody = _box.read(cacheKey);
    if (cachedBody != null) {
      return mapper(cachedBody);
    }
    throw Exception('could not fetch and not in cache either');
  }
}

Future<List<LocationDTO>> fetchLocations() async {
  return fetch('/public/location/wettspiel', 'locations', (response) {
    var body = json.decode(response) as List;
    return body.map((e) => LocationDTO.fromJson(e as Map<String, dynamic>)).toList();
  });
}

Future<LocationDTO> fetchLocation(String identifier) async {
  return fetch('/public/location/$identifier', 'location-$identifier', (response) {
    return LocationDTO.fromJson(json.decode(response) as Map<String, dynamic>);
  });
}

Future<List<VereinOverviewDTO>> fetchVereine() async {
  return fetch('/public/verein/overview', 'vereine', (response) {
    var body = json.decode(response) as List;
    return body.map((e) => VereinOverviewDTO.fromJson(e as Map<String, dynamic>)).toList();
  });
}

Future<VereinDetailDTO> fetchVerein(String identifier) async {
  return fetch('/public/verein/$identifier', 'verein-$identifier', (response) {
    return VereinDetailDTO.fromJson(json.decode(response) as Map<String, dynamic>);
  });
}

Future<List<TimetableDayOverviewDTO>> fetchTimetable() async {
  return fetch('/public/timetable', 'timetable', (response) {
    var body = json.decode(response) as List;
    return body.map((e) => TimetableDayOverviewDTO.fromJson(e as Map<String, dynamic>)).toList();
  });
}

Future<SponsoringDTO> fetchSponsoring() async {
  return fetch('/public/sponsoring', 'sponsoring', (response) {
    return SponsoringDTO.fromJson(json.decode(response) as Map<String, dynamic>);
  });
}

Future<List<UnterhaltungTypeDTO>> fetchUnterhaltung() async {
  return fetch('/public/unterhaltung', 'unterhaltung', (response) {
    var body = json.decode(response) as List;
    return body.map((e) => UnterhaltungTypeDTO.fromJson(e as Map<String, dynamic>)).toList();
  });
}

Future<UnterhaltungsEntryDTO> fetchUnterhaltungDetail(String identifier) async {
  return fetch('/public/unterhaltung/band/$identifier', 'unterhaltung-$identifier', (response) {
    return UnterhaltungsEntryDTO.fromJson(json.decode(response) as Map<String, dynamic>);
  });
}

Future<List<FestprogrammDayDTO>> fetchFestprogramm() async {
  return fetch('/public/festprogramm', 'festprogramm', (response) {
    var body = json.decode(response) as List;
    return body.map((e) => FestprogrammDayDTO.fromJson(e as Map<String, dynamic>)).toList();
  });
}

Future<List<JudgeDTO>> fetchJudges() async {
  return fetch('/public/judge', 'judges', (response) {
    var body = json.decode(response) as List;
    return body.map((e) => JudgeDTO.fromJson(e as Map<String, dynamic>)).toList();
  });
}

Future<SponsorDTO> fetchRandomSponsor() async {
  final response = await http.get(Uri.parse('$baseUrl/public/sponsoring/random'));

  if (response.statusCode == 200) {
    return SponsorDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load random sponsor');
  }
}

Future<AppPageDTO> fetchAppPage(int id) async {
  return fetch('/public/app-page/$id', 'page-$id', (response) {
    return AppPageDTO.fromJson(json.decode(response) as Map<String, dynamic>);
  });
}

Future<List<AppPageDTO>> fetchNews() async {
  return fetch('/public/app-page/news', 'news', (response) {
    var body = json.decode(response) as List;
    return body.map((e) => AppPageDTO.fromJson(e as Map<String, dynamic>)).toList();
  });
}

Future<bool> hasEmergencyMessage() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/public/emergency'));
    return response.statusCode == 200;
  } on Exception {
    return false;
  }
}

Future<EmergencyMessageDTO> fetchEmergencyMessage() async {
  final response = await http.get(Uri.parse('$baseUrl/public/emergency'));

  if (response.statusCode == 200) {
    return EmergencyMessageDTO.fromJson(json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  } else if (response.statusCode == 404) {
    return EmergencyMessageDTO("keine Nachrichten", "Momentan keine Informationen vorhanden");
  } else {
    throw Exception('Failed to load emergency message');
  }
}

Future<bool> hasRankings() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/public/ranking/available'));
    return response.statusCode == 200;
  } on Exception {
    return false;
  }
}

Future<List<RankingListDTO>> fetchRankings() async {
  return fetch('/public/ranking', 'rankings', (response) {
    var body = json.decode(response) as List;
    return body.map((e) => RankingListDTO.fromJson(e as Map<String, dynamic>)).toList();
  });
}

Future<RankingListDTO> fetchRanking(int id) async {
  return fetch('/public/ranking/$id', 'ranking-$id', (response) {
    return RankingListDTO.fromJson(json.decode(response) as Map<String, dynamic>);
  });
}

Future<VereinMemberInfoDTO> fetchMemberInfo(String identifier) async {
  return fetch('/public/verein/member/$identifier', 'member-info-$identifier', (response) {
    return VereinMemberInfoDTO.fromJson(json.decode(response) as Map<String, dynamic>);
  });
}
