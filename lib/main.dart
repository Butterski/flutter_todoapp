import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  List<String> todoList = [];

  void addToList(String task) {
    print('added $task');
    todoList.add(task);
    notifyListeners(); // Notify listeners when the data changes
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: TodoList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    void _submitForm() {
      if (_formKey.currentState!.validate()) {
        String value = _controller.text;
        if (value.isNotEmpty) {
          print('Submitted: $value');
          appState.addToList(value);
          _formKey.currentState?.reset();
        }
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: appState.todoList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  color: Colors.blueAccent,
                  margin: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text(
                    appState.todoList[index],
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                );
              },
            ),
          ),
          Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Task todo',
                      prefixIcon: Icon(Icons.text_fields),
                    ),
                    onFieldSubmitted: (String value) {
                      _submitForm();
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Add',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
