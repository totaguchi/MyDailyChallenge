class Challenge {
  String name;
  int time;
  List<dynamic> achievedThisMonthList = List<dynamic>();

  Challenge();

  Challenge.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      time = json['time'],
      achievedThisMonthList = json['achieved_this_month_list'];
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'time' : time,
    'achieved_this_month_list' : achievedThisMonthList,
  };
}