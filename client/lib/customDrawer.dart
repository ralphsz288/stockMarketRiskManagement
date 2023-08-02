import 'package:flutter/material.dart';
import 'package:stock_intrinsic_value_calculator/changeUsername.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {

    return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height:200,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.lightBlue
                  ),
                  child:Column(
                    children: [
                      const Icon(Icons.person,size: 80,color: Colors.white,),
                      Text(Provider.of<ChangeUsername>(context).username,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white))
                    ],
                  )
                  ),
                ),
              ListTile(
                  leading:const Icon(Icons.home),
                  title: const Text('Home',style: TextStyle(fontSize: 20)),
                  onTap:(){
                    Navigator.pop(context);
                  }
              ),
              ListTile(
                  leading:const Icon(Icons.monetization_on_outlined),
                  title: const Text('Risk management',style: TextStyle(fontSize: 20)),
                  onTap:(){
                    Navigator.pushNamed(context, '/riskManagement');
                  }
              ),

              ListTile(
                  leading:const Icon(Icons.file_copy_outlined),
                  title: const Text('About',style: TextStyle(fontSize: 20)),
                  onTap:(){
                    Navigator.pushNamed(context, '/about');
                  }
              ),
              const Divider(color: Colors.black,),
              ListTile(
                  leading:const Icon(Icons.logout),
                  title: const Text('Logout',style: TextStyle(fontSize: 20)),
                  onTap:(){
                    Navigator.pushReplacementNamed(context, '/');
                  }
              ),
            ],

          ),
        );
    }
  }


