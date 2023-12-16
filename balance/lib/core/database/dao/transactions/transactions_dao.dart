import 'package:balance/core/database/database.dart';
import 'package:balance/core/database/tables/transactions.dart'; // Assuming your Transactions table definition file is imported here
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

part 'transactions_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [
  Transactions
]) // Include the Transactions table in the DriftAccessor annotation
class TransactionsDao extends DatabaseAccessor<Database>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  Future insertTransaction(int amount, String groupId, bool isIncome) {
    return into(transactions).insert(TransactionsCompanion.insert(
      id: const Uuid().v1(),
      createdAt: DateTime.now(),
      amount: Value(amount),
      groupId: groupId,
      isIncome: Value(isIncome),
    ));
  }

  Future<void> updateTransactionAmount(String transactionId, int newAmount) {
    return (update(transactions)..where((tbl) => tbl.id.equals(transactionId)))
        .write(TransactionsCompanion(
      amount: Value(newAmount),
    ));
  }

  Stream<List<Transaction>> watchTransactions() => select(transactions).watch();

  Stream<Transaction?> watchTransaction(String transactionId) {
    return (select(transactions)..where((tbl) => tbl.id.equals(transactionId)))
        .watchSingleOrNull();
  }

  Stream<List<Transaction>> watchTransactionsByGroup(String groupId) {
    return (select(transactions)
          ..where((tbl) => tbl.groupId.equals(groupId))
          ..orderBy([
            (tbl) => OrderingTerm(
                expression: tbl.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }
}
