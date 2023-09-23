// ignore_for_file: avoid_print

import 'dart:math';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_poster_list_test/src/blocs/cubit/poster_cubit.dart';
import 'package:flutter_poster_list_test/src/components/custom_elevated_button.dart';
import 'package:flutter_poster_list_test/src/extensions/color_hex_extension.dart';
import 'package:flutter_poster_list_test/src/models/poster/movie_model.dart';
import 'package:flutter_poster_list_test/src/res/colors.dart';
import 'package:flutter_poster_list_test/src/res/dimens.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<MovieData> _data = [];
  PageController _pageController = PageController();
  var viewportFraction = 0.8;
  double? pageOffset = 0;
  int currentIndex = 0;

  /// Fetch data from fake data or API with Cubit
  ///
  void getData() {
    try {
      context.read<PosterCubit>().fetchFakeData();
    } catch (e) {
      rethrow;
    }
  }

  /// Get current index from [_pageController]
  ///
  void getCurrentPageIndex() {
    currentIndex = _pageController.page?.round() ?? 0;

    setState(() {});
  }

  @override
  void initState() {
    getData();

    /// Initialize [_pageController] and [addListener]
    ///
    _pageController =
        PageController(initialPage: 0, viewportFraction: viewportFraction)
          ..addListener(() {
            getCurrentPageIndex();
            setState(() => pageOffset = _pageController.page);
          });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Store size from [MediaQuery] to [screenSize]
    ///
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocConsumer<PosterCubit, PosterState>(
        listener: (context, state) {
          /// Listener from [PosterState]
          ///
          if (state is PosterLoading) {
            print("State loading");
          } else if (state is PosterError) {
            print("State Error => ${state.error.message}");
          } else if (state is PosterSuccess) {
            print("State success");

            /// Store data from [PosterSuccess] to [_data]
            ///
            _data = state.data;
          }
        },
        builder: (context, state) {
          if (state is PosterLoading) {
            /// Show loading indicator when [state] is PosterLoading
            ///
            return const Center(child: CircularProgressIndicator());
          } else {
            return Stack(
              children: [
                Image.asset(
                  'assets/images/background.jpeg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                PageView.builder(
                    allowImplicitScrolling: true,
                    controller: _pageController,
                    itemCount: _data.length,
                    itemBuilder: (context, i) {
                      /// Set the [angleY] and [scale] when page is scrolled
                      ///
                      double scale = max(viewportFraction,
                          1 - (pageOffset! - i).abs() + viewportFraction);
                      double angleY = (pageOffset! - i).abs();

                      if (angleY > 0.5) {
                        angleY = 1 - angleY;
                      }

                      return Padding(
                        padding: EdgeInsets.only(
                          right: screenSize.width * 0.01,
                          left: screenSize.width * 0.01,
                          top: 100 - scale * 25,
                          bottom: screenSize.width * 0.06,
                        ),
                        child: Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angleY),
                          alignment: Alignment.center,
                          child: Material(
                            color: Colors.transparent,
                            elevation: 15,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    'assets/images/${_data[i].image}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: screenSize.height / 1,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.1),
                                              Colors.white.withOpacity(0.1),
                                              Colors.white
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: const [0, 0.15, 0.8],
                                            tileMode: TileMode.clamp,
                                          ),
                                        ),
                                      )),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: PAD_SYM_H20,
                                      child: GestureDetector(
                                        onTap: () {
                                          /// onTap handler
                                          ///
                                          /// [showModalBottomSheet] to show movie details
                                          showModalBottomSheet(
                                              context, _data[i]);
                                        },
                                        child: Container(
                                          width: 300,
                                          height: 500,
                                          padding: PAD_ALL_20,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.97),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            boxShadow: [defaultShadow],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  height: 220,
                                                  width: 150,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    child: Image.asset(
                                                      'assets/images/${_data[i].image}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                              const SizedBox(height: 15),
                                              SizedBox(
                                                child: Text(
                                                  _data[i].title.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1.3),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              SizedBox(
                                                height: 35,
                                                width: double.infinity,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      _data[i].genres!.length,
                                                  itemBuilder: (context, j) {
                                                    var item =
                                                        _data[i].genres![j];
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          right: j !=
                                                                  _data[i]
                                                                          .genres!
                                                                          .length -
                                                                      1
                                                              ? 10
                                                              : 0),
                                                      child: ChoiceChip(
                                                          label: Text(
                                                            item.toString(),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          padding: PAD_SYM_H10,
                                                          elevation: 0,
                                                          pressElevation: 0,
                                                          selected: false,
                                                          selectedColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          disabledColor: Colors
                                                              .transparent,
                                                          onSelected:
                                                              (value) {}),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _data[i].rating.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        height: 1.3),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  SmoothStarRating(
                                                    allowHalfRating: true,
                                                    onRatingChanged: (v) {
                                                      setState(() {});
                                                    },
                                                    starCount: 5,
                                                    rating:
                                                        (_data[i].rating! / 2),
                                                    size: 25,
                                                    halfFilledIconData:
                                                        Icons.star_half,
                                                    defaultIconData:
                                                        Icons.star_border,
                                                    color: Colors.yellow,
                                                    borderColor:
                                                        Colors.grey.shade300,
                                                    spacing: 2.0,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: WormEffect(
                          spacing: 15,
                          dotHeight: 10,
                          dotWidth: 10,
                          type: WormType.thin,
                          activeDotColor: Colors.grey,
                          dotColor: Colors.grey.shade300),
                      onDotClicked: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.fastLinearToSlowEaseIn,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                        padding: PAD_SYM_H70,
                        child: CustomElevatedButton(
                          width: double.infinity,
                          onPressed: () {},
                          gradient: LinearGradient(
                            colors: [
                              Colors.black54,
                              HexColor.fromHex(
                                  _data[currentIndex].colorHighlight.toString())
                            ],
                            stops: const [
                              0.1,
                              0.9,
                            ],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                          ),
                          // buttonColor: Colors.black54,
                          borderRadius: BorderRadius.circular(5),
                          child: const Text(
                            'Buy Ticket',
                            style: TextStyle(color: Colors.white),
                          ),
                        ))),
              ],
            );
          }
        },
      ),
    );
  }
}

