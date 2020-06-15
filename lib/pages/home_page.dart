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

class _HomePageState extends State<HomePage> {
  String homePageContent = '还没有请求数据';

  @override
  void initState() {
    // TODO: implement initState
    getHomePageContent().then((val){
      setState(() {
        homePageContent=val.toString();
      });
    });
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
      return 
      SingleChildScrollView(
        child:  Column(
        children: <Widget>[
          SwiperDiy(swiperDateList: swiper,),
          TopNavigator(navigatorList:navigatorList),
          AdBanner(adPicture: adPicture),
          LeaderPhone(leaderImage: leaderImage,leaderPhone: leaderPhone)
        ],
      )
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
//
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
        's',
        style: TextStyle(color:Colors.pink),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}