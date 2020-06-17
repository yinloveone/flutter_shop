import 'package:flutter/material.dart';
import '../service/service_method.dart';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../model/categoryGoodsList.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    //_getCategory();
    return Scaffold(appBar: AppBar(title:Text('商品分类')),
      body: Container(child: Row(
        children:<Widget>[
         
          LeftCategoryNav(),
         Column(children:<Widget>[
           RightCategoryNav(),
           CategoryGoods()
         ])
        ]
      ),),
    );
  }

}
//左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  
  List list = [];
  var listIndex = 0;
  @override
  void initState() {
    _getCategory();
    super.initState();
  }
   void _getCategory() async{
    await request('getCategory').then((val){
      var data = json.decode(val.toString());
      //print(data);
      CategoryModel categoryList = CategoryModel.fromJson(data);
      setState(() {
        list=categoryList.data;
      });
    });
    Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto);
  }
  Widget _leftInkWell(int index){
    bool isClick = false;
    isClick = (index==listIndex)?true:false;

    return InkWell(
      onTap: (){
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        Provide.value<ChildCategory>(context).getChildCategory(childList);
        
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left:10,top:30),
        decoration: BoxDecoration(
          color: isClick?Colors.black12:Colors.white,
          border: Border(bottom:BorderSide(width: 1,color:Colors.black12))
          ),
        child: Text(list[index].mallCategoryName),),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(border: Border(right:BorderSide(width: 1,color:Colors.black12))),
      child: ListView.builder(itemCount: list.length,
      itemBuilder: (context,index){
        return _leftInkWell(index);
      },
      
      ),
      
    );
  }
}
class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder:(context,child,childCategory){
     return  Container(
      height: ScreenUtil().setHeight(80),
      width: ScreenUtil().setWidth(570),
      decoration: BoxDecoration(
        color:Colors.white,
        border:Border(
          bottom:BorderSide(color: Colors.black12,width:1)
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: childCategory.childCategoryList.length,
        itemBuilder: (context,index){
          return _rightInkWell(childCategory.childCategoryList[index]);
        }),
      
    );
    }) ;
  }

  Widget _rightInkWell(BxMallSubDto item){
    return InkWell(
      onTap:(){},
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
        item.mallSubName,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),),
    );
  }
}
//商品列表
class CategoryGoods extends StatefulWidget {
  CategoryGoods({Key key}) : super(key: key);

  @override
  _CategoryGoodsState createState() => _CategoryGoodsState();
}

class _CategoryGoodsState extends State<CategoryGoods> {
  List list = [];

  @override
  void initState(){
    _getGoodsList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       width: ScreenUtil().setWidth(570),
       height: ScreenUtil().setHeight(1000),
       child: ListView.builder(
         itemCount: list.length,
         itemBuilder: (context,index){
           return _listWidget(index);
         }),
    );
  }
  void _getGoodsList() async{
    var data = {
      'categoryId':'4',
      'categorySubId':'',
      'page':1
    };
    await request('getMallGoods',formData:data).then((val){
      var data = json.decode(val.toString());
      CategoryGoodsListModel  goodList = CategoryGoodsListModel.fromJson(data);//json数据转换成model类
     // print(goodList.data[0].goodsName);
     setState(() {
       list = goodList.data;
     });
    });
  }

  Widget _goodsImage(index){
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(list[index].image),
    );
  }
  Widget _goodsName(index){
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
      list[index].goodsName,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: ScreenUtil().setSp(28)),
    ),);
  }
  Widget _goodsPrice(index){
    return Container(
      margin: EdgeInsets.only(top:20),
      width: ScreenUtil().setWidth(370),
      child:Row(children: <Widget>[
        Text('价格：￥${list[index].presentPrice}',
        style: TextStyle(color:Colors.pink,fontSize: ScreenUtil().setSp(30)),
        ),
        Text('价格：￥${list[index].oriPrice}',
        style: TextStyle(color:Colors.black26,fontSize: ScreenUtil().setSp(30),decoration: TextDecoration.lineThrough),
        )
      ],)
    );
  }

  Widget _listWidget(int index){
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.only(top:5.0,bottom:5.0),
        decoration: BoxDecoration(
          color:Colors.white,
          border:Border(bottom:BorderSide(width:1.0,color:Colors.black12))
        ),
        child: Row(

        children:<Widget>[
          Expanded(child: _goodsImage(index),),
          
          Column(children: <Widget>[
            _goodsName(index),
            _goodsPrice(index)
          ],)
        ]
      ),),

    );

  }

}
