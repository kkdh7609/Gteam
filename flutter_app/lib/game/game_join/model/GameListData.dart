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

  static List<GameListData> gameList = [
    GameListData(
      imagePath: 'assets/image/hotel/hotel_1.png',
      titleTxt: '5 vs 5 FootSal',
      subTxt: 'Ho-Mae-Sil, Suwon, Gyeonggi-do',
      dist: 2.0,
      reviews: 80,
      rating: 4.4,
      perNight: 180,
    ),
    GameListData(
      imagePath: 'assets/image/hotel/hotel_2.png',
      titleTxt: '6 vs 6 FootSal Only Gosu',
      subTxt: 'Gwang-gyo, Suwon, Gyeonggi-do',
      dist: 4.0,
      reviews: 74,
      rating: 4.5,
      perNight: 200,
    ),
    GameListData(
      imagePath: 'assets/image/hotel/hotel_3.png',
      titleTxt: '3 vs 3 Mini FootSal Please Chobo',
      subTxt: 'Go-Saek, Suwon, Gyeonggi-do',
      dist: 3.0,
      reviews: 62,
      rating: 4.0,
      perNight: 60,
    ),
    GameListData(
      imagePath: 'assets/image/hotel/hotel_4.png',
      titleTxt: '4 vs 4 Footsal A-mu-na',
      subTxt: 'Suwon-Station, Suwon, Gyeonggi-do',
      dist: 7.0,
      reviews: 90,
      rating: 4.4,
      perNight: 170,
    ),
    GameListData(
      imagePath: 'assets/image/hotel/hotel_5.png',
      titleTxt: '2 vs 2 Footsal Practice',
      subTxt: 'World-cup Stadium, Suwon, Gyeonggi-do',
      dist: 2.0,
      reviews: 240,
      rating: 4.5,
      perNight: 200,
    ),
  ];
}
