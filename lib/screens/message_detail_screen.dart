import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.room,
  });

  final types.Room room;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;
  String locationMessage = "";
  var position;

  double locLatitude = 0;
  double locLongitude = 0;
  String phoneNumber = '';
  bool isLocation = true;


  @override
  void initState() {
    _backgroundServiceStop();
    _getUserInfo();
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      _getUserInfo();
    });
    addNewLocation();
  }

  _backgroundServiceStop() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    }
    setState(() {});
  }

  _backgroundServiceStart() async {
    final service = FlutterBackgroundService();
    service.startService();
    setState(() {});
  }


  void dispose() {
    super.dispose();
    _backgroundServiceStart();
  }

  Future<void> addNewLocation() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    final CollectionReference users = FirebaseFirestore.instance.collection('drivers');
    Position position = await Geolocator.getCurrentPosition();

      try {

        await users
            .doc(authProvider.currentUser?.userId)
            .update({
          'latitude': position.latitude,
          'longitude': position.longitude,
        }).then((value) {

          print('Yeni konum eklendi');
          print(position.latitude.toString());
          print(position.longitude.toString());
        });

      } catch (error) {
        print('Hata: $error');
      }
    }

  Future<void> hideLocation() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    final CollectionReference users = FirebaseFirestore.instance.collection('drivers');


    try {

      await users
          .doc(authProvider.currentUser?.userId)
          .update({
        'latitude': 0.1,
        'longitude': 0.1,
      }).then((value) {

        print('Konum Gizlendi!');
      });

    } catch (error) {
      print('Hata: $error');
    }
  }

  Future<dynamic> _getUserInfo() async {

    final CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {

      await users.doc(widget.room.users.last.id).get().then(
            (value) {
              setState(() {
                locLatitude = value['latitude'];
                locLongitude = value['longitude'];
                phoneNumber = value['phoneNumber'];
              });
        },
      );
    } catch (error) {
      print('Hata: $error');
    }
  }

  Future<dynamic> _openMaps() async {

    String mapUrl = 'https://www.google.com/maps/search/?api=1&query=$locLatitude,$locLongitude';

    if (await canLaunch(mapUrl)) {
      await launch(mapUrl);
    } else {
      throw 'Harita uygulamasını başlatamadı';
    }
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 215,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    isLocation = !isLocation;
                    if (isLocation) {
                      addNewLocation();
                    } else {
                      hideLocation();
                    }
                  });
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Share your Location'),
                      isLocation ? Icon(Icons.check) : Container()
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: Alignment.centerLeft,
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
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );

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
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  _callNumber() async{
    final call = Uri.parse('tel:${phoneNumber}');
    if (await canLaunchUrl(call)) {
      launchUrl(call);
    } else {
      throw 'Could not launch $call';
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const Text('Chat'),
          actions: [
            IconButton(
                onPressed: _callNumber,
                icon: Icon(Icons.call)
            ),
            locLongitude == 0.1 && locLatitude == 0.1 ? SizedBox() :
            IconButton(
                onPressed: () {
                  if (locLongitude == 0.1 && locLatitude == 0.1) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Diqqət'),
                          content: Text('İstifadəçi məkanı paylaşmır!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Yaxın'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    _openMaps();
                  }
                },
                icon: Icon(Icons.location_history)
            )
          ],
          
        ),
        body: StreamBuilder<types.Room>(
          initialData: widget.room,
          stream: FirebaseChatCore.instance.room(widget.room.id),
          builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) => Chat(
              isAttachmentUploading: _isAttachmentUploading,
              messages: snapshot.data ?? [],
              onAttachmentPressed: _handleAtachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              user: types.User(
                id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
              ),
            ),
          ),
        ),
      );
}