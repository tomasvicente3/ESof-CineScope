
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CastCard extends StatelessWidget{

  final Map<dynamic,dynamic> actor;

  const CastCard({super.key, required this.actor});

  @override
  Widget build(BuildContext context) =>        Card(
          child: Container(
            width: 160,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(actor['name']),
                          content: Text(actor['characters'].join(', ')),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        actor['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        actor['characters'].join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 15),
                      Center(
                          child: ClipRect(
                              child: CachedNetworkImage(
                        height: 180,
                        imageUrl: actor['imgUrl'],
                        placeholder: (context, _) => const Image(
                            height: 180,
                            image:
                                AssetImage('assets/default-actor-image.png')),
                        errorWidget: (content, _, a) => const Image(
                            height: 180,
                            image:
                                AssetImage('assets/default-actor-image.png')),
                      ))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

}