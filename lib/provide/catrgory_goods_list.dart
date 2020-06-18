import 'package:flutter/material.dart';
import 'package:flutter_shop/model/categoryGoodsList.dart';
class CategoryGoodsListProvide with ChangeNotifier{
  List<CategoryListData> goodsList = [];
  //点击大类时更换商品列表
  getGoodsList(List<CategoryListData> list){
    goodsList = list;
    notifyListeners();
  }
  
}