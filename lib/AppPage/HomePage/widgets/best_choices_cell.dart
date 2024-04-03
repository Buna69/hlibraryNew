import 'package:flutter/material.dart';
class BestChoicesCell extends StatelessWidget {
  final Map bObj;
  const BestChoicesCell({super.key, required this.bObj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        // color: Colors.red,
        width: media.width * 0.32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(                  
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 2),
                        blurRadius: 5)
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  bObj["images"].toString(),
                  width: media.width * 0.32,
                  height: media.width * 0.50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              bObj["name"].toString(),
              maxLines: 3,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              bObj["author"].toString(),
              maxLines: 1,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 11,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ));
  }
}