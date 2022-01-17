import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:look_app/pages/user.dart';
import 'package:look_app/services/auth.dart';
import 'package:look_app/services/formater.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/logo.dart';
import 'package:look_app/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserAuthPage extends StatefulWidget {
  UserAuthPage({
    this.afterClose = false,
  });

  final bool afterClose;

  @override
  _UserAuthPageState createState() => _UserAuthPageState();
}

class _UserAuthPageState extends State<UserAuthPage>
    with TickerProviderStateMixin {
  final _phoneTextController = TextEditingController();
  final _smsCodeTextController = TextEditingController();
  final _authService = AuthService();

  bool _requested = false;
  bool _loading = false;

  void _pressAuth() async {
    var request = await _authService.requestCode(
      context,
      _phoneTextController.text,
    );

    setState(() {
      _requested = request;
    });
  }

  void _pressConfirm() async {
    setState(() {
      _loading = true;
    });

    var result = await _authService.confirmCode(
      context,
      _smsCodeTextController.text,
    );

    if (result && widget.afterClose) {
      Navigator.pop(context);
    }

    setState(() {
      _loading = false;
    });
  }

  Widget _authButton() {
    return StandartButton(
      label: 'Авторизация',
      onTap: _pressAuth,
    );
  }

  Widget _confirmButton() {
    if (_loading) {
      return CupertinoActivityIndicator();
    } else {
      return StandartButton(
        label: 'Подтвердить',
        onTap: _pressConfirm,
      );
    }
  }

  Widget _phoneField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFieldWidget(
        hint: "Номер телефона",
        icon: Icons.phone,
        type: TextInputType.phone,
        controller: _phoneTextController,
        formatter: [
          MaskTextInputFormatter("+_ (___) ___-__-__"),
          LengthLimitingTextInputFormatter(18),
        ],
        maxLength: 18,
        onTap: () {
          if (_phoneTextController.text.length < 4) {
            _phoneTextController.text = "+7 (";
          }
        },
      ),
    );
  }

  Widget _codeField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFieldWidget(
        hint: "Код из SMS",
        icon: Icons.chat,
        type: TextInputType.number,
        controller: _smsCodeTextController,
        formatter: [
          LengthLimitingTextInputFormatter(6),
        ],
      ),
    );
  }

  Widget _personalDescriprion() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "Используя приложение, Вы даёте согласие на обработку персональных данных.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _codeDescriprion() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "Код авторизации будет отправлен в SMS.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
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
                "Авторизация",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () => MainRouter.openBottomSheet(
                    context: context,
                    child: Documents(),
                    height: 400,
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 30,
              ),
            ),
            SliverToBoxAdapter(
              child: LookLogo(
                height: 55,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 30,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Для связи с мастером и записи на услуги, а также просмотра истории и получения уведомлений необходимо авторизоваться в приложении.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 30,
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedSizeAndFade(
                child: !_requested ? _phoneField() : _codeField(),
                fadeDuration: const Duration(milliseconds: 300),
                sizeDuration: const Duration(milliseconds: 600),
                vsync: this,
              ),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(
                height: 30,
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedSizeAndFade(
                child:
                    !_requested ? _personalDescriprion() : _codeDescriprion(),
                fadeDuration: const Duration(milliseconds: 300),
                sizeDuration: const Duration(milliseconds: 600),
                vsync: this,
              ),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(
                height: 30,
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedSizeAndFade(
                child: !_requested ? _authButton() : _confirmButton(),
                fadeDuration: const Duration(milliseconds: 300),
                sizeDuration: const Duration(milliseconds: 600),
                vsync: this,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
