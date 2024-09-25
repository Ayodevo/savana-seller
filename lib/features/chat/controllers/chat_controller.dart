import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/chat/domain/models/message_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/chat/domain/models/chat_model.dart';
import 'package:sixvalley_vendor_app/features/chat/domain/models/message_model.dart';
import 'package:sixvalley_vendor_app/features/chat/domain/services/chat_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/image_size_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

enum SenderType {
  customer,
  seller,
  admin,
  deliveryMan,
  unknown
}

class ChatController extends ChangeNotifier {
  final ChatServiceInterface chatServiceInterface;
  ChatController({required this.chatServiceInterface});


  List<Chat>? _chatList;
  List<Chat>? get chatList => _chatList;
  bool _isSendButtonActive = false;
  bool get isSendButtonActive => _isSendButtonActive;
  int _userTypeIndex = 0;
  int get userTypeIndex =>  _userTypeIndex;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  ChatModel? _chatModel;
  ChatModel? get chatModel => _chatModel;

  List<dynamic> _messageList = [];
  List<dynamic>? get messageList => _messageList;

  List<Message> _allMessageList=[];
  List<Message>? get allMessageList => _allMessageList;

  List<String> _dateList = [];
  List<String>? get dateList => _dateList;

  MessageModel? messageModel;

  bool _pickedFIleCrossMaxLimit = false;
  bool get pickedFIleCrossMaxLimit => _pickedFIleCrossMaxLimit;

  bool _pickedFIleCrossMaxLength = false;
  bool get pickedFIleCrossMaxLength => _pickedFIleCrossMaxLength;

  bool _singleFIleCrossMaxLimit = false;
  bool get singleFIleCrossMaxLimit => _singleFIleCrossMaxLimit;

  List<PlatformFile>? objFile;


  String _onImageOrFileTimeShowID = '';
  String get onImageOrFileTimeShowID => _onImageOrFileTimeShowID;

  bool _isClickedOnImageOrFile = false;
  bool get isClickedOnImageOrFile => _isClickedOnImageOrFile;

  bool _isClickedOnMessage = false;
  bool get isClickedOnMessage => _isClickedOnMessage;

  String _onMessageTimeShowID = '';
  String get onMessageTimeShowID => _onMessageTimeShowID;

  bool _openEmojiPicker = false;
  bool get openEmojiPicker => _openEmojiPicker;



