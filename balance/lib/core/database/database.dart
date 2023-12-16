import 'dart:io';

import 'package:balance/core/database/tables/groups.dart';
import 'package:balance/core/database/tables/transactions.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@lazySingleton
@DriftDatabase(tables: [Groups, Transactions])
class Database extends _$Database {
  Database() : super(_openConnection());

  static Future<String> resourcePath(String name) async =>
      p.join(await _resourcesPath, name);

  static Future<String> get _resourcesPath async {
    final path = p.join(await _rootPath, "resources");
    final dir = Directory(path);
    await dir.create();
    return dir.path;
  }

  static Future<String> get _rootPath async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(dbFolder.path, 'database'));
    await dir.create();
    return dir.path;
  }

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() => LazyDatabase(() async {
        final file = File(p.join(await Database._rootPath, 'db.sqlite'));
        return NativeDatabase(file);
      });
}
