import 'package:connectit_app/constants/images.dart';
import 'package:connectit_app/data/repo/user/google_login_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/modules/base/base_state.dart';
import 'package:connectit_app/modules/login/widgets.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:connectit_app/utils/dialog_utils.dart';
import 'package:connectit_app/utils/toast_utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen> {
  final _googleLoginRepository = injector<GoogleLoginRepository>();

  Future<void> _login() async {
    try {
      DialogUtils.showProgressBar(context);
      final result = await _googleLoginRepository.login();
      result.when(
        (value) {
          DialogUtils.hideProgressBar(context);
          _onLoginSuccess();
        },
        loading: () {},
        error: (message) {
          DialogUtils.hideProgressBar(context);
          ToastUtils.show(message);
        },
      );
    } catch (e) {
      DialogUtils.hideProgressBar(context);
      ToastUtils.show(e?.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                "Connect IT- demo",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            const SizedBox(
              height: 56.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LoginButton(
                label: 'Login with Google',
                onClick: () => _login(),
                assetName: Images.GOOGLE_LOGO,
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _onLoginSuccess() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => !route.isFirst,
    );
  }
}
