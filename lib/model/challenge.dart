class Challenge {
  String name;
  int time;

  Challenge();

  Challenge.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      time = json['time'];
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'time' : time
  };
}