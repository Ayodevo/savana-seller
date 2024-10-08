class TransactionModel {
  int? _id;
  int? _sellerId;
  int? _adminId;
  double? _amount;
  String? _transactionNote;
  int? _approved;
  String? _createdAt;
  String? _updatedAt;

  TransactionModel(
      {int? id,
        int? sellerId,
        int? adminId,
        double? amount,
        String? transactionNote,
        int? approved,
        String? createdAt,
        String? updatedAt}) {
    _id = id;
    _sellerId = sellerId;
    _adminId = adminId;
    _amount = amount;
    _transactionNote = transactionNote;
    _approved = approved;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get sellerId => _sellerId;
  int? get adminId => _adminId;
  double? get amount => _amount;
  String? get transactionNote => _transactionNote;
  int? get approved => _approved;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  TransactionModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _sellerId = int.parse(json['seller_id'].toString());
    _adminId = json['admin_id'];
    _amount = double.parse(json['amount'].toString());
    _transactionNote = json['transaction_note'];
    _approved = json['approved'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['seller_id'] = _sellerId;
    data['admin_id'] = _adminId;
    data['amount'] = _amount;
    data['transaction_note'] = _transactionNote;
    data['approved'] = _approved;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}