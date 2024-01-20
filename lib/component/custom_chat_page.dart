import 'dart:io';

import 'package:coinxfiat/constants/constants_index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../utils/utils_index.dart';

ValueNotifier<bool> loadingMore = ValueNotifier(false);

class CustomChatWidget extends StatefulWidget {
  const CustomChatWidget({
    super.key,
    this.appBar,
    this.hideInput = false,
    required this.user,
    required this.messagesList,
    this.enableImageSelection = true,
    this.enableFileSelection = false,
    this.showUserAvatar = true,
    required this.onSendPressed,
    required this.loading,
    this.onLoadMore,
  });
  final Widget Function(List<types.Message> messages, types.User user)? appBar;
  final bool hideInput;
  final types.User user;
  final bool enableImageSelection;
  final bool enableFileSelection;
  final bool showUserAvatar;

  final Future<bool> Function(dynamic message) onSendPressed;
  final Future<void> Function()? onLoadMore;
  final ValueNotifier<List<types.Message>> messagesList;
  final ValueNotifier<bool> loading;
  @override
  State<CustomChatWidget> createState() => _CustomChatWidgetState();
}

class _CustomChatWidgetState extends State<CustomChatWidget> {
  final chatController = TextEditingController();
  ValueNotifier<bool> sendingText = ValueNotifier(false);
  ValueNotifier<bool> sendingFile = ValueNotifier(false);
  final FocusNode _focusNode = FocusNode();
  // final widget.user = const types.User(
  //   id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  // );

