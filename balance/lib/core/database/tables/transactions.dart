import 'package:drift/drift.dart';

class Transactions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get amount => integer().withDefault(const Constant(0))();
  BoolColumn get isIncome => boolean().withDefault(const Constant(true))();

  TextColumn get groupId => text()
      .customConstraint('NOT NULL REFERENCES groups(id) ON DELETE CASCADE')();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
