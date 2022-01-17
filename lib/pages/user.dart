import 'package:look_app/pages/pdf.dart';
import 'package:look_app/services/auth.dart';
import 'package:look_app/services/formater.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/services/services.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/column_card.dart';
import 'package:look_app/widgets/logo.dart';
import 'package:look_app/widgets/snack_bar.dart';
import 'package:look_app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String version = "Версия";

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        version = "Версия ${value.version}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;

    return CustomScrollView(
      slivers: [
        StandartAppBar(
          title: Text(
            "Аккаунт",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(LineIcons.alternateSignOut),
              onPressed: () => AuthService().signOut(context),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: ColumnCard(
            label: user.name,
            description: MaskTextInputFormatter(
              "+_ (___) ___-__-__",
            ).getMaskedText(
              user.phone.toString(),
            ),
            icon: Icons.edit,
            onTap: () => MainRouter.fullScreenDialog(
              context,
              EditName(
                userUid: user.uid,
                name: user.name,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ColumnCard(
            label: "Поддержка",
            description: "Мы отвечаем",
            icon: Icons.phone,
            onTap: () => MainRouter.openBottomSheet(
              context: context,
              child: Support(),
              height: 400,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ColumnCard(
            label: "Документы",
            description: "Все права защищены",
            icon: Icons.file_copy,
            onTap: () => MainRouter.openBottomSheet(
              context: context,
              child: Documents(),
              height: 400,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ColumnCard(
            label: "О приложении",
            description: version,
            icon: Icons.info,
            onTap: () => MainRouter.openBottomSheet(
              context: context,
              child: AppInfo(
                version: version,
              ),
              height: 300,
            ),
          ),
        ),
      ],
    );
  }
}

class AppInfo extends StatelessWidget {
  AppInfo({
    required this.version,
  });

  final String version;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LookLogo(height: 60),
          Container(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              "Разработчик Виталий Яковлев",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Text(
              version,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Documents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 15,
          ),
        ),
        SliverToBoxAdapter(
          child: LinkCard(
            label: "Персональные данные",
            icon: Icons.shield,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFPages(
                  title: "Документ",
                  pdfUrl: "https://server.looklike.beauty/docs/agree.pdf",
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: LinkCard(
            label: "Правила использования",
            icon: Icons.check_box,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFPages(
                  title: "Документ",
                  pdfUrl: "https://server.looklike.beauty/docs/rules.pdf",
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: LinkCard(
            label: "Конфиденциальность",
            icon: Icons.safety_divider,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFPages(
                  title: "Документ",
                  pdfUrl: "https://server.looklike.beauty/docs/conf.pdf",
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: LinkCard(
            label: "Соглашение",
            icon: Icons.person,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFPages(
                  title: "Документ",
                  pdfUrl: "https://server.looklike.beauty/docs/users.pdf",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Support extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Выберите удобный способ связи",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundButton(
                icon: LineIcons.mailBulk,
                label: "E-Mail",
                onTap: () async {
                  await launch("mailto:support@looklike.beauty");
                },
              ),
              RoundButton(
                icon: LineIcons.telegram,
                label: "Telegram",
                onTap: () async {
                  await launch("tg://resolve?domain=ridbrain");
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EditName extends StatefulWidget {
  EditName({
    required this.userUid,
    required this.name,
    this.hide = true,
  });

  final String userUid;
  final String name;
  final bool hide;

  @override
  _EditNameState createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  var controller = TextEditingController();

  void saveName() {
    if (controller.text.isEmpty) {
      StandartSnackBar.show(
        context,
        "Поле не может быть пустым",
        SnackBarStatus.warning(),
      );
      return;
    }
    NetHandler.editUserName(widget.userUid, controller.text).then((value) {
      if (value == null) {
        StandartSnackBar.show(
          context,
          "Ошибка",
          SnackBarStatus.warning(),
        );
      } else {
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUserName(value);
        StandartSnackBar.show(
          context,
          "Имя сохранено",
          SnackBarStatus.success(),
        );
      }
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    controller.text = widget.name;
    super.initState();
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
              title: Text('Укажите Ваше имя'),
              automaticallyImplyLeading: widget.hide,
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFieldWidget(
                  icon: Icons.person,
                  hint: "Ваше имя",
                  controller: controller,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 30,
              ),
            ),
            SliverToBoxAdapter(
              child: StandartButton(
                label: "Сохранить",
                onTap: saveName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
