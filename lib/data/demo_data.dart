/// Probni podaci za ekrane koji u pravoj verziji dolaze sa servera.
class Player {
  const Player(this.name, this.level, this.wins, {this.online = false});

  final String name;
  final int level;
  final int wins;
  final bool online;
}

const me = Player('Marko85', 18, 124, online: true);

const suggestedPlayers = [
  Player('Marko85', 18, 124, online: true),
  Player('JelenaK', 14, 87),
  Player('Balkanac93', 11, 56, online: true),
  Player('MilicaNS', 22, 201),
];

const friends = [
  Player('Stefan', 10, 48, online: true),
  Player('AnaM', 16, 77),
];

const randomOpponent = Player('JelenaK', 14, 87);

const leaderboard = [
  ('Nikola96', 2340),
  ('JelenaK', 2120),
  ('Marko85', 1980),
  ('Balkanac93', 1560),
  ('MilicaNS', 1430),
  ('Stefan', 1210),
  ('AnaM', 1080),
];
