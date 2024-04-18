
import 'package:flutter/material.dart';

class TopPicksCell extends StatelessWidget {
  final Map<String, dynamic> iObj;

  const TopPicksCell({Key? key, required this.iObj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return SizedBox(
      width: media.width * 0.32,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
                iObj["coverUrl"].toString(),
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
            iObj["name"].toString(),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            iObj["author"].toString(),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
            ),
          )
        ],
      ),
    );
  }
}
