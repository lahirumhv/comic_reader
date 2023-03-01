import 'chapters.dart';

class Comic {
  String? category, name, image;
  List<Chapters>? chapters;

  Comic({this.category, this.name, this.image, this.chapters});

  Comic.fromJson(Map<String, dynamic> json) {
    category = json['Category'];
    name = json['Name'];
    image = json['Image'];
    chapters = [];
    if (json['Chapters'] != null) {
      json['Chapters'].forEach((v) => chapters!.add(Chapters.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Category'] = this.category;
    data['Name'] = this.name;
    data['Image'] = this.image;

    if (this.chapters != null) {
      data['Chapters'] = this.chapters!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
