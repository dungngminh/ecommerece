import 'dart:io';

import 'package:ecommerce/screens/authen/login_screen.dart';
import 'package:ecommerce/screens/authen/widget/check_account_status.dart';
import 'package:ecommerce/screens/authen/widget/custom_divider.dart';
import 'package:ecommerce/screens/authen/widget/email_field.dart';
import 'package:ecommerce/screens/authen/widget/password_field.dart';
import 'package:ecommerce/screens/authen/widget/signup_background.dart';
import 'package:ecommerce/screens/authen/widget/social_linking.dart';
import 'package:ecommerce/services/firebase_authenticate.dart';
import 'package:ecommerce/utils/constant.dart';
import 'package:ecommerce/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SignUpBody extends StatefulWidget {
  @override
  _SignUpBodyState createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  String _emailInput = '';
  String _passwordInput = '';
  File? _pickedImage;
  int validatorType = 0;

  final _key = GlobalKey<FormState>();
  final AuthFirebase _auth = AuthFirebase();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size);
    return SignUpBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'signup'.toUpperCase(),
              style: GoogleFonts.openSans(
                color: kPrimaryColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: size.height * 0.005,
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 30,
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: kPrimaryColor,
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: kPrimaryLightColor,
                      backgroundImage: _pickedImage == null
                          ? null
                          : FileImage(_pickedImage!),
                    ),
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: 15,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      splashRadius: 29,
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 30,
                        color: kPrimaryLightColor,
                      ),
                      onPressed: () => _optionImage(context),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  EmailField(
                    isSignUp: true,
                    validatorType: validatorType,
                    hintText: 'Your Email',
                    icon: Icons.person,
                    onChanged: (String value) {
                      setState(() {
                        _emailInput = value;
                      });
                    },
                  ),
                  PasswordField(
                    isSignUp: true,
                    nextAction: TextInputAction.next,
                    onChanged: (String value) {
                      setState(() {
                        _passwordInput = value;
                      });
                    },
                  ),
                  PasswordField(
                    isSignUp: true,
                    onCompleted: _submit,
                    password: _passwordInput,
                    isRepeat: true,
                    onChanged: (String value) {},
                  ),
                ],
              ),
            ),
            ButtonWidget(text: 'SIGN IN', onPressed: _submit),
            SizedBox(
              height: size.height * 0.015,
            ),
            CheckHavingAccountStatus(
              function: () => Navigator.pushNamed(
                context,
                LoginScreen.routeName,
              ),
              type: false,
            ),
            CustomDividerWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialLinkingAccount(
                  assetName: 'assets/icons/google.svg',
                  onPressed: () {},
                ),
                SocialLinkingAccount(
                  assetName: 'assets/icons/facebook.svg',
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      _auth
          .signUpWithEmailAndPassword(_emailInput, _passwordInput)
          .then((value) => validatorType = value);
    } else
      print('fail');
  }

  void _optionImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Choose option',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  onTap: _imageFromCamera,
                  leading: Icon(
                    Icons.camera,
                    color: kPrimaryColor,
                  ),
                  title: Text(
                    'Camera',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                ),
                ListTile(
                  onTap: _imageFromGallery,
                  leading: Icon(
                    Icons.collections,
                    color: kPrimaryColor,
                  ),
                  title: Text(
                    'Gallery',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                    ),
                  ),
                ),
                if (_pickedImage != null)
                  ListTile(
                    onTap: _removeImage,
                    leading: Icon(
                      Icons.delete,
                      color: kPrimaryColor,
                    ),
                    title: Text(
                      'Remove',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _imageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        _pickedImage = pickedImageFile;
      });
    }
    Navigator.pop(context);
  }

  void _imageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        _pickedImage = pickedImageFile;
      });
    }
    Navigator.pop(context);
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
    Navigator.pop(context);
  }
}
