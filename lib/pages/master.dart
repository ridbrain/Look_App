import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:look_app/pages/master_map.dart';
import 'package:look_app/pages/new_record.dart';
import 'package:look_app/pages/review.dart';
import 'package:look_app/pages/user_auth.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/services/services.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/favorite.dart';
import 'package:look_app/widgets/master_last_record.dart';
import 'package:look_app/widgets/master_description.dart';
import 'package:look_app/widgets/master_nre.dart';
import 'package:look_app/widgets/master_photos.dart';
import 'package:look_app/widgets/master_prices.dart';
import 'package:look_app/widgets/master_reviews.dart';
import 'package:look_app/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MasterPage extends StatefulWidget {
  MasterPage({
    required this.master,
  });

  final Master master;

  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  var category = "";

  void pressRecord(UserProvider provider) {
    if (!provider.hasUser) {
      MainRouter.fullScreenDialog(
        context,
        UserAuthPage(
          afterClose: true,
        ),
      );
    } else {
      MainRouter.nextPage(
        context,
        NewRecord(
          master: widget.master,
          prices: [],
          userUid: provider.user.uid,
        ),
      );
    }
  }

  void shareMaster() async {
    var text = 'в лучшем приложении онлайн записи Look!';
    await FlutterShare.share(
      title: widget.master.name,
      text: '$category - ${widget.master.name} $text',
      linkUrl: 'https://looklike.beauty/${widget.master.masterId}',
    );
  }

  void getCategory() async {
    var value = await NetHandler.getGroups();
    setState(() {
      value?.forEach((element) {
        if (element.groupId == widget.master.groupId) {
          category = element.masterLabel;
        }
      });
    });
  }

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text(
              category,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: [
              Container(
                child: userProvider.hasUser
                    ? FavMaster(
                        masterId: widget.master.masterId.toString(),
                        userUid: userProvider.user.uid,
                      )
                    : SizedBox.shrink(),
              ),
              IconButton(
                icon: Icon(LineIcons.link),
                onPressed: () => shareMaster(),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Align(
              child: Hero(
                tag: widget.master.imageUrl,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 200,
                  width: 160,
                  child: ClipRRect(
                    borderRadius: Constants.radius,
                    child: CachedNetworkImage(
                      imageUrl: widget.master.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CupertinoActivityIndicator(),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: Constants.radius,
                    boxShadow: Constants.shadow,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: MasterNRE(
              name: widget.master.name,
              rating: widget.master.rating,
              experience: widget.master.experience,
              address: widget.master.metro,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: StandartButton(
                label: 'Записаться',
                onTap: () => pressRecord(userProvider),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: MasterDescriprtion(masterId: widget.master.masterId),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 5,
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedSizeAndFade(
              child: userProvider.hasUser
                  ? LastRecord(
                      uuid: userProvider.user.uid,
                      master: widget.master,
                    )
                  : Container(),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedSizeAndFade(
              child: MasterPhotos(
                masterId: widget.master.masterId,
                masterName: widget.master.name,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedSizeAndFade(
              child: Prices(master: widget.master),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedSizeAndFade(
              child: MasterReviews(masterId: widget.master.masterId),
            ),
          ),
          SliverToBoxAdapter(
            child: userProvider.hasUser
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 30),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: RoundButton(
                                icon: LineIcons.whatSApp,
                                label: "Написать",
                                onTap: () async {
                                  var success = await launch(
                                    await NetHandler.getWhatsApp(
                                      widget.master.masterId.toString(),
                                    ),
                                  );
                                  if (!success) {
                                    StandartSnackBar.show(
                                      context,
                                      'Для связи с мастером установите WhatsApp',
                                      SnackBarStatus.warning(),
                                    );
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RoundButton(
                                icon: LineIcons.thumbsUp,
                                label: "Оценить",
                                onTap: () async {
                                  var access = await NetHandler.wishReview(
                                    widget.master.masterId.toString(),
                                    userProvider.user.uid,
                                  );
                                  if (access) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ReviewPage(
                                            masterId: widget.master.masterId
                                                .toString(),
                                            userUid: userProvider.user.uid,
                                          );
                                        },
                                      ),
                                    ).then(
                                      (value) => setState(() {}),
                                    );
                                  } else {
                                    StandartSnackBar.show(
                                      context,
                                      'Для оценки работы мастера, нужно иметь хотя бы одну выполненную заявку.',
                                      SnackBarStatus.warning(),
                                    );
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RoundButton(
                                icon: LineIcons.map,
                                label: "Карта",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MapPage(
                                          masterId:
                                              widget.master.masterId.toString(),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.bottom + 15,
            ),
          ),
        ],
      ),
    );
  }
}
