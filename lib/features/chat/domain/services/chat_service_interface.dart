import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/features/chat/domain/models/message_body.dart';

abstract class ChatServiceInterface {
  Future<dynamic> getChatList(String type, int offset);
  Future<dynamic> searchChat(String type, String search);
  Future<dynamic> getMessageList(String type, int offset, int? id);
  Future<dynamic> sendMessage(MessageBody messageBody, String type, List<XFile?> file,  List<PlatformFile>? platformFile);
}