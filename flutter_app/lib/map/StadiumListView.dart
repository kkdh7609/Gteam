import 'package:gteams/map/StadiumListData.dart';
import 'package:flutter/material.dart';

class StadiumListView extends StatelessWidget {

  final StadiumListData stadiumList;
  final int index;
  final PageController pageController;
  StadiumListView({Key key, this.stadiumList,this.index,this.pageController}) : super(key: key);


  @override
  Widget build(BuildContext context) {
      return AnimatedBuilder(
          animation: pageController,
          builder: (BuildContext context, Widget widget){
            double value = 1;
            if (pageController.position.haveDimensions){
              value = pageController.page - index;
              value = ( 1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
            }
            return Center(
              child: SizedBox(
                height: Curves.easeInOut.transform(value) * 300.0,
                width: Curves.easeInOut.transform(value) * 500.0,
                child: widget,
              ),
            );
          },

          child: InkWell(
              child: Stack(
                  children: [
                    Center(
                        child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 20.0,
                            ),
                            height: 125.0,
                            width: 275.0,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(1.0),
                                boxShadow:[
                                  BoxShadow(
                                    color: Colors.black54,
                                    offset: Offset(0.0, 10.0),
                                    blurRadius: 10.0,
                                  ),
                                ],
                                border: Border(
                                    bottom: BorderSide(color: Color(0xff3B5998), width: 2.0),
                                    left: BorderSide(color: Color(0xff3B5998), width: 2.0),
                                    right: BorderSide(color: Color(0xff3B5998), width: 2.0),
                                    top:  BorderSide(color: Color(0xff3B5998), width: 2.0)
                                )
                            ),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white),
                                child: Row(
                                    children:[
                                      SizedBox(width: 10.0),
                                      Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            Container(
                                                width: 250.0,
                                                child: Text(
                                                    stadiumList.stadiumName,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Color(0xff3B5998),
                                                        fontSize: 22.5,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                )
                                            ),
                                            Container(
                                                width: 250.0,
                                                child:Text(
                                                    stadiumList.location,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                ),
                                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(color: Colors.blueGrey),
                                                    )
                                                )
                                            ),
                                            Container(
                                              width: 250.0,
                                              child: Text(
                                                  stadiumList.etc,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines:3,
                                                  style: TextStyle(
                                                      fontSize: 11.0,
                                                      fontWeight: FontWeight.w400
                                                  )
                                              ),
                                            )]
                                      )
                                    ]
                                )
                            )
                        )
                    )
                  ]
              )
          )
      );
    }
  }
