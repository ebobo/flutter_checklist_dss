import 'package:flutter/material.dart';
import 'package:checklist_flutter/model/item.dart';
import 'package:checklist_flutter/service/rest.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CheckList DSS',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'CheckList DSS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _restService = RestService();
  List<Item> _itemList = [];
  void _incrementCounter() {
    setState(() {});
  }

  @override
  void initState() {
    initList();
    super.initState();
  }

  initList() async {
    final items = await _restService.getListItems();

    items.sort((a, b) => a.position.compareTo(b.position));
    setState(() {
      _itemList = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.2);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.65);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 4),
            const Text('List:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
                height: 750,
                child: ReorderableListView(
                  buildDefaultDragHandles: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: <Widget>[
                    for (int index = 0; index < _itemList.length; index += 1)
                      ListTile(
                        key: Key('$index'),
                        tileColor: index.isOdd ? oddItemColor : evenItemColor,
                        title: Text(_itemList[index].name),
                        subtitle: Text(_itemList[index].position.toString()),
                        trailing: Checkbox(
                          value: _itemList[index].status,
                          activeColor: Colors.deepOrange,
                          onChanged: (bool? value) {
                            setState(() {
                              _itemList[index].status = value!;
                            });
                          },
                        ),
                      ),
                  ],
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      // final int item = _itemList.removeAt(oldIndex);
                      // _itemList.insert(newIndex, item);
                    });
                  },
                ))
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _incrementCounter(),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () => _incrementCounter(),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
