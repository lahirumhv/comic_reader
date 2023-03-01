import 'package:carousel_slider/carousel_slider.dart';
import 'package:comic_reader/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReadScreen extends StatelessWidget {
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
        body: Center(
          child: (
                  // The read method is an utility to read a provider without listening to it
                  context.read(chapterSelected).state.links == null ||
                      context.read(chapterSelected).state.links!.length == 0)
              ? Text('This chapter is translating...')
              : CarouselSlider(
                  items: context
                      .read(chapterSelected)
                      .state
                      .links!
                      .map((link) => Builder(
                            builder: (context) {
                              return Image.network(
                                link,
                                fit: BoxFit.cover,
                              );
                            },
                          ))
                      .toList(),
                  options: CarouselOptions(
                    autoPlay: false,
                    height: MediaQuery.of(context).size.height,
                    enlargeCenterPage: false,
                    viewportFraction: 1.0,
                    initialPage: 0,
                  )),
        ),
      );
    });
  }
}
