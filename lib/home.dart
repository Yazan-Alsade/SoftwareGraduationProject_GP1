import 'package:carousel_slider/carousel_slider.dart';
import 'package:construction_company/dash.dart';
import 'package:flutter/material.dart';
import 'dash.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

int _currentIndex = 0;

class _HomeState extends State<Home> {
  List image = [
    {"id": 1, "path": 'images/istockphoto-511061090-170667a.jpg'},
    {"id": 2, "path": 'images/istockphoto-1385368397-170667a.jpg'},
    {"id": 3, "path": 'images/istockphoto-1330168130-170667a.jpg'},
    {"id": 4, "path": 'images/istockphoto-1385368397-170667a.jpg'},
    {"id": 5, "path": 'images/istockphoto-1297780288-170667a.jpg'},
    {"id": 6, "path": 'images/istockphoto-1456699734-170667a.jpg'},
  ];
  final CarouselController carousel = CarouselController();
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(185, 119, 82, 111),
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: Text('Main Page'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 184, 120, 170),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF0F0F0),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Color.fromARGB(255, 107, 78, 78)),
                label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
                color: Color.fromARGB(255, 107, 78, 78),
              ),
              label: "Projects",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_box,
                  color: Color.fromARGB(255, 107, 78, 78),
                ),
                label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.more,
                  color: Color.fromARGB(255, 107, 78, 78),
                ),
                label: "Chat"),
          ]),
      body: Column(
        children: [
          Visibility(
            visible: _currentIndex == 0,
            child: Container(
                child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    print(current);
                  },
                  child: CarouselSlider(
                      items: image
                          .map(
                            (e) => Image.asset(
                              e['path'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                          .toList(),
                      carouselController: carousel,
                      options: CarouselOptions(
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlay: true,
                          aspectRatio: 2,
                          viewportFraction: 1,
                          onPageChanged: (indexx, reason) {
                            setState(() {
                              current = indexx;
                            });
                          })),
                ),
                Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: image.asMap().entries.map((entry) {
                        print(entry);
                        print(entry.key);
                        return GestureDetector(
                          onTap: () {
                            carousel.animateToPage(entry.key);
                          },
                          child: Container(
                            width: current == entry.key ? 17 : 7,
                            height: 7.0,
                            margin: EdgeInsets.symmetric(horizontal: 3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: current == entry.key
                                    ? Colors.red
                                    : Color.fromARGB(255, 17, 32, 31)),
                          ),
                        );
                      }).toList(),
                    )),
                SizedBox(
                  height: 20,
                )
              ],
            )),
          ),
          getBodyWidget(),
        ],
      ),
    );
  }

  getBodyWidget() {
    return (_currentIndex == 0) ? Dashboard() : Container();
  }
}