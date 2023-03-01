import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:comic_reader/models/comic.dart';
import 'package:comic_reader/state/state_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, required this.app})
      : super(key: key);

  final FirebaseApp app;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseReference _bannerRef, _comicRef;
  List<Comic> listComicsFromFirebase = [];

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase _database = FirebaseDatabase(app: widget.app);
    _bannerRef = _database.reference().child('Banners');
    _comicRef = _database.reference().child('Comic');
  }

  @override
  Widget build(BuildContext context) {
    // Consumer is a widget that allows you reading providers.
    return Consumer(builder: (context, watch, _) {
      var searchEnable = watch(isSearch).state;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: searchEnable
              ? TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        hintText: 'Comic Name or category',
                        hintStyle: TextStyle(color: Colors.white60),
                      ),
                      autofocus: false,
                      style: DefaultTextStyle.of(context).style.copyWith(
                          fontStyle: FontStyle.italic,
                          fontSize: 18.0,
                          color: Colors.white)),
                  suggestionsCallback: (searchString) async {
                    return await searchComic(searchString);
                  },
                  itemBuilder: (context, Comic comic) {
                    return ListTile(
                      leading: Image.network(
                        comic.image!,
                        errorBuilder: (context, Object exception,
                                StackTrace? stackTrace) =>
                            Image.asset(
                          'assets/placeholder.png',
                        ),
                      ),
                      title: Text('${comic.name}'),
                      subtitle: Text(
                          '${comic.category == null ? "" : comic.category}'),
                    );
                  },
                  onSuggestionSelected: (Comic comic) {
                    context.read(comicSelected).state = comic;
                    Navigator.pushNamed(context, '/chapters');
                  })
              : Text(widget.title),
          actions: [
            IconButton(
                onPressed: () => context.read(isSearch).state =
                    !context.read(isSearch).state,
                icon: Icon(Icons.search))
          ],
        ),
        body: FutureBuilder<List<String>>(
          future: getBanners(_bannerRef),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CarouselSlider(
                    items: snapshot.data!
                        .map((e) => Builder(
                              builder: (context) {
                                return Image.network(
                                  e,
                                  fit: BoxFit.cover,
                                );
                              },
                            ))
                        .toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      initialPage: 0,
                      height: MediaQuery.of(context).size.height / 3,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.all(
                              8.0,
                            ),
                            child: Text(
                              'NEW COMIC',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.black,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(''),
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: getComic(_comicRef),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      } else if (snapshot.hasData) {
                        //TODO - change for null safety
                        listComicsFromFirebase = [];
                        List snapshotData = snapshot.data!;

                        //Assign all comic results to the field listComicsFromFirebase
                        snapshotData.forEach((item) {
                          //TODO :more about json encode
                          // Comic comic = Comic.fromJson(item);
                          Comic comic =
                              Comic.fromJson(json.decode(json.encode(item)));
                          listComicsFromFirebase.add(comic);
                        });

                        return Expanded(
                            child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          padding: EdgeInsets.all(4.0),
                          mainAxisSpacing: 1.0,
                          crossAxisSpacing: 1.0,
                          children: listComicsFromFirebase.map((comic) {
                            return GestureDetector(
                              onTap: () {
                                context.read(comicSelected).state = comic;
                                Navigator.pushNamed(context, '/chapters');
                              },
                              child: Card(
                                elevation: 12.0,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      comic.image ?? "",
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, Object exception,
                                              StackTrace? stackTrace) =>
                                          Image.asset(
                                        'assets/placeholder.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          color: Colors.black.withOpacity(0.4),
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  (comic.name ?? "")
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ));
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      );
    });
  }

  Future<List<String>> getBanners(DatabaseReference bannerRef) {
    return bannerRef
        .once()
        .then((snapshot) => snapshot.value.cast<String>().toList());
  }

  Future<List<dynamic>> getComic(DatabaseReference comicRef) {
    return comicRef.once().then((snapshot) => snapshot.value);
  }

  Future<List<Comic>> searchComic(String searchString) async {
    return listComicsFromFirebase
        .where((comic) =>
            comic.name!
                .toLowerCase()
                .contains(searchString.toLowerCase()) //Name first
            //if name not contains
            ||
            (comic.category != null &&
                comic.category!.toLowerCase().contains(
                    searchString.toLowerCase()))) //Then we search by category
        .toList();
  }
}
