import 'package:flutter/material.dart';

class booka {
  final String name;
  final String imageUrl;

  booka({required this.name, required this.imageUrl});
}

class LibraryPage extends StatelessWidget {
  final List<booka> bookas = [
    booka(name: 'Shoujin Manga', imageUrl: 'assets/images/1.jpg'),
    booka(name: 'Jujutsu Kaisen', imageUrl: 'assets/images/2.jpg'),
    booka(name: 'The Faraway Paladin', imageUrl: 'assets/images/3.jpg'),
    booka(name: 'My Hero Academia', imageUrl: 'assets/images/4.jpg'),

  ];

  LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double width = screenWidth / 2;
    double height = width * 1.5;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (width / height),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: bookas.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: width,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0), // Apply border radius
              child: GridTile(
                child: Stack(
                  children: [
                    Image.asset(
                      bookas[index].imageUrl,
                      fit: BoxFit.fill,
                      height: height,
                    ),
                    Positioned(
                      width: width-5,
                      left: 0,
                      bottom: 0,
                      child: Container(
                        color: const Color.fromARGB(126, 0, 0, 0),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            bookas[index].name,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}