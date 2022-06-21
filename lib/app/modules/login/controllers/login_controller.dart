import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_pattern/app/data/providers/exceptions.dart';
import 'package:getx_pattern/app/data/providers/login/login_api_provider.dart';
import 'package:getx_pattern/app/modules/login/model/login_model.dart';
import 'package:getx_pattern/core/values/utils/helpers.dart';
import 'package:getx_pattern/core/values/utils/keys.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  //TODO: Implement HomeController

  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  var isLoading = false.obs;
  final _getStorage = GetStorage();
  var loginModelData = LoginModel().obs;
  RxBool isGuestMode=false.obs;

  ///firebase auth
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;


    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future logout() async{
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
   // FirebaseAuth.instance.signOut();
  }


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}


  Future<void> sendLoginData(String? email, String? password) async {
    isLoading(true);

    try {
      loginModelData.value = await LoginApiProvider.fetchLoginModelApi(
          email: email, password: password);

      isLoading(false);
    } on DioError catch (e) {
      final errorMessage = Exceptions.DioExceptions(e).toString();
      AppMethods.GetxSnackBar(errorMessage);
      // showCustomDialog(ctx, 'Error', errorMessage);
      isLoading(false);
    }
  }

  void saveLoginToken(String? token) {
    _getStorage.write(Keys.GET_TOKEN_KEY, token);
  }


}
