import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mobile_portal_rakomsis/model/location.dart';
import 'package:mobile_portal_rakomsis/model/product.dart';
import 'package:mobile_portal_rakomsis/network/api.dart';
import 'package:mobile_portal_rakomsis/ui/product/search_product_screen.dart';
import 'package:mobile_portal_rakomsis/ui/product/product_screen.dart';
import 'package:mobile_portal_rakomsis/util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {


  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLogin = true;
  bool isLoading = true;

  bool isListSelectedLocation = false;
  bool isSubmitSelectedLocation = true;

  bool isListSelectedProduct = false;
  bool isSubmitSelectedProduct = true;

  int index = 0;

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
    getTenant();
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


  void sheetLocation() async{
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            width: size.width,
            height: size.height * 0.8,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50.0,
                      height: 5.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey))),
                      onChanged: (value) {
                        // print(value);
                        if (value.isEmpty) {
                          final suggestions = listLocation;
                        } else {
                          final suggestions = listLocation.where((customer) {
                            final customerName = customer.name.toLowerCase();
                            final input = value.toLowerCase();

                            return customerName.contains(input);
                          }).toList();
                          setState(() {
                            locations = suggestions;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Location',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)
                      ),
                      if (isListSelectedLocation == true)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndexLocation = null;
                              selectedLocation = null;
                              isListSelectedLocation = false;
                              isSubmitSelectedLocation = true;
                            });
                            refreshSelected();
                          },
                          child: Text('Reset',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green)),
                        )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (context, index){
                        var item = locations[index];
                        return CheckboxListTile(
                          title: Text(locations[index].name),
                          value: selectedIndexLocation == item.id ? true : false,
                          onChanged: (value){
                            setState(() {
                              if (value == true) {
                                selectedIndexLocation = item.id;
                                selectedLocation = item.name;

                                isListSelectedLocation = true;
                                isSubmitSelectedLocation = true;
                              } else {
                                selectedIndexLocation = null;
                                selectedLocation = null;

                                isListSelectedLocation = false;
                                isSubmitSelectedLocation = false;
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  if(isSubmitSelectedLocation != false)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 50,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Color(0xFF000075),
                          borderRadius: BorderRadius.circular(12)),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            isSubmitSelectedLocation = false;
                            locations = listLocation;
                          });
                          refreshSelected();
                        },
                        child: const Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                ],
              ) ,
            ),
          );
        });
      });
  }

  void sheetProduct() async{
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              width: size.width,
              height: size.height * 0.8,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50.0,
                        height: 5.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.grey))),
                        onChanged: (value) {
                          // print(value);
                          if (value.isEmpty) {
                            final suggestions = listLocation;
                          } else {
                            final suggestions = listLocation.where((customer) {
                              final customerName = customer.name.toLowerCase();
                              final input = value.toLowerCase();

                              return customerName.contains(input);
                            }).toList();
                            setState(() {
                              locations = suggestions;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Product',
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)
                        ),
                        if (isListSelectedProduct == true)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndexProduct = null;
                                selectedProduct = null;
                                isListSelectedProduct = false;
                                isSubmitSelectedProduct = true;
                              });
                              refreshSelected();
                            },
                            child: Text('Reset',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green)),
                          )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index){
                          var item = products[index];
                          return CheckboxListTile(
                            title: Text(products[index].name),
                            value: selectedIndexProduct == item.id ? true : false,
                            onChanged: (value){
                              setState(() {
                                if (value == true) {
                                  selectedIndexProduct = item.id;
                                  selectedProduct = item.name;

                                  isListSelectedProduct = true;
                                  isSubmitSelectedProduct = true;
                                } else {
                                  selectedIndexProduct = null;
                                  selectedProduct = null;

                                  isListSelectedProduct = false;
                                  isSubmitSelectedProduct = false;
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    if(isSubmitSelectedProduct != false)
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 50,
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Color(0xFF000075),
                            borderRadius: BorderRadius.circular(12)),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              isSubmitSelectedProduct = false;
                              products = listProduct;
                            });
                            refreshSelected();
                          },
                          child: const Text(
                            'Simpan',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      )
                  ],
                ) ,
              ),
            );
          });
        });
  }

  void refreshSelected() async{
    setState(() {

    });
  }

  void searchProduct() async {
    if(selectedIndexLocation == null && selectedIndexProduct == null ){
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              backgroundColor: Colors.black.withOpacity(0.5),
              elevation: 0,
              content: Text('Lokasi dan Produk tidak boleh kosong', style: TextStyle(
                color: Colors.white
              ),),
            );
          }
      );
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) {
            return SearchProductScreen(
              locationId: selectedIndexLocation,
              producId: selectedIndexProduct,
            );
          }),
        ),
      );

    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xFFEDECF2),
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            actions: [

              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8,right: 10),
                    padding: EdgeInsets.all(5),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        shape: BoxShape.circle
                    ),
                    child: Icon(Icons.notifications_rounded, color: Colors.black,),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF4848),
                        shape: BoxShape.circle,
                        border: Border.all(width: 1.5,color: Colors.white)
                      ),
                      child: Text(
                        '0', style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(width: 10,),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8,right: 20),
                    padding: EdgeInsets.all(5),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        shape: BoxShape.circle
                    ),
                    child: Icon(Icons.shopping_bag_outlined, color: Colors.black,),
                  ),
                  Positioned(
                    top: 5,
                    right: 15,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Color(0xFFFF4848),
                          shape: BoxShape.circle,
                          border: Border.all(width: 1.5,color: Colors.white)
                      ),
                      child: Text(
                        '0', style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                    ),
                  )
                ],
              )
            ],
            elevation: 0,
          ),
          body: IndexedStack(
              index: index,
              children: [
                HomeIndex(context),
                ProductScreen()
              ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: GNav(
                color: Colors.blue,
                activeColor: const Color(0xFF000075),
                gap: 8,
                tabBackgroundColor: Colors.blue.withOpacity(0.2),
                padding: const EdgeInsets.all(15),
                iconSize: 20,
                selectedIndex: index,
                onTabChange: (int selectedIndex) {
                  setState(() {
                    index = selectedIndex;
                  });
                },
                tabs:  [
                  GButton(icon: Icons.home, text: 'Home'),
                  GButton(icon: Icons.storefront, text: 'Product'),
                  GButton(icon: Icons.group, text: 'Membership'),
                  GButton(icon: Icons.account_circle, text: 'Profile')
                ]),
          ),
    );
  }



  Widget HomeIndex(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
          onRefresh: () async {
          },
        child: SingleChildScrollView(
            child: Column(
              children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF4A3298),
                      borderRadius: BorderRadius.circular(14)
                    ),
                    child:
                    Column(
                      children: [
                        Align(
                          child: Text(
                            "Book your product",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight:
                                FontWeight.bold
                            )
                          ),
                          alignment: Alignment.topLeft,
                        ),
                       SizedBox(height: 50,),
                       Text(
                         'You are now able to book Meeting room & Coworking.',
                           style: TextStyle(
                               color: Colors.white,
                               fontSize: 14,
                               fontWeight: FontWeight.normal
                           )
                       )
                      ],
                    )


                    ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2 ),
                              blurRadius: 2,
                              // Shadow position
                              spreadRadius: 2,
                              offset: const Offset(0, 2)),
                        ]
                    ),
                    child:
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            sheetLocation();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: size.height / 4,
                                  padding: new EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    selectedLocation != null
                                        ? selectedLocation
                                        : 'Pilih Location',
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down_circle,
                                    color: Colors.black)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: () {
                            sheetProduct();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: size.height / 4,
                                  padding: new EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    selectedProduct != null
                                        ? selectedProduct
                                        : 'Pilih Product',
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down_circle,
                                    color: Colors.black)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          height: 50,
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                              color: Color(0xFF000075),
                              borderRadius: BorderRadius.circular(12)),
                          child: TextButton(
                            onPressed: () {
                              searchProduct();
                            },
                            child: const Text(
                              'Ayo Cari',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    )
                ),
              ],
            ),
        )
    );
  }
}