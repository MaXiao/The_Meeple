class Player {
  String name;
  DateTime created;
  DateTime lastPlayed;

  Player(this.name, this.created, this.lastPlayed);

  @override
  bool operator ==(other) => (other is Player) && (other.name == name);
  @override
  int get hashCode => name.hashCode;
}