import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrot_market/components/manner_temperature_widget.dart';
import 'package:carrot_market/repository/contents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:carrot_market/utils/data_utils.dart';

// ignore: must_be_immutable
class DetailContentView extends StatefulWidget {
  Map<String, String> data;
  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with SingleTickerProviderStateMixin {
  late ContentsRepository contentsRepository;
  late Size size;
  late List<Map<String, String>> imgList;
  late int _current;
  late double scrollPositionToAlpha = 0;
  ScrollController _controller = ScrollController();
  late AnimationController _animationController;
  late Animation _colorTween;
  bool isMyFavoritContent = false;

  @override
  void initState() {
    super.initState();
    contentsRepository = ContentsRepository();
    isMyFavoritContent = false;
    _animationController = AnimationController(vsync: this);
    _colorTween =
        ColorTween(begin: Colors.white, end: Colors.black).animate(_animationController);
    _controller.addListener(() {
      print(_controller.offset);
      setState(() {
        if (_controller.offset < 0) scrollPositionToAlpha = 0;
        if (_controller.offset > 255)
          scrollPositionToAlpha = 255;
        else
          scrollPositionToAlpha = _controller.offset;

        _animationController.value = scrollPositionToAlpha / 255;
      });
    });
    _loadMyFavoriteContentState();
  }

  _loadMyFavoriteContentState() async {
    bool ck = await contentsRepository.isMyFavoriteContents(widget.data["cid"]!);
    setState(() {
      isMyFavoritContent = ck;
    });
  }

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

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) {
          return Icon(
            icon,
            color: _colorTween.value,
          );
        });
  }

  // ????????????, ?????? ???????????? ?????? ???????????? ?????????
  AppBar _appBarWidget() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scrollPositionToAlpha.toInt()),
      elevation: 0,
      leading: IconButton(
        icon: _makeIcon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: _makeIcon(Icons.share),
          color: Colors.white,
        ),
        IconButton(
          onPressed: () {},
          icon: _makeIcon(Icons.more_vert),
          color: Colors.white,
        )
      ],
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(controller: _controller, slivers: [
      SliverList(
          delegate: SliverChildListDelegate([
        _makeSliderImage(),
        _sellerSimpleInfo(),
        _line(),
        _contentDetail(),
        _line(),
        _otherSellContents()
      ])),
      SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
            delegate: SliverChildListDelegate(List.generate(20, (index) {
              return Container(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(color: Colors.grey, height: 120)),
                  Text(
                    '?????? ??????',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    '??????',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ]),
              );
            }).toList()),
          ))
    ]);
  }

  Widget _makeSliderImage() {
    return Container(
      child: Stack(
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
      ),
    );
  }

  Widget _bottomNavigationBarWidget() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: size.width,
        height: 55,
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                isMyFavoritContent
                    ? await contentsRepository
                        .deleteMyFavoriteContent(widget.data["cid"]!) // ??????
                    : await contentsRepository.addMyFavoriteContent(widget.data); // ??????
                setState(() {
                  isMyFavoritContent = !isMyFavoritContent;
                });

                final snackBar = SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text(isMyFavoritContent ? "??????????????? ??????" : "?????????????????? ??????"),
                );

                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: SvgPicture.asset(
                  isMyFavoritContent
                      ? "assets/svg/heart_on.svg"
                      : "assets/svg/heart_off.svg",
                  width: 25,
                  height: 25,
                  color: Color(0xfff08f4f)),
            ),
            Container(
                margin: const EdgeInsets.only(left: 15, right: 10),
                width: 1,
                height: 40,
                color: Colors.grey.withOpacity(0.3)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(DataUtils.calcStringToWon(widget.data["price"]!),
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Text(
                  "?????? ?????? ??????",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
              ],
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    print('hi');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xfff08f4f),
                    ),
                    child: Text(
                      "???????????? ????????????",
                      style: TextStyle(
                          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ))
          ],
        ));
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: Image.asset('assets/images/user.png').image,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '???????????? ??????',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '????????? ?????????',
            ),
          ],
        ),
        Expanded(child: MannerTemerature(MannerTemp: 37.5))
      ]),
    );
  }

  Widget _line() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            widget.data["title"]!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            "?????????/?????? 22?????? ???",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 15),
          Text(
            "???????????? ??????????????? ?????? ??????????????? ????????????.",
            style: TextStyle(height: 1.5, fontSize: 15),
          ),
          SizedBox(height: 15),
          Text(
            "?????? 3 ?????? 117 ?????? 295",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _otherSellContents() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("??????????????? ?????? ??????",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          Text("?????? ??????", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
