import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'action.dart';
import 'state.dart';

Effect<BangtalCreateState> buildEffect() {
  return combineEffects(<Object, Effect<BangtalCreateState>>{
    BangtalCreatePageAction.action: _onAction,
    BangtalCreatePageAction.submit: _submit,
    BangtalCreatePageAction.themaList: _themaList,
    BangtalCreatePageAction.uploadBackground: _uploadBackground,
    BangtalCreatePageAction.showSnackBar: _showSnackBar,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<BangtalCreateState> ctx) {
  print(
      "===============================================================================111>");
}

Future<void> _onInit(Action action, Context<BangtalCreateState> ctx) async {
  ctx.state.nameTextController = TextEditingController(text: ctx.state.name);
  ctx.state.descriptionTextController =
      TextEditingController(text: ctx.state.description);
  print(
      "===============================================================================2222>");

  final _bangtaktok = await Firestore.instance
      .collection('bangTalCafe')
      //.where("star", isGreaterThanOrEqualTo: 9)
      //  .orderBy('CDATE', descending: true)
      .getDocuments();

  final items = {};

  _bangtaktok.documents.forEach((element) {
    items.addAll({element.documentID: element.data['cafe_name']});

    //  items.addAll({element.documentID , element.data['cafe_name'] + ' ' + element.data['thema']});
    //  print(element.data['cafe_name'] + ' ' + element.data['thema']);
    //  var string = element.documentID.toString();
    ctx.state.cafeList.add(DropdownMenuItem(
      // key: Key(element.documentID),
      child: Text(element.data['area'] + ' / ' + element.data['cafe_name']),
      value: element.data['cafe_name'],
      // key: items[element.documentID],
    ));
  });

  //print(items);

  ctx.dispatch(BangtalCreatePageActionCreator.setLoading(false));
}

Future<void> _themaList(Action action, Context<BangtalCreateState> ctx) async {
  print(ctx.state.selectCafeName);
  final _bangtaktok = await Firestore.instance
      .collection('bangTalCafeThema')
      .where("cafe_name", isEqualTo: ctx.state.selectCafeName)
      //  .orderBy('CDATE', descending: true)
      .getDocuments();

  final items = {};
  ctx.state.themaList = [
    DropdownMenuItem(
      // key: Key(element.documentID),
      child: Text('선택'),
      value: '',
      // key: items[element.documentID],
    )
  ];
  _bangtaktok.documents.forEach((element) {
    items.addAll({element.documentID: element.data['cafe_name']});

    //  items.addAll({element.documentID , element.data['cafe_name'] + ' ' + element.data['thema']});
    //  print(element.data['cafe_name'] + ' ' + element.data['thema']);
    //  var string = element.documentID.toString();
    ctx.state.themaList.add(DropdownMenuItem(
      // key: Key(element.documentID),
      child: Text(element.data['thema']),
      value: element.data['thema'],
      // key: items[element.documentID],
    ));
  });

  //print(items);

  ctx.dispatch(BangtalCreatePageActionCreator.setLoading(false));
}

void _onDispose(Action action, Context<BangtalCreateState> ctx) async {
  ctx.state.nameTextController?.dispose();
  ctx.state.descriptionTextController?.dispose();
  ctx.state.nameFoucsNode?.dispose();
  ctx.state.descriptionFoucsNode?.dispose();
}

Future<void> _submit(Action action, Context<BangtalCreateState> ctx) async {
  ctx.state.nameFoucsNode.unfocus();
  ctx.state.descriptionFoucsNode.unfocus();
  print(ctx.state.selectCafeName);
  print(ctx.state.selectThemaName);
  print(ctx.state.user);

  Firestore.instance.collection("bangTalBoard").add({
    'cafe_name': ctx.state.selectCafeName,
    'cafe_thema': ctx.state.selectThemaName,
    'cafe_thema_id': ctx.state.selectThemaName,
    'USER_NAME': ctx.state.user.firebaseUser.displayName,
    'USER_ID': ctx.state.user.firebaseUser.uid,
    'USER_photoUrl': ctx.state.user.firebaseUser.photoUrl,
    'CONTS': ctx.state.contsCon.text,
    'MDATE': ctx.state.mDate,
    'joinCount': '1',
    'joincountTotal': ctx.state.joincountTotal,
    'CDATE': Timestamp.now(),
  }).then((value) {
    print(value.documentID);
    var doc = Firestore.instance
        .collection("bangTalCafeThema")
        .where('cafe_name', isEqualTo: ctx.state.selectCafeName)
        .where('thema', isEqualTo: ctx.state.selectThemaName)
        .getDocuments();

    doc.then((docId) => {
          Firestore.instance
              .collection("bangTalBoard")
              .document(value.documentID)
              .updateData({'photoUrl': docId.documents[0]['posterPath']}),

          Firestore.instance
              .collection("bangTalBoardJoin")
              .document(ctx.state.user.firebaseUser.uid + value.documentID)
              .setData({
            'cafe_name': ctx.state.selectCafeName,
            'cafe_thema': ctx.state.selectThemaName,
            'USER_NAME': ctx.state.user.firebaseUser.displayName,
            'USER_ID': ctx.state.user.firebaseUser.uid,
            'boardId': value.documentID,
            'photoUrl': ctx.state.user.firebaseUser.photoUrl,
            'joinDesc': '방장입니다.',
            'confirmJoinYn': 'Y',
            'chatYN': 'N',
            'MDATE': Timestamp.now(),
            'CDATE': Timestamp.now(),
          }),

          ctx.broadcast(BangtalCreatePageActionCreator.showSnackBar('등록되었습니다')),
          Future.delayed(Duration(seconds: 2)).then((_) {
            //   ctx.dispatch(bantaltokWriteActionCreator.list());
            Navigator.of(ctx.context).pop('등록완료');
          }),

          // Future.delayed(Duration(seconds: 2)).then((_) {});
        });
  });
}

void _uploadBackground(Action action, Context<BangtalCreateState> ctx) async {
  final ImagePicker _imagePicker = ImagePicker();
  final _image = await _imagePicker.getImage(
      source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1080);
  if (_image != null) {
    ctx.dispatch(BangtalCreatePageActionCreator.setLoading(true));
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('avatar/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask =
        storageReference.putData(await _image.readAsBytes());
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      if (fileURL != null) {
        ctx.dispatch(BangtalCreatePageActionCreator.setBackground(fileURL));
      }
    });
    ctx.dispatch(BangtalCreatePageActionCreator.setLoading(false));
  }
}

void _showSnackBar(Action action, Context<BangtalCreateState> ctx) {
  ctx.state.scaffoldkey.currentState.showSnackBar(SnackBar(
    content: Text(action.payload ?? ''),
  ));
}
