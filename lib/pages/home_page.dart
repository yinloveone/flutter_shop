import 'package:flutter/material.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
//https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian?name=大胸美女
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  String homePageContent = '还没有请求数据';

  @override
  void initState() {
    // TODO: implement initState
  /*  getHomePageContent().then((val){
      setState(() {
        homePageContent=val.toString();
      });
    });*/
    print("~~~~~~~~~~~~~~");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(appBar: AppBar(title:Text('百姓生活+')),
  body:FutureBuilder(future: getHomePageContent(),
  builder: (context,snapshot){
    if(snapshot.hasData){
      //数据处理
      var data = json.decode(snapshot.data.toString());
      List<Map> swiper = (data['data']['slides'] as List).cast();
      List<Map> navigatorList = (data['data']['category'] as List).cast();
      String adPicture=data['data']['advertesPicture']['PICTURE_ADDRESS'];
      String leaderImage=data['data']['shopInfo']['leaderImage'];
      String leaderPhone=data['data']['shopInfo']['leaderPhone'];
      List<Map> recommendList = (data['data']['recommend'] as List).cast();
      String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
      String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
      String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];
      List<Map> floor1 = (data['data']['floor1'] as List).cast();
      List<Map> floor2 = (data['data']['floor2'] as List).cast();
      List<Map> floor3 = (data['data']['floor3'] as List).cast();

      return ListView(
        children: <Widget>[
          SwiperDiy(swiperDateList: swiper,),
          TopNavigator(navigatorList:navigatorList),
          AdBanner(adPicture: adPicture),
          LeaderPhone(leaderImage: leaderImage,leaderPhone: leaderPhone),
          Recommend(recommendList:recommendList),
          FloorTitle(picture_address: floor1Title),
          FloorContent(floorGoodsList: floor1),
           FloorTitle(picture_address: floor2Title),
          FloorContent(floorGoodsList: floor2),
           FloorTitle(picture_address: floor3Title),
          FloorContent(floorGoodsList: floor3)
        ],
      
      );
    
    }else{
      return Center(
        child:Text('加载中......')
      );
    }

  },
  ));

  }
}

//首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDateList;
  SwiperDiy({Key key,this.swiperDateList}):super(key:key);

  @override
  Widget build(BuildContext context) { 
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          return Image.network("${swiperDateList[index]['image']}");
        },
        itemCount: swiperDateList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}
//分类类别
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key,this.navigatorList}):super(key:key);

  Widget _gridViewItemUI(BuildContext context,item){
    return InkWell(
      onTap:(){
        print('点击了导航');},
      child:Column(children: <Widget>[
        Image.network(item['image'],width:ScreenUtil().setWidth(95)),
        Text(item['mallCategoryName'])
      ],)
    );
  }
  @override
  Widget build(BuildContext context) {

    if(this.navigatorList.length>10){
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setWidth(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(crossAxisCount: 5,
      padding: EdgeInsets.all(5.0),
      children: navigatorList.map((item){
        return _gridViewItemUI(context, item);
      }).toList(),
      
      )
    );
  }
}
//广告区域
class AdBanner extends StatelessWidget {
  final String adPicture;
  AdBanner({Key key,this.adPicture}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
      
    );
  }
}
//店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;
  LeaderPhone({Key key,this.leaderImage,this.leaderPhone}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap:_launchURL,
        child:Image.network(leaderImage),

      ),
    );
  }
  void _launchURL() async{
    String url='tel:'+leaderPhone;
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'url 不能进行访问';
    }
  }
}

class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({Key key,this.recommendList}):super(key:key);

  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom:BorderSide(width: 0.5,color: Colors.black12)
        )
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color:Colors.pink),
      ),
    );
  }
  //商品项
  Widget _item(index){
    return InkWell(
      onTap:(){},
      child:Container(
       height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(280),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left:BorderSide(width: 1,color:Colors.black12)
          )
        ),
        child: Column(children: <Widget>[
          Image.network(recommendList[index]['image'],fit: BoxFit.fitHeight),
          Text('￥${recommendList[index]['mallPrice']}'),
          Text('￥${recommendList[index]['price']}',
          style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.black12),),
        ],)
      )
    );
  }

  //横向列表方法
  Widget _recommendList(){
    return Container(
    height: ScreenUtil().setHeight(380),
    margin: EdgeInsets.only(top:10.0),
    child: ListView.builder(
      scrollDirection:Axis.horizontal,
      itemBuilder: (context,index){
        return _item(index);
      },
    )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(500),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children:<Widget>[
         _titleWidget(),
         _recommendList()
        ]
      ),
      
    );
  }
}




//楼层标题
class FloorTitle extends StatelessWidget {
  final String picture_address;
  FloorTitle({Key key,this.picture_address}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

//楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  FloorContent({Key key,this.floorGoodsList}):super(key:key);
  Widget _goodsItem(Map goods){
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: (){

        },
        child: Image.network(goods['image']),

    ),);
  }

  Widget _firstRow(){
    return Row(children: <Widget>[
      _goodsItem(floorGoodsList[0]),
      Column(
        children:<Widget>[
          _goodsItem(floorGoodsList[1]),
          _goodsItem(floorGoodsList[2])
        ]
      )
    ],);
  }
  Widget _otherGoods(){
    return Row(children: <Widget>[
       _goodsItem(floorGoodsList[3]),
       _goodsItem(floorGoodsList[4])
    ],);

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children:<Widget>[
        _firstRow(),
        _otherGoods()
      ]),
    );
  }
}