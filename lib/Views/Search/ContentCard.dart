import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafeq_app/DataModel/VideoCard.dart';
import 'package:rafeq_app/Views/MyCourses/FavoritesModel.dart';
import 'package:rafeq_app/Views/Search/SearchResultModel.dart';

class ContentCard extends StatelessWidget {
  final VideoCard video;

  ContentCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 330,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xff1C96F9),
                Color(0xff3351C5),
                Color(0xff27D1B3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            child: SizedBox(width: 10, height: 330),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0), // Adjust the value for desired curvature
                    child: Image.network(
                      video.thumbnailURL ?? "",
                    ),
                  ),
                ),
                ContentCardData(video: video, size: 1),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ContentCardData extends StatelessWidget {
  const ContentCardData({
    super.key,
    required this.video,
    required this.size,
  });

  final VideoCard video;
  final int size;

  @override
  Widget build(BuildContext context) {
    var favoritesModel = Provider.of<FavoritesModel>(context);
    var searchResultModel = Provider.of<SearchResultModel>(context);

    return Container(
      padding: EdgeInsets.all(size == 1 ? 20 : 10),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                video.title ?? "",
                maxLines: size == 1 ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: size == 1 ? 18 : 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Channel: ${video.channelTitle}', style: TextStyle(fontSize: size == 1 ? 12 : 10), maxLines: 1),
              Text(
                video.publishTime ?? "",
                style: TextStyle(fontSize: size == 1 ? 12 : 10),
              ),
              if (size == 1) ...[
                InkWell(
                  onTap: () async {
                    searchResultModel.openUrl(video.linkURL ?? "");
                  },
                  child: Text(
                    video.typeFormatted,
                    style: TextStyle(
                      color: Color(0xFF1C96F9),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ],
          ),
          // hide the button if size == 2
          // if (size == 1) ... [

          Container(
            margin: EdgeInsets.only(top: size == 1 ? 30 : 0),
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                favoritesModel.contains(video) ? Icons.add_circle : Icons.add,
                color: favoritesModel.contains(video) ? Colors.blue : null,
                size: 30,
              ),
              onPressed: () {
                if (favoritesModel.contains(video)) {
                  favoritesModel.remove(video);
                } else {
                  favoritesModel.add(video);
                }
              },
            ),
          ),
          // ]
        ],
      ),
    );
  }
}
