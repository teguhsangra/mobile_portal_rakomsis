import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_portal_rakomsis/model/location.dart';
import 'package:mobile_portal_rakomsis/model/product.dart';
import 'package:mobile_portal_rakomsis/network/api.dart';
import 'package:mobile_portal_rakomsis/util/util.dart';

class SearchProductScreen extends StatefulWidget {
  final dynamic locationId;
  final dynamic producId;

  SearchProductScreen({
    Key? key,
    required this.locationId,
    required this.producId,
  }) : super(key: key);

  @override
  SearchProductScreenState createState() => SearchProductScreenState(locationId,producId);

}

class SearchProductScreenState extends State<SearchProductScreen> {
  bool isLoading = true;
  var tenantId;
  var locationId;
  var productId;

  late List listLocation = <Location>[];
  List locations = <Location>[];

  late List listProduct = <Product>[];
  List products = <Product>[];

  late Product product;

  var selectedLocation;
  var selectedIndexLocation;

  var selectedProduct;
  var selectedIndexProduct;

  SearchProductScreenState(this.locationId, this.productId);

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
      getData();
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

  void getData() async{

    if(locationId != null && productId != null)
    {
      var res = await Network().getData('products/$productId');
      if (res.statusCode == 200) {
        var resultData = jsonDecode(res.body);
        print(resultData['data']);
        product = Product.fromJson(resultData['data']);

      }
    }

  }

  void addToCart() async{

  }


  Widget build(BuildContext context){

    return Scaffold(resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFEDECF2),
        appBar:AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('Product', style: TextStyle(
            color: Colors.black
          ),),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body:  isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            (product.has_product_prices == 1
                ?
              Expanded(
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      // banyak grid yang ditampilkan dalam satu baris
                        crossAxisCount: 2,
                        childAspectRatio: 0.63
                    ),
                    itemCount: product.productPrices.length,
                    itemBuilder: (context, index){
                      var item = product.productPrices[index];
                      return  Container(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                   padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE6ECF6),
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                  child: Text('Product',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold
                                      )
                                  ),

                                  )
                                ],
                              ),
                              InkWell(
                                onTap: (){

                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Icon(Icons.shopping_bag_outlined,
                                  size: 100,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 8),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    item.item.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),

                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.name.toString(),style: TextStyle(
                                   fontSize: 12,
                                ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  currencyFormat(int.parse(item.price.toString())),
                                  style: TextStyle(
                                      fontSize: 12
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFE6ECF6),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child:  Icon(
                                      Icons.add_shopping_cart,
                                      size: 12,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFE6ECF6),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.shopping_cart_checkout,
                                          size: 10,
                                          color: Colors.blue,
                                        ),
                                        Text(' check-out', style: TextStyle(
                                            fontSize: 10
                                        ),)
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                        ),
                      );
                    }
                ),
              )
              :
              Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Color(0xFFE6ECF6),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text('Product',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold
                            )
                        ),

                      )
                    ],
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Icon(Icons.shopping_bag_outlined,
                        size: 100,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      product.name.toString(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),

                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currencyFormat(int.parse(product.price.toString())),
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xFFE6ECF6),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child:  Icon(
                          Icons.add_shopping_cart,
                          size: 12,
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xFFE6ECF6),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.shopping_cart_checkout,
                              size: 10,
                              color: Colors.blue,
                            ),
                            Text(' check-out', style: TextStyle(
                                fontSize: 10
                            ),)
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )

            ),
            SizedBox(height: 20,)
          ],
        )
    );

  }
}