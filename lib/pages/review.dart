import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/shimmer.dart';
import 'package:look_app/widgets/snack_bar.dart';
import 'package:look_app/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({
    required this.masterId,
    required this.userUid,
  });

  final String masterId;
  final String userUid;

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final commentController = TextEditingController();

  late Review review;
  var loading = false;
  var saving = false;

  void loadingReview() {
    setState(() {
      loading = true;
    });
    NetHandler.getReview(widget.masterId, widget.userUid).then((value) {
      review = value ?? Review(stars: 5);
      commentController.text = review.message ?? "";
      setState(() {
        loading = false;
      });
    });
  }

  Widget getCell(int index) {
    return Expanded(
      flex: 2,
      child: Material(
        elevation: index == review.stars ? 1 : 0,
        borderRadius: Constants.radius,
        color: index == review.stars ? Colors.white : Colors.grey[100],
        child: InkWell(
          borderRadius: Constants.radius,
          child: Center(
            child: Text(
              index.toString(),
              style: TextStyle(fontSize: 16),
            ),
          ),
          onTap: () => setState(() {
            review.stars = index.toDouble();
          }),
        ),
      ),
    );
  }

  void saveReview() async {
    setState(() {
      saving = true;
    });
    NetHandler.saveReview(
      widget.masterId,
      widget.userUid,
      commentController.text,
      review.stars.toString(),
    ).then((value) {
      StandartSnackBar.show(
        context,
        value ?? "",
        SnackBarStatus.warning(),
      );
      setState(() {
        saving = false;
      });
    });
  }

  Widget getButton() {
    if (saving) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: CupertinoActivityIndicator(),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 40),
        child: StandartButton(
          label: 'Сохранить',
          onTap: saveReview,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadingReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            StandartAppBar(
              title: Text(
                "Оставить отзыв",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                child: GroupLabel(
                  label: 'Комментарий',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: loading
                  ? Container(
                      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: Shimmer(
                        height: 140,
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                      height: 140,
                      child: TextFieldWidget(
                        controller: commentController,
                        maxLines: 8,
                      ),
                    ),
            ),
            SliverToBoxAdapter(
              child: Container(
                child: GroupLabel(
                  label: 'Оценка',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: loading
                  ? Container(
                      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: Shimmer(
                        height: 50,
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: Constants.radius,
                        ),
                        child: Row(
                          children: [
                            getCell(1),
                            SizedBox(width: 3),
                            getCell(2),
                            SizedBox(width: 3),
                            getCell(3),
                            SizedBox(width: 3),
                            getCell(4),
                            SizedBox(width: 3),
                            getCell(5),
                          ],
                        ),
                      ),
                    ),
            ),
            SliverToBoxAdapter(
              child: loading ? Container() : getButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        StandartAppBar(
          title: Text(
            "Оставить отзыв",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Shimmer(
                width: 150,
                height: 20,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Shimmer(
              height: 140,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Shimmer(
                width: 80,
                height: 20,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Shimmer(
              height: 50,
            ),
          ),
        ),
      ],
    );
  }
}
