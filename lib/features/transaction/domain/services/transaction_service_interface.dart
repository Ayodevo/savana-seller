abstract class TransactionServiceInterface {
  Future<dynamic> getTransactionList(String status, String from, String to);
  Future<dynamic> getMonthTypeList();
  Future<dynamic> getYearList();
}