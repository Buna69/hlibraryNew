import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hlibrary/AppPage/HomePage/widgets/top_picks_cell.dart';
import 'package:hlibrary/AppPage/HomePage/widgets/category.dart';
import 'package:hlibrary/AppPage/SearchPage/search_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../BookDetailPage/book_detail.dart';
import 'InsideCategory/inside_category_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _fetchCategoriesFuture;
  SharedPreferences? _prefs;
  List<Map<String, dynamic>> topPicksArr = [
    {
      "name": "The Green Witch",
      "author": "Arin Hiscock Murphy",
      "coverUrl":
      "https://firebasestorage.googleapis.com/v0/b/hlibrary-81590.appspot.com/o/bookCover%2FThe%20Green%20Witch?alt=media&token=615bf8a7-7fa1-4ce7-96b2-70c7f8ec9f98",
      "description":
      "In a world where technology often disconnects us from nature, many are turning to alternative practices to reconnect with the Earth’s energy. One such practice is green witchcraft, a tradition deeply rooted in nature and the elements. “The Green Witch” book serves as a guide for those seeking to explore the magic of green witchcraft and harness the power of nature in their spiritual journey.",
      "pdfUrl":
      "https://firebasestorage.googleapis.com/v0/b/hlibrary-81590.appspot.com/o/bookPDF%2FThe%20Green%20Witch?alt=media&token=b1d18dc0-6031-4d10-be1d-82079cb66955",
    },
    {
      "name": "MATLAB ашиглан холбооны системийн зарчим",
      "author": "JOHN W. LEIS",
      "coverUrl":
      "https://firebasestorage.googleapis.com/v0/b/hlibrary-81590.appspot.com/o/bookCover%2FMATLAB%20%D0%B0%D1%88%D0%B8%D0%B3%D0%BB%D0%B0%D0%BD%20%D1%85%D0%BE%D0%BB%D0%B1%D0%BE%D0%BE%D0%BD%D1%8B%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D0%B8%D0%B9%D0%BD%20%D0%B7%D0%B0%D1%80%D1%87%D0%B8%D0%BC?alt=media&token=4109e014-1192-4f3f-835d-9069eba68002",
      "description":
      "History has probably never witnessed such a dramatic rise in technical sophistication, coupled with blanket penetration into everyday life, as has occurred in recent times with telecommunications. The combination of electronic systems, together with readily available programmable devices, provides endless possibilities for interconnecting what were previously separated and isolated means of communicating, both across the street and across the globe. How, then, is the college- or university-level student to come to grips with all this sophistication in just a few semesters of study? Human learning has not changed substantially, but the means to acquire knowledge and shape understanding certainly has. This is through the ability to experiment, craft, code, and create systems of our own making. This book recognizes that a valuable approach is that of learn-by-doing, experimenting, making mistakes, and altering our mental models as a result. Whilst there are many excellent reference texts on the subject available, they can be opaque and impenetrable to the newcomer. This book is not designed to simply offer a recipe for each current and emerging technology. Rather, the underpinning theories and ideas are explained in order to motivate the why does it work in this way? questions rather than how does technology X work?. With these observations as a background, this book was designed to cover many fundamental topics in telecommunications but without the need to master a large body of theory whose relevance may not immediately be apparent. It is suitable for several one-semester courses focusing on one or more topics in radio and wireless modulation, reception and transmission, wired networks, and fiber-optic communications. This is then extended to packet networks and TCP/IP and then to digital source and channel coding and the basics of data encryption. The emphasis is on understanding, rather than regurgitating facts. Digital communications is addressed with the coverage of packet-switched networks, with many fundamental concepts such as routing via shortest path introduced with simple, concrete, and intuitive examples.xiv PrefaceThe treatment of advanced telecommunication topics extends to OFDM for wireless modulation and public-key exchange algorithms for data encryption. The reader is urged to try the examples as they are given. MATLAB® was chosen as the vehicle for demonstrating many of the basic ideas, with code examples in every chapter as an integral part of the text, rather than an afterthought. Since MATLAB® is widely used by telecommunication engineers, many useful take-home skills may be developed in parallel with the study of each aspect of telecommunications. In addition to the coding and experimentation approach, many real-world examples are given where appropriate. Underpinning theory is given where necessary, and a Useful Preliminaries section at the start of each chapter serves to remind students of useful background theory, which may be required in order to understand the theoretical and conceptual developments presented within the chapter. Although an enormous effort, it has been an ongoing source of satisfaction in writing the book over several years and developing the “learn-by-doing’’ concept in a field that presents so many challenges in formulating lucid explanations. I hope that you will find it equally stimulating to your own endeavors and that it helps to understand the power and potential of modern communication systems. I will consider that my aims have been achieved if reading and studying the book is not a chore to you, but, rather, a source of motivation and inspiration to learn more.",
      "pdfUrl":
      "https://firebasestorage.googleapis.com/v0/b/hlibrary-81590.appspot.com/o/bookPDF%2FMATLAB%20%D0%B0%D1%88%D0%B8%D0%B3%D0%BB%D0%B0%D0%BD%20%D1%85%D0%BE%D0%BB%D0%B1%D0%BE%D0%BE%D0%BD%D1%8B%20%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D0%B8%D0%B9%D0%BD%20%D0%B7%D0%B0%D1%80%D1%87%D0%B8%D0%BC?alt=media&token=37933b3e-245d-4622-b34b-1755dac90816",
    },
    {
      "name": "Infinity Northern",
      "author": "Б. БИЛГҮҮН, Б. БӨХ-ЭРДЭНЭ, Б. МЭНДСАЙХАН",
      "coverUrl":
      "https://firebasestorage.googleapis.com/v0/b/hlibrary-81590.appspot.com/o/bookCover%2FInfinity%20Northern?alt=media&token=f0810506-47e3-4327-a8a6-b3532668596a",
      "description":
      "Технологийн эрин зуунд амьдарч байгаа бидний амьдралын салшгүй нэг хэсэг болвидео тоглоомын ертөнц билээ. Видео тоглоомыг хэтрүүлэн тоглох нь амьд харилцааэрүүл мэнд зэрэгт сөрөг нөлөөтэй хэдий ч чөлөөт зав цагаараа зугаа гаргах зорилгоор өөрттааруулан тогловол бидний амьдралыг илүү сонирхолтой болгох юм. Ийм учраас манай баг хүмүүсийн сонирхлыг татахуйц мөн хүртээмжтэй байлгахүүднээс гар утасны видео тоглоомыг төгсөлтийн ажлын сэдвээрээ сонгосон болно.",
      "pdfUrl":
      "https://firebasestorage.googleapis.com/v0/b/hlibrary-81590.appspot.com/o/bookPDF%2FInfinity%20Northern?alt=media&token=45ccada3-aeec-400a-aa12-6f1bcc15220a",
    },
    {
      "name": "IELTS-д бэлдээрэй - уншлага",
      "author": "ELS VAN GEYTE",
      "coverUrl":
      "https://firebasestorage.googleapis.com/v0/b/hlibrary-81590.appspot.com/o/bookCover%2FIELTS-%D0%B4%20%D0%B1%D1%8D%D0%BB%D0%B4%D1%8D%D1%8D%D1%80%D1%8D%D0%B9%20-%20%D1%83%D0%BD%D1%88%D0%BB%D0%B0%D0%B3%D0%B0?alt=media&token=37181544-1e6c-4242-bfc4-995e4ee2d0e4",
      "description":
      "Get Ready for IELTS Reading has been written for learners with a band score of 3 or 4 who want to achieve a higher score. Using this book will help you improve your pre-intermediate reading skills for the IELTS Academic Reading test. You can use Get Ready for IELTS Reading: • as a self-study course. We recommend that you work systematically through the 12 units in order to benefit from its progressive structure. • as a supplementary reading skills course for IELTS preparation classes. The book provides enough material for approximately 50 hours of classroom activity.",
      "pdfUrl":
      "https://firebasestorage.googleapis.com/v0/b/hlibrary-81590.appspot.com/o/bookPDF%2FIELTS-%D0%B4%20%D0%B1%D1%8D%D0%BB%D0%B4%D1%8D%D1%8D%D1%80%D1%8D%D0%B9%20-%20%D1%83%D0%BD%D1%88%D0%BB%D0%B0%D0%B3%D0%B0?alt=media&token=819af943-0836-4a13-a711-e1f5566863f7",
    },
    {
      "name": "Apple Education",
      "author": "Б. СОДГЭРЭЛ",
      "coverUrl":
      "https://firebasestorage.googleapis.com/v0/b/hlibrary-81590.appspot.com/o/bookCover%2FApple%20Education?alt=media&token=fedc98c4-1e79-4fdd-babb-ad2e84ec247b",
      "description":
      "Хэн нэгнээс ямар ч хамааралгүйгээр өөрийн цэвэр сонирхолын дагуу манай сайтнаас хичээл сонгон үзэх боломжтой бөгөөд нэг хичээл бүрийн үнэ нь их дээдсургуулийн 1 кредитын мөнгөн дүнгийн тал хувьд тэнцүү байхаар тооцоолон үйлажиллагаагаа хүргэх боломжтой байдаг тул та одоо бидний сайтнаас хичээл сонгож үзэх боломжтой байгаа шүү. Тэгвэл уншигчийн хамгийн анх та тухайн багшаа бүртгүүлснээр хичээлийн үнэгүй хугацаанд манай сайтнаас уншиж эхлэх боломжтой болно. Тухайн багшийн нэр нь тухайн гарын авлагын хэсэгт бичигдсэн үг бүрээр бүртгүүлснээр ихэнх хичээлийг үнэгүйээр уншиж эхэлнэ. Тиймээс бид танд амжилт хүссэн болон үргэлжлүүлж амжилт хүсье.",
      "pdfUrl":
      "https://firebasestorage.googleapis.com/v0/b/hlibrary-81590.appspot.com/o/bookPDF%2FApple%20Education?alt=media&token=88dbd78b-7879-43db-bf0b-15db54fa5102",

    }
  ];
  List<Map<String, dynamic>> allBooks = []; // List to hold all book data

  @override
  void initState() {
    super.initState();
    _initializePrefs();
    _fetchCategoriesFuture = fetchCategories();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('categories').get();

    List<DocumentSnapshot> categoryDocs = querySnapshot.docs;
    List<Map<String, dynamic>> categories = categoryDocs
        .map((doc) => {"category": doc['categoryName']})
        .toList();

    // Save categories locally
    _prefs?.setString('categories', categories.toString());

    return categories;
  }

  Future<List<Map<String, dynamic>>> fetchBooksForCategory(
      String categoryName) async {
    if (categoryName.isEmpty) {
      // Handle the case where the category name is empty
      return [];
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryName)
        .collection('Book Collection')
        .get();

    List<DocumentSnapshot> bookDocs = querySnapshot.docs;
    List<Map<String, dynamic>> books = bookDocs
        .map((doc) => {
      "name": doc['name'],
      "author": doc['author'],
      "coverUrl": doc['coverUrl'],
      "description": doc['description'],
      "pdfUrl": doc['pdfUrl'],
    })
        .toList();

    // Save books for category locally
    _prefs?.setString(categoryName, books.toString());

    // Add fetched books to the list of all books
    allBooks.addAll(books);

    return books;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchCategoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Map<String, dynamic>> categories = snapshot.data!;
              return Column(
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
                                borderRadius: BorderRadius.circular(
                                    media.width * 0.5)),
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
                            title: const Row(
                              children: [
                                Text(
                                  "Our Top Picks",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            leading: Container(),
                            leadingWidth: 1,
                            actions: [
                              IconButton(
                                iconSize: 35,
                                icon: const Icon(Icons.search),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchPage(allBooks: allBooks),
                                    ),
                                  );
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
                                final Map<String, dynamic> iObj =
                                topPicksArr[itemIndex];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BookDetailPage(bookDetails: iObj),
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
                                autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                aspectRatio: 1,
                                enlargeCenterPage: true,
                                viewportFraction: 0.45,
                                enlargeFactor: 0.4,
                                enlargeStrategy:
                                CenterPageEnlargeStrategy.zoom,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Add some space at the end
                  for (var category in categories)
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchBooksForCategory(category['category']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Map<String, dynamic>> books = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      category['category'] ?? '',
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
                                              builder: (context) =>
                                                  InsideCategoryPage(
                                                    category: category[
                                                    'category'] ??
                                                        '',
                                                    books: books,
                                                  ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.arrow_forward),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: media.width * 0.9,
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 8),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: books.length,
                                  itemBuilder: ((context, index) {
                                    final Map<String, dynamic> bObj =
                                    books[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BookDetailPage(
                                                  bookDetails: bObj,
                                                ),
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
                          );
                        }
                      },
                    ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
