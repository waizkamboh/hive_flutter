import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'boxes/boxes.dart';
import 'models/notes_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Database'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context,box, _){
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(data[index].title.toString()),
                              Spacer(),
                              InkWell(
                                onTap: (){
                                  delete(data[index]);
                                },
                                  child: Icon(Icons.delete)),
                              SizedBox(width: 5,),
                              InkWell(
                                onTap: (){
                                  editMyDialog(data[index], data[index].title.toString(), data[index].description.toString());
                                },
                                  child: Icon(Icons.edit)),
                            ],
                          ),
                          Text(data[index].description.toString()),
                        ],
                      ),
                    ),
                  );
                }
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async{
            showMyDialog();
          }),
    );
  }

  void delete(NotesModel notesModel) {
    notesModel.delete();
  }

  Future<void>  editMyDialog(NotesModel notesModel, String title, String description) async{
    titleController.text = title;
    desController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: desController,
                    decoration: InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')
              ),
              TextButton(
                  onPressed: (){
                    notesModel.title = titleController.text.toString();
                    notesModel.description = desController.text.toString();
                    notesModel.save();
                    titleController.clear();
                    desController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Edit')
              ),
            ],
          );
        }
    );
  }

  Future<void>  showMyDialog() async{
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Add Notes'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Enter Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: desController,
                      decoration: InputDecoration(
                        hintText: 'Enter Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')
                ),
                TextButton(
                    onPressed: (){
                      final data = NotesModel(title: titleController.text,
                          description: desController.text);
                      final box = Boxes.getData();
                      box.add(data);
                     // data.save();
                      titleController.clear();
                      desController.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Add')
                ),
              ],
            );
          }
      );
  }
}
