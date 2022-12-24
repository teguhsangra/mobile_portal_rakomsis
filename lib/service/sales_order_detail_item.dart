
import 'package:mobile_portal_rakomsis/model/sales_order_detail.dart';
import 'package:mobile_portal_rakomsis/service/sqlService.dart';
import 'package:mobile_portal_rakomsis/service/storageService.dart';

class SalesOrderDetailItem {
  SQLService sqlService = SQLService();
  StorageService storageService = StorageService();
  List<SalesOrderDetail> shoppingList = [];

  List<SalesOrderDetail> getShoppingItems() {
    int count = 1;
    data.forEach((element) {
      element['id'] = count;
      shoppingList.add(SalesOrderDetail.fromJson(element));
      count++;
    });
    return shoppingList;
  }

  List<SalesOrderDetail> get items => getShoppingItems();

  Future openDB() async {
    return await sqlService.openDB();
  }

  loadItems() async {
    bool isFirst = await isFirstTime();

    if (isFirst) {
      // Load From local DB
      List items = await getLocalDBRecord();
      return items;
    } else {
      // Save Record into DB & load record
      List items = await saveToLocalDB();
      return items;
    }
  }

  Future<bool> isFirstTime() async {
    return await storageService.getItem("isFirstTime") == 'true';
  }

  Future saveToLocalDB() async {
    List<SalesOrderDetail> items = this.items;
    for (var i = 0; i < items.length; i++) {
      await sqlService.saveRecord(items[i]);
    }
    storageService.setItem("isFirstTime", "true");
    return await getLocalDBRecord();
  }

  Future getLocalDBRecord() async {
    return await sqlService.getItemsRecord();
  }

  Future setItemAsFavourite(id, flag) async {
    return await sqlService.setItemAsFavourite(id, flag);
  }

  Future addToCart(SalesOrderDetail data) async {
    return await sqlService.addToCart(data);
  }

  Future getCartList() async {
    return await sqlService.getCartList();
  }

  removeFromCart(int shopId) async {
    return await sqlService.removeFromCart(shopId);
  }
}