import 'package:flutter/material.dart';
import 'package:gteams/menu/drawer/DrawerTheme.dart';
import 'package:gteams/menu/drawer/homeDrawer.dart';

class DrawerUserController extends StatefulWidget {
  final Widget menuView;
  final Widget screenView;
  final double drawerWidth;
  final DrawerIndex screenIndex;
  final VoidCallback onSignedOut;
  final Function(bool) drawerIsOpen;
  final AnimatedIconData animatedIconData;
  final Function(DrawerIndex) onDrawerCall;
  final Function(AnimationController) animationController;

  const DrawerUserController(
      {Key key,
        this.drawerWidth: 250,
        this.onDrawerCall,
        this.screenView,
        this.animationController,
        this.animatedIconData: AnimatedIcons.arrow_menu,
        this.menuView,
        this.drawerIsOpen,
        this.screenIndex,
        this.onSignedOut})
      : super(key: key);

  @override
  _DrawerUserControllerState createState() => _DrawerUserControllerState();
}

class _DrawerUserControllerState extends State<DrawerUserController> with TickerProviderStateMixin {
  ScrollController scrollController;
  AnimationController iconAnimationController;
  AnimationController animationController;

  double scrollOffset = 0.0;
  bool isSetDrawer = true;

  @override
  void initState() {
    animationController = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    iconAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    iconAnimationController.animateTo(1.0, duration: Duration(milliseconds: 0), curve: Curves.fastOutSlowIn);
    scrollController = ScrollController(initialScrollOffset: widget.drawerWidth);
    scrollController
      ..addListener(
            () {
          if (scrollController.offset <= 0) {
            if (scrollOffset != 1.0) {
              setState(() {
                scrollOffset = 1.0;
                try {
                  widget.drawerIsOpen(true);
                } catch (e) {}
              });
            }
            iconAnimationController.animateTo(0.0, duration: Duration(milliseconds: 0), curve: Curves.linear);
          } else if (scrollController.offset > 0 && scrollController.offset < widget.drawerWidth) {
            iconAnimationController.animateTo((scrollController.offset * 100 / (widget.drawerWidth)) / 100,
                duration: Duration(milliseconds: 0), curve: Curves.linear);
          } else if (scrollController.offset <= widget.drawerWidth) {
            if (scrollOffset != 0.0) {
              setState(
                    () {
                  scrollOffset = 0.0;
                  try {
                    widget.drawerIsOpen(false);
                  } catch (e) {}
                },
              );
            }
            iconAnimationController.animateTo(1.0, duration: Duration(milliseconds: 0), curve: Curves.linear);
          }
        },
      );
    getInitState();
    super.initState();
  }

  Future<bool> getInitState() async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      widget.animationController(iconAnimationController);
    } catch (e) {}
    await Future.delayed(const Duration(milliseconds: 100));
    scrollController.jumpTo(
      widget.drawerWidth,
    );
    setState(
          () {
        isSetDrawer = true;
      },
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DrawerTheme.white,
      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: PageScrollPhysics(parent: ClampingScrollPhysics()),
        child: Opacity(
          opacity: isSetDrawer ? 1 : 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width + widget.drawerWidth,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: widget.drawerWidth,
                  height: MediaQuery.of(context).size.height,
                  child: AnimatedBuilder(
                    animation: iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return new Transform(
                        transform: new Matrix4.translationValues(scrollController.offset, 0.0, 0.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: widget.drawerWidth,
                          child: HomeDrawer(
                              screenIndex: widget.screenIndex == null ? DrawerIndex.HOME : widget.screenIndex,
                              iconAnimationController: iconAnimationController,
                              callBackIndex: (DrawerIndex indexType) {
                                onDrawerClick();
                                try {
                                  widget.onDrawerCall(indexType);
                                } catch (e) {}
                              },
                              onSignedOut: widget.onSignedOut
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    decoration: BoxDecoration(
                      color: DrawerTheme.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(color: DrawerTheme.grey.withOpacity(0.6), blurRadius: 24),
                      ],
                    ),
                    child: Stack(
                      children: <Widget>[
                        IgnorePointer(
                          ignoring: scrollOffset == 1 ? true : false,
                          child: widget.screenView == null
                              ? Container(
                            color: Colors.white,
                          )
                              : widget.screenView,
                        ),
                        scrollOffset == 1.0
                            ? InkWell(onTap: () {
                          onDrawerClick();
                        })
                            : SizedBox(),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 8),
                          child: SizedBox(
                            width: AppBar().preferredSize.height - 8,
                            height: AppBar().preferredSize.height - 8,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: new BorderRadius.circular(AppBar().preferredSize.height),
                                child: Center(
                                  child: widget.menuView != null
                                      ? widget.menuView
                                      : AnimatedIcon(
                                      color: Colors.white,
                                      icon: widget.animatedIconData != null
                                          ? widget.animatedIconData
                                          : AnimatedIcons.arrow_menu,
                                      progress: iconAnimationController),
                                ),
                                onTap: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  onDrawerClick();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDrawerClick() {
    if (scrollController.offset != 0.0) {
      scrollController.animateTo(0.0, duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
    } else {
      scrollController.animateTo(
        widget.drawerWidth,
        duration: Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }
}