  Future<void> getMessageList(int? id, int offset, {bool reload = true}) async {
    if(reload){
      _messageList = [];
      messageModel = null;
      _dateList = [];
      _allMessageList = [];
    }
    //_messageList = null;
    ApiResponse apiResponse = await chatServiceInterface.getMessageList(_userTypeIndex == 0 ? 'customer' : 'delivery-man', offset, id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1) {
        messageModel = null;
        _dateList = [];
        _messageList = [];
        _allMessageList = [];

        messageModel = MessageModel.fromJson(apiResponse.response!.data);
        messageModel!.totalSize =  MessageModel.fromJson(apiResponse.response!.data).totalSize;
        messageModel!.offset =  MessageModel.fromJson(apiResponse.response!.data).offset;

        for (var data in messageModel!.message!) {
          if(!_dateList.contains(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)))) {
            dateList!.add(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)));
          }
          _allMessageList.add(data);
        }

        for(int i=0; i< dateList!.length; i++){
          messageList!.add([]);
          for (var element in _allMessageList) {
            if(_dateList[i]== DateConverter.dateStringMonthYear(DateTime.tryParse(element.createdAt!))){
              _messageList[i].add(element);
            }
          }
        }
      } else {
        messageModel = MessageModel(message: [], totalSize: 0, offset: '0');
        messageModel?.message = [];
        messageModel!.totalSize =  MessageModel.fromJson(apiResponse.response!.data).totalSize;
        messageModel!.offset =  MessageModel.fromJson(apiResponse.response!.data).offset;
        messageModel!.message!.addAll(MessageModel.fromJson(apiResponse.response!.data).message!) ;

        for (var data in messageModel!.message!) {
          if(!_dateList.contains(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)))) {
            dateList!.add(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)));
          }
          _allMessageList.add(data);
        }

        for(int i=0; i< dateList!.length; i++) {
          messageList!.add([]);
          for (var element in _allMessageList) {
            if(_dateList[i]== DateConverter.dateStringMonthYear(DateTime.tryParse(element.createdAt!))){
              _messageList[i].add(element);
            }}
        }
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }


  Future<void> getChatList(BuildContext context, int offset, {bool reload = false}) async {
    if(reload){
      _chatModel = null;
    }
    _isLoading = true;
    ApiResponse apiResponse = await chatServiceInterface.getChatList(_userTypeIndex == 0 ? 'customer' : 'delivery-man', offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1) {
        _chatModel = null;
        _chatModel = ChatModel.fromJson(apiResponse.response!.data);
      }else {
        _chatModel!.totalSize = ChatModel.fromJson(apiResponse.response!.data).totalSize;
        _chatModel!.offset = ChatModel.fromJson(apiResponse.response!.data).offset;
        _chatModel!.chat!.addAll(ChatModel.fromJson(apiResponse.response!.data).chat!);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchedChatList(BuildContext context, String search) async {
    ApiResponse apiResponse = await chatServiceInterface.searchChat(_userTypeIndex == 0 ? 'customer' : 'delivery-man', search);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _chatModel = ChatModel(totalSize: 10, limit: '10', offset: '1', chat: []);
      apiResponse.response!.data.forEach((chat) {_chatModel!.chat!.add(Chat.fromJson(chat));});
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }


  Future<http.StreamedResponse> sendMessage(MessageBody messageBody,) async {
    if(kDebugMode){
      print("===api call===id = ${messageBody.userId}");
    }
    _isLoading = true;
    notifyListeners();
    http.StreamedResponse response = await chatServiceInterface.sendMessage(messageBody,_userTypeIndex == 0? 'customer' : 'delivery-man' ,_pickedImageFiles, objFile ?? []);
    if (response.statusCode == 200) {
      getMessageList(messageBody.userId, 1, reload: false);
      _pickedImageFiles = [];
      pickedImageFileStored = [];
      objFile= [];
      _isLoading = false;
      _isSendButtonActive = false;
    } else {
      _isLoading = false;
    }
    _pickedImageFiles = [];
    pickedImageFileStored = [];
    getChatList(Get.context!, 1, reload: false);
    _isLoading = false;
    notifyListeners();
    return response;
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setUserTypeIndex(BuildContext context, int index) {
    _userTypeIndex = index;
    _chatModel = null;
    getChatList(context, 1);
    notifyListeners();
  }

  List <XFile> _pickedImageFiles =[];
  List <XFile>? get pickedImageFile => _pickedImageFiles;
  List <XFile>?  pickedImageFileStored = [];
  void pickMultipleImage(bool isRemove,{int? index}) async {
    _pickedFIleCrossMaxLimit = false;
    _pickedFIleCrossMaxLength = false;
    if(isRemove) {
      if(index != null){
        pickedImageFileStored?.removeAt(index);
      }
    }else {
      _pickedImageFiles = await ImagePicker().pickMultiImage(imageQuality: 40);
      pickedImageFileStored?.addAll(_pickedImageFiles);
    }
    if(pickedImageFileStored!.length > AppConstants.maxLimitOfTotalFileSent){
      _pickedFIleCrossMaxLength = true;
    }
    if( _pickedImageFiles.length == AppConstants.maxLimitOfTotalFileSent && await ImageSize.getMultipleImageSizeFromXFile(pickedImageFileStored!) > AppConstants.maxLimitOfFileSentINConversation){
      _pickedFIleCrossMaxLimit = true;
    }
    notifyListeners();
  }



  String getChatTime (String todayChatTimeInUtc , String? nextChatTimeInUtc) {
    String chatTime = '';
    DateTime todayConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(todayChatTimeInUtc);

    DateTime nextConversationDateTime;
    DateTime currentDate = DateTime.now();

    if(nextChatTimeInUtc == null){
      String chatTime = DateConverter.isoStringToLocalDateAndTime(todayChatTimeInUtc);
      return chatTime;
    }else{
      nextConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(nextChatTimeInUtc);
      if(todayConversationDateTime.difference(nextConversationDateTime) < const Duration(minutes: 30) &&
          todayConversationDateTime.weekday == nextConversationDateTime.weekday){
        chatTime = '';
      }else if(currentDate.weekday != todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) < 6){

        if( (currentDate.weekday -1 == 0 ? 7 : currentDate.weekday -1) == todayConversationDateTime.weekday){
          chatTime = DateConverter.convert24HourTimeTo12HourTimeWithDay(todayConversationDateTime, false);
        }else{
          chatTime = DateConverter.convertStringTimeToDate(todayConversationDateTime).toString();
        }
      }else if(currentDate.weekday == todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) < 6){
        chatTime = DateConverter.convert24HourTimeTo12HourTimeWithDay(todayConversationDateTime, true);
      }else{
        chatTime = DateConverter.isoStringToLocalDateAndTime(todayChatTimeInUtc);
      }
    }

    return chatTime;
  }



  bool isSameUserWithPreviousMessage(Message? previousConversation, Message currentConversation){
    if(getSenderType(previousConversation) == getSenderType(currentConversation) && previousConversation?.message != null && currentConversation.message !=null){
      return true;
    }
    return false;
  }
  bool isSameUserWithNextMessage( Message currentConversation, Message? nextConversation){
    if(getSenderType(currentConversation) == getSenderType(nextConversation) && nextConversation?.message != null && currentConversation.message !=null){
      return true;
    }
    return false;
  }

  SenderType getSenderType(Message? senderData) {
    if (senderData?.sentByCustomer == true) {
      return SenderType.customer;
    } else if (senderData?.sentBySeller == true) {
      return SenderType.seller;
    } else if (senderData?.sentByDeliveryMan == true) {
      return SenderType.deliveryMan;
    } else {
      return SenderType.unknown;
    }
  }


  String getChatTimeWithPrevious (Message currentChat, Message? previousChat) {
    DateTime todayConversationDateTime = DateConverter
        .isoUtcStringToLocalTimeOnly(currentChat.createdAt ?? "");

    DateTime previousConversationDateTime;

    if (previousChat?.createdAt == null) {
      return 'Not-Same';
    } else {
      previousConversationDateTime =
          DateConverter.isoUtcStringToLocalTimeOnly(previousChat!.createdAt!);
      if (kDebugMode) {
        print("The Difference is ${previousConversationDateTime.difference(todayConversationDateTime) < const Duration(minutes: 30)}");
      }
      if (previousConversationDateTime.difference(todayConversationDateTime) <
          const Duration(minutes: 30) &&
          todayConversationDateTime.weekday ==
              previousConversationDateTime.weekday && isSameUserWithPreviousMessage(currentChat, previousChat)) {
        return '';
      } else {
        return 'Not-Same';
      }
    }
  }

  void downloadFile(String url, String dir, String openFileUrl, String fileName) async {

    var snackBar = const SnackBar(content: Text('Downloading....'),backgroundColor: Colors.black54, duration: Duration(seconds: 1),);
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);

    final task  = await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir,
      fileName: fileName,
      showNotification: true,
      saveInPublicStorage: true,
      openFileFromNotification: true,
    );

    if(task !=null){
      await OpenFile.open(openFileUrl);
    }
  }


  Future<void> pickOtherFile(bool isRemove, {int? index}) async {
    _pickedFIleCrossMaxLimit = false;
    _pickedFIleCrossMaxLength = false;
    _singleFIleCrossMaxLimit = false;
    List<String> allowedExtensions = ['doc', 'docx', 'txt', 'csv', 'xls', 'xlsx', 'rar', 'tar', 'targz', 'zip', 'pdf'];

    if(isRemove){
      if(objFile!=null){
        objFile!.removeAt(index!);
      }
      if(objFile!.isEmpty){
        _isSendButtonActive = false;
      }
    }else{

      List<PlatformFile>? platformFile = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
        withReadStream: true,
      ))?.files ;

      objFile = [];
      // _pickedImageFiles = [];
      // pickedImageFileStored = [];

      platformFile?.forEach((element) {
        if(ImageSize.getFileSizeFromPlatformFileToDouble(element) > AppConstants.maxSizeOfASingleFile) {
          _singleFIleCrossMaxLimit = true;
        } else{
          if(!allowedExtensions.contains(element.extension)){
            showCustomSnackBarWidget(getTranslated('file_type_should_be', Get.context!), Get.context!, sanckBarType: SnackBarType.warning);
          }else if(  objFile!.length < AppConstants.maxLimitOfTotalFileSent){
            if((ImageSize.getMultipleFileSizeFromPlatformFiles(objFile!) + ImageSize.getFileSizeFromPlatformFileToDouble(element)) < AppConstants.maxLimitOfFileSentINConversation){
              objFile!.add(element);
            }
          }
        }
      });

      if(objFile?.length == AppConstants.maxLimitOfTotalFileSent && platformFile != null &&   platformFile.length > AppConstants.maxLimitOfTotalFileSent){
        _pickedFIleCrossMaxLength = true;
      }
      if(objFile?.length == AppConstants.maxLimitOfTotalFileSent && platformFile != null && ImageSize.getMultipleFileSizeFromPlatformFiles(platformFile) > AppConstants.maxLimitOfFileSentINConversation){
        _pickedFIleCrossMaxLimit = true;
      }
    }
    _isSendButtonActive = true;
    notifyListeners();
  }


  void toggleOnClickMessage ({required String onMessageTimeShowID}) {
    _onImageOrFileTimeShowID = '';
    _isClickedOnImageOrFile = false;
    if(_isClickedOnMessage && _onMessageTimeShowID != onMessageTimeShowID){
      _onMessageTimeShowID = onMessageTimeShowID;
    }else if(_isClickedOnMessage && _onMessageTimeShowID == onMessageTimeShowID){
      _isClickedOnMessage = false;
      _onMessageTimeShowID = '';
    }else{
      _isClickedOnMessage = true;
      _onMessageTimeShowID = onMessageTimeShowID;
    }
    notifyListeners();
  }


  String? getOnPressChatTime(Message currentConversation){
    if(currentConversation.id.toString() == _onMessageTimeShowID || currentConversation.id.toString() == _onImageOrFileTimeShowID){
      DateTime currentDate = DateTime.now();
      DateTime todayConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(
          currentConversation.createdAt ?? ""
      );

      if(currentDate.weekday != todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) <= 7){
        return DateConverter.convertStringTimeToDateChatting(todayConversationDateTime);
      }else if(currentDate.weekday == todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) <= 7){
        return  DateConverter.convert24HourTimeTo12HourTime(todayConversationDateTime);
      }else{
        return DateConverter.isoStringToLocalDateAndTime(currentConversation.createdAt!);
      }
    }else{
      return null;
    }
  }


  void setEmojiPickerValue(bool value, {bool notify = true}){
    _openEmojiPicker = value;
    if(notify){
      notifyListeners();
    }
  }


}