showModalBottomSheet(BuildContext context, MovieData movieData) {
  showStickyFlexibleBottomSheet(
    minHeight: 0,
    initHeight: 0.5,
    maxHeight: 0.71,
    headerHeight: 20,
    context: context,
    bottomSheetBorderRadius: BorderRadius.circular(40),
    headerBuilder: (BuildContext context, double offset) {
      return Container(height: 20);
    },
    bodyBuilder: (BuildContext context, double offset) {
      return SliverChildListDelegate(
        <Widget>[
          Stack(
            children: [
              Padding(
                padding: PAD_ASYM_H20_V10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 220,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset(
                            'assets/images/${movieData.image}',
                            fit: BoxFit.cover,
                          ),
                        )),
                    const SizedBox(height: 15),
                    SizedBox(
                      child: Text(
                        movieData.title.toString(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.3),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 35,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movieData.genres!.length,
                        itemBuilder: (context, j) {
                          var item = movieData.genres![j];
                          return Container(
                            margin: EdgeInsets.only(
                                right:
                                    j != movieData.genres!.length - 1 ? 10 : 0),
                            child: ChoiceChip(
                                label: Text(
                                  item.toString(),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                padding: PAD_SYM_H10,
                                elevation: 0,
                                pressElevation: 0,
                                selected: false,
                                selectedColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                backgroundColor: Colors.transparent,
                                disabledColor: Colors.transparent,
                                onSelected: (value) {}),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          movieData.rating.toString(),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.3),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 5),
                        SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: (movieData.rating! / 2),
                          size: 25,
                          halfFilledIconData: Icons.star_half,
                          defaultIconData: Icons.star_border,
                          color: Colors.yellow,
                          borderColor: Colors.grey.shade300,
                          spacing: 2.0,
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      movieData.synopsis.toString(),
                      style: const TextStyle(fontSize: 16, height: 1.3),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 15),
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.symmetric(
                            horizontal: offset > 0.65 ? 20 : 70),
                        child: CustomElevatedButton(
                          width: double.infinity,
                          onPressed: () {},
                          gradient: LinearGradient(
                            colors: [
                              Colors.black54,
                              HexColor.fromHex(
                                  movieData.colorHighlight.toString())
                            ],
                            stops: const [0.1, 0.9],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          child: const Text(
                            'Buy Ticket',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          )
        ],
      );
    },
    anchors: [0, 0.4, 0.6],
  );
}
