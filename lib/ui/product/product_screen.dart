import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_portal_rakomsis/model/location.dart';
import 'package:mobile_portal_rakomsis/model/product.dart';
import 'package:mobile_portal_rakomsis/network/api.dart';

class ProductScreen extends StatefulWidget {

  ProductScreen({
    Key? key,
  }) : super(key: key);

  @override
  ProductScreenState createState() => ProductScreenState();

}

class ProductScreenState extends State<ProductScreen> {
  bool isLoading = true;
  var tenantId;

  late List listLocation = <Location>[];
  List locations = <Location>[];

  late List listProduct = <Product>[];
  List products = <Product>[];

  var selectedLocation;
  var selectedIndexLocation;

  var selectedProduct;
  var selectedIndexProduct;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getTenant();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }


  void getTenant() async {
    var res = await Network().getData('get_tenant?code=RAKITEK');
    var body = json.decode(res.body);
    var data_body = body['data'];

    if (data_body != null) {
      setState(() {
        tenantId = data_body['id'];
      });

      getLocation();
      getProduct();
    }
  }


  void getLocation() async{
    var res = await Network().getData('locations-get-without-auth?tenant_id=$tenantId');

    if (res.statusCode == 200) {
      var resultData = jsonDecode(res.body);

      setState(() {
        listLocation.clear();
        resultData['data'].forEach((v) {
          listLocation.add(Location.fromJson(v));
        });
        locations = listLocation;
      });
    }
  }

  void getProduct() async{
    var res = await Network().getData('products?tenant_id=$tenantId');

    if (res.statusCode == 200) {
      var resultData = jsonDecode(res.body);

      setState(() {
        listProduct.clear();
        resultData['data'].forEach((v) {
          listProduct.add(Product.fromJson(v));
        });
        products = listProduct;
      });
    }
  }


  Widget build(BuildContext context){

    return Scaffold(resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey,
        appBar:AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [

            ],
          ),
        )
    );

  }
}