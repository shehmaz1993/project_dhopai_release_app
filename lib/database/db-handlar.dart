import 'package:dhopai/orderFile/cartModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dhopai/SignUp/user.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHelper{

  static Database? _db,_db1;
  Future<Database?> get db async{
    if(_db!=null){
      return _db;
    }
    _db=await initDatabase();
    return _db;
  }
  Future<Database?> get db1 async{
    if(_db1!=null){
      return _db1;
    }
    _db1=await initDatabaseForCart();
    return _db1;
  }
  initDatabase()async{
     io.Directory documentDirectory = await getApplicationDocumentsDirectory();
     String path= join(documentDirectory.path,'users.db');
     var db=openDatabase(path,version: 1,onCreate: _onCreate);
     return db;
  }
  initDatabaseForCart()async{
    //io.Directory documentDirectory1 = await getApplicationDocumentsDirectory();
    final dabasesPath = await getDatabasesPath();
    print(dabasesPath.toString());
    String path1= join(dabasesPath,'carts.db');
    var db1=openDatabase(path1,version: 1,onCreate: _onCreateCart);
    return db1;
  }
  _onCreate(Database db,int version)async{
      await db.execute("CREATE TABLE users (phone TEXT PRIMARY KEY,token TEXT,customer_id INTEGER)");
  }
  _onCreateCart(Database db1,int version) async {
    print('create table');
    await db1.execute("CREATE TABLE carts (id INTEGER PRIMARY KEY ,name TEXT,product_id INTEGER ,service_id INTEGER ,service_name TEXT,quantity INTEGER NOT NULL,price INTEGER,created_at TEXT,updated_at TEXT )");

  }
  Future<UserModel> insert(UserModel usermode)async{
    var dbClient= await db;
    await dbClient!.insert('users', usermode.toJson());
    return usermode;
  }
  Future<List<UserModel>> getUserList()async{
    var dbClient=await db;
    final List<Map<String,Object?>> quaryResult= await dbClient!.query('users');
    return quaryResult.map((e) => UserModel.fromJson(e)).toList();
  }
  Future<CartModel> insertIntoCart(CartModel cartmode)async{
    var dbClient= await db1;
    await dbClient!.insert('carts', cartmode.toJson());
    print('cart added');
    return cartmode;
  }
  Future<List<CartModel>> getCartList()async{
    var dbClient=await db1;
    final List<Map<String,Object?>> quaryResult= await dbClient!.query('carts');
    return quaryResult.map((e) => CartModel.fromJson(e)).toList();
  }
  Future<int> deleteCart(int id) async {
    print('deleted');
    var dbClient=await db1;
    return await dbClient!.delete(
      'carts',
      where: 'id = ?',
      whereArgs: [id]
    );

  }
  Future<int> updateCart(CartModel cart) async {
    print('updated');
    var dbClient=await db1;
    return await dbClient!.update(
        'carts',
        cart.toJson(),
        where: 'id = ?',
        whereArgs: [cart.id]
    );

  }

}