import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dash.dart';
import 'login.dart';

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

  String userEmail = '';
  @override
  void initState() {
    super.initState();
    getUserEmail();
  }

  void getUserEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String? email = pref.getString('email');
    if (email != null) {
      setState(() {
        userEmail = email;
      });
    }
  }

  Future logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('email');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Sign Out has successfully"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return Login(name: '');
                  }));
                },
                child: Text("Ok"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xfff7b858),
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          ),
        ],
        title: Text('${userEmail}'),
        centerTitle: true,
        backgroundColor: Color(0xfff7b858),
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
                icon: Icon(Icons.home, color: Color(0xfff7b858)),
                label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
                color: Color(0xfff7b858),
              ),
              label: "Projects",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_box,
                  color: Color(0xfff7b858),
                ),
                label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.more,
                  color: Color(0xfff7b858),
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
                ),
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
