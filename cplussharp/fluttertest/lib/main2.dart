import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter new Demo Home Pages'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  static Element findChild(Element e, Widget w) {
    late Element child;
    void visit(Element element) {
      if (w == element.widget)
        child = element;
      else
        element.visitChildren(visit);
    }

    visit(e);
    return child;
  }

  @override
  Widget build(BuildContext context) {
    Widget title = new Text(
      'another times: $_counter',
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            title,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _counter++;
          Element e = findChild(context as Element, title);
          if (e != null) {
            title = new Text(
              'another new times: $_counter  ${title.hashCode}',
            );

            e.owner?.lockState(() {
              e.update(title);
            });
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
