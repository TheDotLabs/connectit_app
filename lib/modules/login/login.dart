import 'package:connectit_app/constants/images.dart';
import 'package:connectit_app/data/repo/user/google_login_repository.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/modules/base/base_state.dart';
import 'package:connectit_app/modules/login/widgets.dart';
import 'package:connectit_app/routes/routes.dart';
import 'package:connectit_app/utils/constants.dart';
import 'package:connectit_app/utils/dialog_utils.dart';
import 'package:connectit_app/utils/toast_utils.dart';
import 'package:connectit_app/utils/url_utils.dart';
import 'package:connectit_app/widgets/svg_icon.dart';
import 'package:connectivity/connectivity.dart';
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
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              child: Image.asset(
                Images.background,
                color: Colors.grey[400],
              ),
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    "India's Startup Community",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                SvgIcon(
                  assetName: Images.logo,
                  height: 70,
                  width: 70,
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  child: Text(
                    "Connect IT",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.blue[700],
                          fontSize: 20,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 44.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: LoginButton(
                    label: 'Login with Google',
                    onClick: () async {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult != ConnectivityResult.none) {
                        _login();
                      } else {
                        ToastUtils.show(
                          "Please check your internet connectivity!",
                        );
                      }
                    },
                    assetName: Images.GOOGLE_LOGO,
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                GestureDetector(
                  onTap: () {
                    UrlUtils.launchURL(Constants.privacyPolicy);
                  },
                  child: Text(
                    "By signing you agree to our terms and conditions",
                    style: Theme.of(context).textTheme.display1.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
              ],
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
