import 'package:flutter/material.dart';

class ProfileTabBar extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final ValueChanged<int> onTap;

  const ProfileTabBar({
    Key? key,
    required this.height,
    required this.onTap,
  }) : super(key: key);

  @override
  _ProfileTabBarState createState() => _ProfileTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _ProfileTabBarState extends State<ProfileTabBar> {
  bool isPost = true;
  bool isAbout = false;

  final Color _selectedColor = const Color(0xff3B7753);
  final Color _unSelectedColor = const Color.fromARGB(255, 240, 241, 239);

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
              child: Container(
                color: Colors.white,
                width: _screenWidth / 2,
                height: widget.height,
                child: Stack(
                  children: <Widget>[
                    Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 240, 241, 239),
                    ),
                  ),
                    Align(
                      child: Text(
                        'Posts',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                            color: isPost ? _selectedColor : _unSelectedColor),
                      ),
                    ),
                    isPost
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 2,
                              color: const Color(0xff3B7753),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              onTap: () {
                if (!isPost) {
                  setState(() {
                    setFlags(tabName: 'post');
                    widget.onTap(0);
                  });
                }
              }),
          GestureDetector(
            child: Container(
              color: Colors.white,
              width: _screenWidth / 2,
              height: widget.height,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 240, 241, 239),
                    ),
                  ),
                  Align(
                    child: Text(
                      'About',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                          color: isAbout ? _selectedColor : _unSelectedColor),
                    ),
                  ),
                  isAbout
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 2,
                            color: const Color(0xff3B7753),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            onTap: () {
              if (!isAbout) {
                setState(() {
                  setFlags(tabName: 'about');
                  widget.onTap(1);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  setFlags({required String tabName}) {
    switch (tabName) {
      case 'post':
        isAbout = false;
        isPost = true;
        break;

      case 'about':
        isAbout = true;
        isPost = false;
        break;
    }
  }
}
