import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

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
          appState.addToList(value);
          _formKey.currentState?.reset();
          _controller.clear();
        }
      }
    }

    void _removeTask(int id) {
      appState.removeFromList(id);
    }

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 26.0),
            Expanded(
              child: ListView.builder(
                itemCount: appState.todoList.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = appState.todoList[index];
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
                            '${index + 1} - ${item['task']}',
                            style: const TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _removeTask(item['id']),
                          child: const Icon(Icons.delete, color: Colors.red),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a task';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.add),
                      label: const Text('Add', style: TextStyle(fontSize: 20)),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 25,
          right: 10,
          child: ElevatedButton(
            onPressed: () {
              appState.logOut();
            },
            child: const Icon(Icons.logout),
          ),
        ),
      ],
    );
  }
}
