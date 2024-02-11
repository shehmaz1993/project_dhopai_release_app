import 'package:dhopai/SignUp/user.dart';
import 'package:dhopai/database/db-handlar.dart';
import 'package:flutter/material.dart';
class ShowUser extends StatefulWidget {
  const ShowUser({Key? key}) : super(key: key);

  @override
  State<ShowUser> createState() => _ShowUserState();
}

class _ShowUserState extends State<ShowUser> {

  DBHelper? dbhelper;
  late Future<List<UserModel>> userlist;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbhelper=DBHelper();
    loadData();
  }
  loadData()async{
     userlist= dbhelper!.getUserList();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:FutureBuilder(
          future: userlist,
          builder: (context,AsyncSnapshot<List<UserModel>> snapshot){

            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder:(context,index){
                  return SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ListTile(
                      title: Text(snapshot.data![index].phone.toString()),
                      subtitle:Text(snapshot.data![index].token.toString()) ,
                      leading:Text(snapshot.data![index].customerId.toString()) ,
                    ),
                  );
                }
            );
          }
      )
    );
  }
}
