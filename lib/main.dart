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
  var todoList = {'admin': ['Zrobić zakupy', 'Wyjść na dwór', 'Podotykać trawe']};
  var userName = '';
  var logged = false;

  void addToList(String task) {
    print('Added $task');
    todoList[userName]?.add(task);
    notifyListeners(); // Notify listeners when the data changes
  }

  void removeFromList(int index) {
    if (index >= 0 && index < todoList.length) {
      print('Removed ${todoList[index]}');
      todoList[userName]?.removeAt(index);
      notifyListeners();
    }
  }
  
  void logIn(String login){
    if(login.isNotEmpty) {
      print('Logged as $login');
      logged = true;
      userName = login;
      if (todoList[userName] == null) {
        todoList[userName] = [];
      }
      notifyListeners();
    }
  }
  void logOut(){
    print('Logging out');
    logged = false;
    userName = '';
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: appState.logged ? TodoList() : LoginView(),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 320.0),
        margin: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Column(
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Login to manage your todos',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    String username = _usernameController.text;
                    appState.logIn(username);
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
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

    void _removeTask(int index) {
      appState.removeFromList(index);
    }

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 26.0),
              Expanded(
                child: ListView.builder(
                  itemCount: appState.todoList[appState.userName]?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blueAccent,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1} - ${appState.todoList[appState.userName]?[index]}',
                              style: const TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _removeTask(
                                index), // Use a lambda function here
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
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
                          labelText: 'Todo task',
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
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                appState.logOut();
              },
              child: const Icon(Icons.logout),
            ),
            const SizedBox(width: 10.0,),
            Text('Logged as ${appState.userName}')
          ],
        ),
      ],
    );
  }
}
