import 'package:flutter/material.dart';

class ProductCountProvider extends ChangeNotifier{
 /* List _clothes=[];
  //List<TextEditingController>? numberOfClothes = [];
 // String _productCount='0';
  //String get productCount => _productCount;
  List get clothes=>_clothes;
  setProductCount(String number,int index) {
    //_productCount = number;
    //notifyListeners();
    //numberOfClothes![index].text=number;
    _clothes[index]= number;
    notifyListeners();

  }*/
  List<TextEditingController> _numberOfClothes = [TextEditingController()];
  List get numberOfClothes =>_numberOfClothes;
  void createControllers(int numberOfControllers) {
    for (int i = 0; i < numberOfControllers; i++) {

      TextEditingController controller = TextEditingController(text: '1');
      notifyListeners();
      _numberOfClothes.add(controller);
      notifyListeners();
      if(_numberOfClothes[0].text=='')
        _numberOfClothes[0].text='1';
         notifyListeners();

    }
  }
}