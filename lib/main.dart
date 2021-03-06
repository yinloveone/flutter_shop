import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/catrgory_goods_list.dart';
void main(){
  var counter =Counter();
  var childCategory=ChildCategory();
  var providers = Providers();
  var categoryGoodsListProvide =  CategoryGoodsListProvide();
  providers
  ..provide(Provider<ChildCategory>.value(childCategory))
  ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
  ..provide(Provider<Counter>.value(counter));
 runApp(ProviderNode(child: MyApp(),providers: providers,));
} 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title:'百姓生活+',
        debugShowCheckedModeBanner:false,
        theme:ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
      )
    );
  }
}
