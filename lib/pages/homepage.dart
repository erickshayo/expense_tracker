import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

TextEditingController nameController = TextEditingController();
TextEditingController amountController = TextEditingController();

class _HomePageState extends State<HomePage> {
  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("New expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: "Name"),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: "Amount"),
            )
          ],
        ),
        actions: [_cancelButton(),],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openNewExpenseBox,
        child: Icon(Icons.add),
      ),
    );
  }
  Widget _cancelButton() {
  return MaterialButton(
    onPressed: () {
      Navigator.pop(context);
      nameController.clear();
      amountController.clear();
    },
    child: Text("Cancel"),
  );
}

}

