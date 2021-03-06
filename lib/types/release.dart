
// TODO(denis): Change to JsonSerializable and generate Json code,

import 'author.dart';
import 'deploy.dart';
import 'stat.dart';

class Release {
  Release.fromJson(dynamic json)
      : version = json['versionInfo']['description'] as String,
        project = json['projects'][0]['slug'] as String,
        dateCreated = json['dateCreated'] as String == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
        issues = json['newGroups'] as int,
        crashes = json['projects'][0]['healthData']['sessionsCrashed'] as int,
        crashFreeUsers =
          json['projects'][0]['healthData']['crashFreeUsers'] as double,
        crashFreeSessions =
          json['projects'][0]['healthData']['crashFreeSessions'] as double,
        stats24h = (json['projects'][0]['healthData']['stats']['24h'] as List)
          .map((e) => Stat.fromJson(e as List))?.toList(),
        users24h = json['projects'][0]['healthData']['totalUsers24h'] as int,
        usersTotal = json['projects'][0]['healthData']['totalUsers'] as int,
        sessions24h =
          json['projects'][0]['healthData']['totalSessions24h'] as int,
        sessionsTotal =
          json['projects'][0]['healthData']['totalSessions'] as int,
        durationP90 =
          json['projects'][0]['healthData']['durationP90'] as double,
        deploy = json['deploy'] == null
          ? null
          : Deploy.fromJson(json['deploy'] as Map<String, dynamic>),
        authors = (json['authors'] as List).map((e) =>
          Author.fromJson(e as Map<String, dynamic>))?.toList();

  final String version;
  final String project;
  final DateTime dateCreated;
  final int issues;
  final int crashes;
  final double crashFreeUsers;
  final double crashFreeSessions;
  final List<Stat> stats24h;
  final int users24h;
  final int usersTotal;
  final int sessions24h;
  final int sessionsTotal;
  final double durationP90;
  final Deploy deploy;
  final List<Author> authors;
}
