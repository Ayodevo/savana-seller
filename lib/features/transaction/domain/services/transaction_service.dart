
import 'package:sixvalley_vendor_app/features/transaction/domain/repositories/transaction_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/transaction/domain/services/transaction_service_interface.dart';

class TransactionService implements TransactionServiceInterface{
  final TransactionRepositoryInterface transactionRepoInterface;
  TransactionService({required this.transactionRepoInterface});

  @override
  Future getMonthTypeList() {
    return transactionRepoInterface.getMonthTypeList();
  }

  @override
  Future getTransactionList(String status, String from, String to) {
   return transactionRepoInterface.getTransactionList(status, from, to);
  }

  @override
  Future getYearList() {
    return transactionRepoInterface.getYearList();
  }
}