class User {
  String userId;
  List<Context> contexts;

  User({required this.userId, required this.contexts});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      contexts: (json['contexts'] as List<dynamic>? ?? [])
          .map((context) => Context.fromJson(context))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'userId': userId,
      'contexts': contexts.map((context) => context.toJson()).toList(),
    };
    return data;
  }
}

class Context {
  String contextId;
  String contextName;
  List<News> news;

  Context({required this.contextId, required this.contextName, required this.news});

  factory Context.fromJson(Map<String, dynamic> json) {
    return Context(
      contextId: json['contextId'],
      contextName: json['contextName'],
      news: (json['news'] as List<dynamic>? ?? [])
          .map((a) => News.fromJson(a))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'contextId': contextId,
      'contextName': contextName,
      'news': news.map((a) => a.toJson()).toList(),
    };
    return data;
  }
}

class News {
  String key;
  String name;
  String description;
  String image;
  String url;

  News({required this.key, required this.name,required this.url,required this.image,required this.description});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      key: json['key'],
      name: json['name'],
      description: json["description"],
      image: json["image"],
      url: json["url"]
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'key': key,
      'name': name,
      'description':description,
      'image':image,
      'url':url
    };
    return data;
  }
}
