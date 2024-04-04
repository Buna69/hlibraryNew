import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:hlibrary/AppPage/HomePage/widgets/best_choices_cell.dart';
import 'package:hlibrary/AppPage/HomePage/widgets/category.dart';
import 'package:hlibrary/AppPage/HomePage/widgets/top_picks_cell.dart';

import '../BookDetailPage/book_detail.dart';
import '../SearchPage/search_page.dart';
import 'InsideCategory/inside_category_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List topPicksArr = [
    {
      "name": "Manhwa1",
      "author": "Author1",
      "images": "assets/images/1.jpg",
      "description": "Description1",
    },
    {
      "name": "Manhwa2",
      "author": "Author1",
      "images": "assets/images/2.jpg",
      "description": "Description1",
    },
    {
      "name": "Manhwa3",
      "author": "Author1",
      "images": "assets/images/3.jpg",
      "description": "Description1",
    },
    {
      "name": "Manhwa4",
      "author": "Author1",
      "images": "assets/images/4.jpg",
      "description": "Description1",
    },
    {
      "name": "Manhwa5",
      "author": "Author1",
      "images": "assets/images/5.jpg",
      "description": "Description1",
    }
  ];

  List bestArr = [
    {
      "name": "Manhwa1",
      "author": "Author1",
      "images": "assets/images/6.jpg",
      "description": "Description1",},
    {
      "name": "Manhwa2",
      "author": "Author1",
      "images": "assets/images/7.jpg",
      "description": "Description1",
    },
    {
      "name": "Manhwa3",
      "author": "Author1",
      "images": "assets/images/8.jpg",
      "description": "Description1",
    }
  ];

  List cate = [
    {"category": "Manga"},
    {"category": "Manhwa"},
    {"category": "Educational"},
  ];

  Map<String, List<Map<String, dynamic>>> catBookMap = {
    "Manga": [
      {
        "name": "Manga1",
        "author": "Author1",
        "images": "assets/images/7.jpg",
        "description": " snidnsaifnisdf n idsfn  ni dsfnisn difndsio ao sn iasnfi snidnsaifnisdf n idsfn  ni dsfnisn difndsio ao sn  snidnsaifnisdf n idsfn  ni dsfnisn difndsio ao sn  snidnsaifnisdf n idsfn  ni dsfnisn difndsio ao sn  snidnsaifnisdf n idsfn  ni dsfnisn difndsio ao sn  snidnsaifnisdf n idsfn  ni dsfnisn difndsio ao sn  snidnsaifnisdf n idsfn  ni dsfnisn difndsio ao sn  snidnsaifnisdf n idsfn  ni dsfnisn difndsio ao sn  snidnsaifnisdf n idsfn  ni dsfnisn difndsio ao sn  snidnsaifnisdf n idsfn  ni dsfnisn difndsio ao sn  snidnsaifnisdf n idsfn  ni dsfnisn difndsio ao sn  snidnsaifnisdf n idsfn  ni dsfnisn difndsio ao sn  ",
      },
      {
        "name": "Manga2",
        "author": "Author2",
        "images": "assets/images/6.jpg",
        "description": "Description2",
      },
      // Add more manga books...
    ],
    "Manhwa": [
      {
        "name": "Manhwa1",
        "author": "Author1",
        "images": "assets/images/5.jpg",
        "description": "Description1",
      },
      {
        "name": "Manhwa2",
        "author": "Author2",
        "images": "assets/images/4.jpg",
        "description": "Description2",
      },
      // Add more manhwa books...
    ],
    "Educational": [
      {
        "name": "Educational1",
        "author": "Author1",
        "images": "assets/images/3.jpg",
        "description": "Description1",
      },
      {
        "name": "Educational2",
        "author": "Author2",
        "images": "assets/images/2.jpg",
        "description": "Description2",
      },
      // Add more Educational books...
    ],
  };

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Stack(
          alignment: Alignment.topCenter,
          children: [
        Align(
        child: Transform.scale(
        scale: 1.5,
          origin: Offset(0, media.width * 0.8),
          child: Container(
            width: media.width,
            height: media.width,
            decoration: BoxDecoration(
                color: const Color(0xFFFFB800),
                borderRadius:
                BorderRadius.circular(media.width * 0.5)),
          ),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: media.width * 0.1,
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Row(children: [
              Text(
                "Our Top Picks",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),


            ]),
            leading: Container(),
            leadingWidth: 1,
            actions: [
              IconButton(
                iconSize: 35,
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>  const SearchPage(),
                  ),);
                },
              ),
            ],

          ),
          SizedBox(
            width: media.width,
            height: media.width * 0.8,
            child: CarouselSlider.builder(
              itemCount: topPicksArr.length,
              itemBuilder: (BuildContext context, int itemIndex,
                  int pageViewIndex) {
                final Map<String, dynamic> iObj = topPicksArr[itemIndex] as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailPage(bookDetails: iObj),
                      ),
                    );
                  },
                  child: TopPicksCell(
                    iObj: iObj,
                  ),
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                aspectRatio: 1,
                enlargeCenterPage: true,
                viewportFraction: 0.45,
                enlargeFactor: 0.4,
                enlargeStrategy: CenterPageEnlargeStrategy.zoom,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:  const Row(children: [
              Text(
                "Best Choices",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),

            ]),
          ),
          SizedBox(
            height: media.width * 0.8,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: bestArr.length,
              itemBuilder: ((context, index) {
                final Map<String, dynamic> bObj = bestArr[index] as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailPage(bookDetails: bObj),
                      ),
                    );
                  },
                  child: BestChoicesCell(
                    bObj: bObj,
                  ),
                );
              }),
            ),
          ),
            for (var category in cate)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          category['category'] ?? '', // Ensure category is not null
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFB800),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InsideCategoryPage(
                                    category: category['category'] ?? '',
                                    books: catBookMap[category['category']] ?? [],
                                  ),
                                ),
                              );

                            },
                            icon: const Icon(Icons.arrow_forward),
                          )

                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.8,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 8),
                      scrollDirection: Axis.horizontal,
                      itemCount: catBookMap[category['category']]?.length ?? 0, // Ensure catBookMap[category['category']] is not null
                      itemBuilder: ((context, index) {
                        final Map<String, dynamic> bObj = catBookMap[category['category']]?[index] ?? {}; // Provide default value for bObj

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookDetailPage(bookDetails: bObj),
                              ),
                            );
                          },
                          child: Category(
                            bObj: bObj,
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                ],
              ),
          ],
        ),
      ]),
    ])));
  }
}
