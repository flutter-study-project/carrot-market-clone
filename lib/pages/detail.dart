import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DetailContentView extends StatefulWidget {
  Map<String, String> data;
  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  late Size size;
  late List<Map<String, String>> imgList;
  late int _current;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _current = 0;
    size = MediaQuery.of(context).size;
    imgList = [
      {"id": "0", "url": widget.data["image"]!},
      {"id": "1", "url": widget.data["image"]!},
      {"id": "2", "url": widget.data["image"]!},
      {"id": "3", "url": widget.data["image"]!},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: SafeArea(child: _bottomNavigationBarWidget()),
    );
  }

  // 투명하고, 상단 이미지가 앱바 영역까지 사용함
  AppBar _appBarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.share),
          color: Colors.white,
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_vert),
          color: Colors.white,
        )
      ],
    );
  }

  Widget _bodyWidget() {
    return Stack(
      children: [
        Hero(
            tag: widget.data['cid']!,
            child: Container(
                child: CarouselSlider(
                    items: imgList.map((img) {
                      return Image.asset(
                        img["url"]!,
                        width: size.width,
                        fit: BoxFit.fill,
                      );
                    }).toList(),
                    options: CarouselOptions(
                        height: size.width,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          print(index);
                          setState(() {
                            _current = index;
                          });
                        },
                        viewportFraction: 1)))),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((img) {
              return GestureDetector(
                // onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.white.withOpacity(0.4))
                          .withOpacity(_current == img.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _bottomNavigationBarWidget() {
    return Container(
      width: size.width,
      height: 55,
      color: Colors.red,
    );
  }
}
