import 'package:mobile_portal_rakomsis/model/sales_order_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart('
            'id INTEGER PRIMARY KEY, '
            'sales_order_id INTEGER , '
            'customer_complimentary_id INTEGER , '
            'asset_type_id INTEGER, '
            'asset_id INTEGER, '
            'room_id INTEGER, '
            'name VARCHAR , '
            'type VARCHAR,'
            'has_term INTEGER,'
            'has_quantity INTEGER,'
            'term VARCHAR,'
            'started_at DATETIME,'
            'ended_at DATETIME,'
            'length_of_term INTEGER,'
            'quantity INTEGER,'
            'total_use_of_complimentary INTEGER,'
            'cost INTEGER,'
            'price INTEGER,'
            'discount INTEGER,'
            'service_charge INTEGER,'
            'tax INTEGER)'
    );
  }

  Future<SalesOrderDetail> insert(SalesOrderDetail salesOrderDetail) async {
    var dbClient = await database;
    await dbClient!.insert('cart', salesOrderDetail.toMap());
    return salesOrderDetail;
  }

  Future<List<SalesOrderDetail>> getCartList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
    await dbClient!.query('cart');
    return queryResult.map((result) => SalesOrderDetail.fromMap(result)).toList();
  }

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateQuantity(SalesOrderDetail salesOrderDetail) async {
    var dbClient = await database;
    return await dbClient!.update('cart', salesOrderDetail.quantityMap(),
        where: "productId = ?", whereArgs: [salesOrderDetail.product_id]);
  }

  Future<List<SalesOrderDetail>> getCartId(int id) async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryIdResult =
    await dbClient!.query('cart', where: 'id = ?', whereArgs: [id]);
    return queryIdResult.map((e) => SalesOrderDetail.fromMap(e)).toList();
  }
}