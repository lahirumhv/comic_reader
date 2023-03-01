import 'package:comic_reader/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChapterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Consumer is a widget that allows you reading providers.
    return Consumer(builder: (context, watch, _) {
      var comic = watch(comicSelected).state;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              '${(comic.name ?? "").toUpperCase()}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: comic.chapters != null && comic.chapters!.length > 0
            ? Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: comic.chapters!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // The read method is an utility to read a provider without listening to it.
                        context.read(chapterSelected).state =
                            comic.chapters![index];
                        Navigator.pushNamed(context, '/read');
                      },
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('${comic.chapters![index].name}'),
                          ),
                          Divider(
                            thickness: 1.0,
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Text('We are Translating this comic.'),
              ),
      );
    });
  }
}
