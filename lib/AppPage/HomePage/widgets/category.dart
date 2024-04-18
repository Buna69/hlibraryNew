import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Category extends StatelessWidget {
  final Map<String, dynamic> bObj;

  const Category({Key? key, required this.bObj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
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
                  blurRadius: 5,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                bObj["coverUrl"],
                width: media.width * 0.32,
                height: media.width * 0.50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Text(
              bObj["name"].toString(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              bObj["author"].toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
