class GameListData {

  String imagePath;
  String titleTxt;
  String subTxt;
  double dist;
  double rating;
  int reviews;
  int perNight;

  GameListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.dist = 1.8,
    this.reviews = 80,
    this.rating = 4.5,
    this.perNight = 180,
  });

  factory GameListData.fromJson(Map<String, dynamic> json){
    return GameListData(
      imagePath: json['imagePath'],
      titleTxt: json['titleTxt'],
      reviews: json['reviews'],
      perNight: json['perNight'],
      rating: (json['rating']).toDouble(),
      dist: (json['dist']).toDouble(),
      subTxt: json['subTxt'],
    );
  }

  static List<GameListData> gameList = [
  ];
}