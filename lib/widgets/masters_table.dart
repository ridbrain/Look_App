import 'package:look_app/pages/master.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/extensions.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/widgets/master_cardview.dart';
import 'package:flutter/material.dart';

class MastersTable extends StatefulWidget {
  MastersTable({
    required this.masters,
    required this.update,
  });

  final List<Master> masters;
  final Function() update;

  @override
  _MastersTableState createState() => _MastersTableState();
}

class _MastersTableState extends State<MastersTable> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return MasterCardView(
            name: widget.masters[index].name,
            photo: widget.masters[index].imageUrl,
            experience: widget.masters[index].experience.getExperience(),
            reviews: widget.masters[index].reviews.getReviews(),
            rating: widget.masters[index].rating,
            metro: widget.masters[index].metro,
            last: (widget.masters.length - 1) == index,
            onTap: () {
              MainRouter.nextPage(
                context,
                MasterPage(
                  master: widget.masters[index],
                ),
              ).then(
                (value) => widget.update(),
              );
            },
          );
        },
        childCount: widget.masters.length,
      ),
    );
  }
}

class LoadingMastersTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (contetx, index) {
          return LoadingMasterCard();
        },
      ),
    );
  }
}
