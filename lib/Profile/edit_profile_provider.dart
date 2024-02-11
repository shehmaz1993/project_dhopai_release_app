import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../Repository/log_debugger.dart';
import '../Repository/repository.dart';
class ProfileInfoProvider extends ChangeNotifier{
  Repository _repo=Repository();
  Map<String,dynamic>? map;
  File? _imageFile;
  XFile? _image;
  Uint8List? _imageData;
  CroppedFile? _croppedFile;
  String _fName='';
  String _lName='';
  String _email='';
  String _nid='';
  String _phone='';
  String _imgString ='';
  String _fullName ='';
  bool  _editPhone=false;
  bool  _editfname=false;
  bool  _editlname=false;
  bool  _editNid=false;
  bool  _editMail =false;
  File? get imageFile => _imageFile;
  XFile? get image => _image;
  CroppedFile? get croppedFile =>_croppedFile;
  String get fName => _fName;
  String get lName =>_lName;
  String get fullName =>_fullName;
  Uint8List? get imageData => _imageData;
  String get email => _email;
  String get nid => _nid;
  String get phone => _phone;
  String get imgString => _imgString;
  bool get editPhone =>_editPhone;
  bool get editfname =>_editfname;
  bool get editlname =>_editlname;
  bool get editNid =>_editNid;
  bool get editMail =>_editMail;
  setEditPhone(bool val){
    _editPhone=val;
    notifyListeners();
  }
  setEditFname(bool val){
    _editfname= val;
    notifyListeners();
  }
  setEditLname(bool val){
    _editlname=val;
    notifyListeners();
  }
  setEditNid(bool val){
    _editNid=val;
    notifyListeners();
  }
  setEditEmail(bool val){
    _editMail=val;
    notifyListeners();
  }
  setFullName(String fn,String ln){
    _fullName = '${fn} ${ln}';
    notifyListeners();
  }
  setImageFile(File file) {
    _imageFile = file;
    print(_imageFile);
    notifyListeners();
  }

  setImageXFile(XFile pass) {
    _image = pass;
    print(_image);
    notifyListeners();
  }
  setUnit8ListData(Uint8List unit){
    _imageData=unit;
    print(_image);
    notifyListeners();
  }
  setCroppedFile(CroppedFile file){
    _croppedFile=file;
    notifyListeners();
  }
  setfName(String fname) {
    _fName = fname;
    notifyListeners();
  }
  setlName(String lname) {
    _lName = lname;
    notifyListeners();
  }
  setEmail(String l) {
    _email = l;
    notifyListeners();
  }
  setNid(String nid){
    _nid=nid;
    notifyListeners();
  }
  setPhone(String n){
    _phone=n;
    notifyListeners();
  }
  setImgString(String n){
    _imgString=n;
    notifyListeners();
  }
  getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 100
    );
    if (pickedFile != null) {
      setImageXFile(pickedFile);
      notifyListeners();
      setImageFile(File(pickedFile.path));
      notifyListeners();
      convertingImageFiletoUnit8List();
      notifyListeners();
      cropImage(_imageFile!);
      notifyListeners();
    }
  }
  convertingImageFiletoUnit8List() async {
    Uint8List? img;
    img =await imageFile!.readAsBytes();
    print(img);
    setUnit8ListData(img);
    notifyListeners();
  }
  Future<void> cropImage(File? imgFile) async {
    if (imgFile != null) {
      final modifiedFile = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),

        ],
      );
      if (modifiedFile != null) {
        setCroppedFile(modifiedFile);
      }
    }
    else{
       CircularProgressIndicator();
    }
  }
  Future updateInfo() async {
    try{

      final response  = await _repo.userInfo();
      map = response;
      notifyListeners();
      LogDebugger.instance.i(map);
      print(map);


    }on Exception {
      rethrow;
    }
    print(map!['data']['f_name']);
    setfName(map!['data']['f_name']);
    notifyListeners();
    setlName(map!['data']['l_name']);
    notifyListeners();
    print(lName);
    setPhone(map!['data']['phone']);
    notifyListeners();
    print(lName);
    setImgString(map!['data']['image']);
    notifyListeners();
    print('image string is $imgString');
    setFullName(map!['data']['f_name'], map!['data']['l_name']);
    notifyListeners();
  }

}