  @override
  void initState() {
    super.initState();
    loadingMore.value = false;
    widget.messagesList.addListener(() {
      pl('a new message added', 'listener');
    });
    _loadMessages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addMessage(types.Message message) {
    p(message.toJson());
    widget.messagesList.value.insert(0, message);
    setState(() {});
  }

  sendFileMessages() async {
    widget.enableImageSelection && widget.enableFileSelection
        ? _handleAttachmentPressed()
        : widget.enableImageSelection
            ? _handleImageSelection()
            : widget.enableFileSelection
                ? _handleFileSelection()
                : null;
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
        imageQuality: 70, maxWidth: 1440, source: ImageSource.gallery);
    sendingFile.value = true;
    await widget.onSendPressed(result);
    sendingFile.value = false;
    return;

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final message = types.ImageMessage(
        author: widget.user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: 'https://wallpapers.com/images/featured/hd-a5u9zq0a0ymy2dug.jpg',
        // uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index = widget.messagesList.value
              .indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (widget.messagesList.value[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            widget.messagesList.value[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index = widget.messagesList.value
              .indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (widget.messagesList.value[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            widget.messagesList.value[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = widget.messagesList.value
        .indexWhere((element) => element.id == message.id);
    final updatedMessage =
        (widget.messagesList.value[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );
    widget.messagesList.value[index] = updatedMessage;
  }

  void _handleSendPressed(types.PartialText message) async {
    if (message.text.trim().isEmpty) return;
    chatController.clear();
    _focusNode.requestFocus();
    sendingText.value = true;
    await widget.onSendPressed(message.text.trim());
    sendingText.value = false;
    // final textMessage = types.TextMessage(
    //   author: widget.user,
    //   createdAt: DateTime.now().millisecondsSinceEpoch,
    //   id: const Uuid().v4(),
    //   text: message.text,
    // );

    // _addMessage(textMessage);
  }

  void _loadMessages() async {
    // pl('Loading messages... ${widget.user.id}');
    // final messages = tryCatch(
    //         () => chatJson.map((e) => types.Message.fromJson(e)).toList()) ??
    //     [];
    // widget.messagesList.value = messages;
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    sendingFile.value = true;
    await widget.onSendPressed(result);
    sendingFile.value = false;
    return;
    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: widget.user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget chat = ValueListenableBuilder<bool>(
        valueListenable: widget.loading,
        builder: (_, loading, __) {
          return ValueListenableBuilder<bool>(
              valueListenable: loadingMore,
              builder: (_, _loadingMore, __) {
                return ValueListenableBuilder<List<types.Message>>(
                    valueListenable: widget.messagesList,
                    builder: (_, messages, __) {
                      pl('messages.length  ${messages.length} loading $loading',
                          'CustomChatWidget');
                      return Chat(
                        messages: [...messages],
                        // onAttachmentPressed: _handleAttachmentPressed,
                        onMessageTap: _handleMessageTap,
                        onPreviewDataFetched: _handlePreviewDataFetched,
                        onSendPressed: _handleSendPressed,
                        showUserAvatars: widget.showUserAvatar,
                        showUserNames: true,
                        isAttachmentUploading: true,
                        // dateIsUtc: true,
                        dateLocale: 'en_US',
                        dateFormat: DateFormat('dd MMM yyyy'),
                        user: widget.user,
                        isLastPage: false,
                        onEndReached: () async {
                          if (_loadingMore) return;
                          pl('loading more $_loadingMore');
                          loadingMore.value = true;
                          await widget.onLoadMore?.call();
                          loadingMore.value = false;
                        },
                        imageMessageBuilder:
                            (p0, {required int messageWidth}) => Column(
                          children: [
                            netImages(
                              p0.uri,
                              width: messageWidth.toDouble(),
                              // height: p0.height.validate().toDouble(),
                              fitP: BoxFit.contain,
                              borderRadius: 0,
                              placeholder: MyPng.logo,
                              heightP: 100,
                              paddingP: 10,
                            ),
                            if (p0.repliedMessage != null &&
                                p0.repliedMessage! is types.TextMessage)
                              Container(
                                padding: const EdgeInsets.all(8),
                                width: messageWidth.toDouble(),
                                child: Text(
                                  (p0.repliedMessage! as types.TextMessage)
                                      .text,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        onEndReachedThreshold: -200,
                        emptyState: loading
                            ? Center(
                                child: assetLottie(MyLottie.chatLoading,
                                    width: 100, height: 70))
                            : messages.isEmpty
                                ? const Center(child: Text('No messages yet'))
                                : const Text(''),

                        customBottomWidget: !widget.hideInput
                            ? _customBottomWidget(context)
                            : const SizedBox.shrink(),
                        // customBottomWidget: _customBottomWidget(context),
                      );
                    });
              });
        });

    return ValueListenableBuilder<List<types.Message>>(
        valueListenable: widget.messagesList,
        builder: (_, messages, __) {
          return Column(
            children: [
              if (widget.appBar != null)
                widget.appBar!.call(messages, widget.user),
              Expanded(child: chat),
              if (widget.hideInput) const SizedBox.shrink(),
            ],
          );
        });

    ///show keyboard
    return Expanded(
      child: Scaffold(
        // appBar: widget.appBar?.call(_messages, widget.user),
        appBar: AppBar(
          title: const TextField(),
        ),
        body: Column(
          children: [
            Expanded(child: chat),
          ],
        ),
      ),
    );
  }

  Widget _customBottomWidget(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: sendingText,
        builder: (_, sending, __) {
          return ValueListenableBuilder<bool>(
              valueListenable: sendingFile,
              builder: (_, sendingfile, __) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: DEFAULT_PADDING / 2),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: const BorderRadiusDirectional.vertical(
                        top: Radius.circular(DEFAULT_PADDING)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  width: context.width(),
                  child: Row(
                    children: [
                      if (sendingfile)
                        SizedBox(
                                height: 24,
                                width: 24,
                                child:
                                    assetLottie(MyLottie.uploadingCircleArrow)
                                // CircularProgressIndicator(
                                // backgroundColor: Colors.white, strokeWidth: 2),
                                )
                            .paddingAll(DEFAULT_PADDING / 1.5)
                      else
                        IconButton(
                            // onPressed: _handleAttachmentPressed,
                            onPressed: sendFileMessages,
                            icon: const FaIcon(FontAwesomeIcons.fileCirclePlus,
                                color: Colors.white)),
                      Expanded(
                        child: TextField(
                          controller: chatController,
                          // autofocus: true,
                          focusNode: _focusNode,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintText: 'Type a message',
                          ),
                          onSubmitted: (value) => _handleSendPressed(
                              types.PartialText(text: value.trim())),
                        ),
                      ),
                      if (sending)
                        const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white, strokeWidth: 2),
                        ).paddingAll(DEFAULT_PADDING / 1.5)
                      else
                        IconButton(
                          onPressed: () => _handleSendPressed(types.PartialText(
                              text: chatController.text.trim())),
                          icon: Transform.rotate(
                            angle: -3.14 / 5,
                            child: const Icon(
                              Icons.send,
                              color: Color.fromARGB(255, 250, 250, 250),
                            ),
                          ),
                        ),
                    ],
                  ).paddingBottom(MediaQuery.of(context).viewInsets.bottom > 0
                      ? 0
                      : (defaultTargetPlatform == TargetPlatform.iOS
                          ? DEFAULT_PADDING
                          : 0)),
                );
              });
        });
  }
}

var chatJson = [
  {
    "author": {
      "firstName": "Matthew",
      "id": "82091008-a484-4a89-ae75-a22bf8d6f3ac",
      "lastName": "White"
    },
    "createdAt": 1655624465000,
    "id": "1a2b3c4d-5e6f-7g8h-9i10j11k12l",
    "status": "seen",
    "text": "Just booked tickets for a Madrid city tour! 🏰✈️",
    "type": "text"
  },
  {
    "author": {
      "firstName": "Janice",
      "id": "e52552f4-835d-4dbe-ba77-b076e659774d",
      "imageUrl":
          "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
      "lastName": "King"
    },
    "createdAt": 1655624466000,
    "id": "m1n2o3p4q5r6s7t8u9v0w1x2y3z4",
    "status": "seen",
    "text": "That sounds amazing! Take lots of pictures! 📸",
    "type": "text"
  },
  {
    "author": {
      "firstName": "John",
      "id": "4c2307ba-3d40-442f-b1ff-b271f63904ca",
      "lastName": "Doe"
    },
    "createdAt": 1655624467000,
    "id": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6",
    "status": "seen",
    "text": "I love Madrid! Have you visited the Prado Museum yet?",
    "type": "text"
  },
  {
    "author": {
      "firstName": "Matthew",
      "id": "82091008-a484-4a89-ae75-a22bf8d6f3ac",
      "lastName": "White"
    },
    "createdAt": 1655624468000,
    "id": "b1c2d3e4f5g6h7i8j9k0l1m2n3o4p5q6r7s8t9u0v1w2x3y4z5",
    "status": "seen",
    "text": "Yes, the Prado Museum is on my list! Can't wait to explore it. 🎨",
    "type": "text"
  },
  {
    "author": {
      "firstName": "Janice",
      "id": "e52552f4-835d-4dbe-ba77-b076e659774d",
      "imageUrl":
          "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
      "lastName": "King"
    },
    "createdAt": 1655624469000,
    "id": "c1d2e3f4g5h6i7j8k9l0m1n2o3p4q5r6s7t8u9v0w1x2y3z4",
    "status": "seen",
    "text": "The architecture in Madrid is breathtaking. Enjoy your trip! 🌆",
    "type": "text"
  }
];
