import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GridView Lazy Load',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'GridView Lazy Load'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const _gridSpacing = 10.0;

class _MyHomePageState extends State<MyHomePage> {
  ScrollController controller;
  List<String> items;
  bool loading = false;
  bool hasMore = true;

  Widget _buildProgressIndicatorFooter() {
    if (!hasMore) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: _gridSpacing,
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            child: Container(
              child: Theme(
                data: Theme.of(context).copyWith(accentColor: Colors.white),
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              ),
              width: 35.0,
              height: 35.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    items = List.generate(30, (index) => '$index');
    controller = ScrollController()..addListener(_scrollListener);
  }

  Widget _buildGridTile(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: _gridSpacing),
      child: Material(
        elevation: 2.0,
        child: Ink(
          color: Colors.white,
          child: InkWell(
            onTap: () { },
            child: Center(
              child: Text(
                items[index],
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.red,
        child: Scrollbar(
          //remove this if you don't want to show a scrollbar
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _gridSpacing),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    childAspectRatio: 1.0,
                    maxCrossAxisExtent: 150.0,
                    crossAxisSpacing: _gridSpacing,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildGridTile(index);
                    },
                    childCount: items.length,
                  ),
                ),
                _buildProgressIndicatorFooter(), // Your footer widget goes here
              ],
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchNext() async {
    loading = true;

    final _count = items.length;
    var list = List.generate(30, (index) => '${_count + index}');

    //Imitating network call...
    await Future.delayed(Duration(seconds: 3));

    items.addAll(list);
    hasMore = items.length > 300 ? false : true;

    loading = false;

    setState(() {});
  }

  void _scrollListener() {
    if (!loading && hasMore && controller.position.extentAfter < 500) {
      _fetchNext();
    }
  }
}
