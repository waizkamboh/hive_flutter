import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Database'),
        centerTitle: true,
      ),
      body: Column(
        children: [

        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: () async{
            var box = await Hive.openBox('waiz');
            box.put('name', 'waiz');
            box.put('age', '23');
            box.put('details', {
              'pro' : 'Developer',
              'name' : 'waiz'
            });
            print(box.get('name'));
            print(box.get('age'));
            print(box.get('details')['pro']);

      }),
    );
  }
}
