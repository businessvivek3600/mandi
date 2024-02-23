import '../utils/utils_index.dart';

class Game {
  int? id;
  String? name;
  String? title;
  String? timing;
  int? order;
  int? today;
  int? yesterday;

  Game(
      {this.id,
      this.name,
      this.title,
      this.timing,
      this.order,
      this.today,
      this.yesterday});

  Game.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    timing = json['timing'];
    order = json['order'];
    today = json['today'];
    yesterday = json['yesterday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['title'] = title;
    data['timing'] = timing;
    data['order'] = order;
    data['today'] = today;
    data['yesterday'] = yesterday;
    return data;
  }
}

class GameResult {
  int? id;
  String? date;
  int? gameId;
  String? number;
  Game? game;

  GameResult({this.id, this.date, this.gameId, this.number, this.game});

  GameResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    gameId = json['game_id'];
    number = json['number'];
    game = tryCatch<Game>(() => Game.fromJson(json['game']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['game_id'] = gameId;
    data['number'] = number;
    data['game'] = game;
    return data;
  }
}
