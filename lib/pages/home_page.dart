import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_shop/service/service_method.dart';
//https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian?name=大胸美女
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String showText = '还没有请求数据';

  @override
  void initState() {
    // TODO: implement initState
    getHomePageContent().then((val){
      setState(() {
        showText=val.toString();
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(appBar: AppBar(title:Text('数据请求')),
  body: SingleChildScrollView(
    child:Text(showText)
  ),
  );
  }
}