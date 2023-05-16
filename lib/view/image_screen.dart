import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key, required this.image, required this.tag});
  final List image;
  final String tag;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  int page = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Center(
            child: Hero(
                tag: widget.tag,
                child: CarouselSlider(
                  items: [
                    ...widget.image.map((e) {
                      return InteractiveViewer(child: FadeInImage(image:NetworkImage(e!['file'],), placeholder: AssetImage('assets/images/placeholder.jpg'),));
                    })
                  ],
                  
                  options: CarouselOptions(
                    onPageChanged: (index, reason){
                      setState(() {
                        page = index+1;
                      });
                    },
                    autoPlay: false,
                    viewportFraction: 0.8,
                    aspectRatio: MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height,
                    enableInfiniteScroll: false,
                  ),
                )),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height*0.1,
            left:MediaQuery.of(context).size.width*0.4 ,
            child: Text('$page/${widget.image.length}'))
        ],
      ),
    );
  }
}
