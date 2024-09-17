import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ramaniride/widgets/location_disclosure_dialog.dart';

import '../constants/colors.dart';
import '../models/user_model.dart';
import '../pages/webview_page.dart';
import '../services/auth_service.dart';

enum EmailSignInFormType { signIn, register }

class LoginMobileLayout extends ConsumerStatefulWidget {
  LoginMobileLayout({required this.currentScaffold, super.key});
  GlobalKey<ScaffoldState> currentScaffold;

  @override
  ConsumerState<LoginMobileLayout> createState() => _LoginMobileLayoutState();
}

class _LoginMobileLayoutState extends ConsumerState<LoginMobileLayout> {
  final _auth = AuthService();
  EmailSignInFormType _formType = EmailSignInFormType.register;
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  late TapGestureRecognizer _onTapRecognizer;
  // late GoogleMapController mapController;
  // late String _mapStyle;

  @override
  void initState() {
    super.initState();
    _onTapRecognizer = TapGestureRecognizer()..onTap = _handlePress;
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   rootBundle.loadString('assets/style/map_style_dark.txt').then((string) {
    //     _mapStyle = string;
    //   });
    //  });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.currentScaffold.currentState!.showBodyScrim(true, 0.6);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          widget.currentScaffold.currentState!.showBodyScrim(true, 0.6);
          return const LocationDisclosureDialog();
        },
      );
    });
  }

  @override
  void dispose() {
    _onTapRecognizer.dispose();
    super.dispose();
  }
  // final LatLng _center =
  //     const LatLng(-1.2921, 36.8219); // const LatLng(-33.86, 151.20);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  //   mapController.setMapStyle(_mapStyle);
  // }

  void _toogleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    final form = _formKey.currentState!;
    form.reset();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      form.reset();
      return true;
    }
    return false;
  }

  Future<UserModel?> _logInEmail() async {
    try {
      if ((_formType == EmailSignInFormType.signIn) &&
          (_validateAndSaveForm())) {
        final user = await _logIn();
        debugPrint('log in');
        return user;
      } else if (_validateAndSaveForm()) {
        final user = await _register();
        debugPrint('register');
        return user;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<UserModel> _register() async {
    final user =
        await _auth.createUserWithEmailAndPassword(_email!, _password!);
    return user!;
  }

  Future<UserModel> _logIn() async {
    final user = await _auth.signInWithEmailAndPassword(_email!, _password!);
    return user!;
  }

  Future<UserModel> _loginGoogle() async {
    final user = await _auth.signInWithGoogle();
    return user!;
  }

  @override
  Widget build(BuildContext context) {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Log in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Log in';
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      //height: 600,
      width: size.width - 40,
      child: Center(
        child: Container(
          // width: size.width / 3,
          height: (size.height / 4 * 3) + 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: kblack00005,
              width: 1,
            ),
          ),

          padding: const EdgeInsets.all(5),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                'RamaniRide',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: kblue9813424010,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Ready to go',
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    height: 1.56,
                    color: kblackgrey79797907,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                onPressed: () async {
                  // await _loginGoogle();
                  await _auth.signInAnonymously();
                },
                style: OutlinedButton.styleFrom(
                  fixedSize: const Size(248, 45),
                  side: const BorderSide(
                    width: 2,
                    color: kblackgrey79797910,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedAnonymous,
                      color: kblack00008,
                      size: 24.0,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Sign in anonymously",
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          height: 1.56,
                          color: kblackgrey79797910,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 99,
                    height: 2,
                    child: Divider(
                      height: 1,
                      color: kblackgrey79797903,
                    ),
                  ),
                  const SizedBox(
                    width: 17,
                  ),
                  Text(
                    'or',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: kblackgrey79797910,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 17,
                  ),
                  const SizedBox(
                    width: 99,
                    height: 2,
                    child: Divider(
                      height: 1,
                      color: kblackgrey79797903,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 248,
                child: _buildForm(),
              ),
              const SizedBox(
                height: 15,
              ),
              MaterialButton(
                onPressed: () async {
                  await _logInEmail();
                },
                color: kblue9813424010,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                height: 55,
                minWidth: 248,
                child: Text(
                  primaryText,
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      color: kwhite25525525510,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () async {
                  _toogleFormType();
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(248, 55),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  foregroundColor: kblue9813424010,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  side: const BorderSide(
                    color: kblue9813424010,
                    width: 2,
                  ),
                ),
                child: Text(
                  secondaryText,
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      color: kblue9813424010,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(
                  text: 'By tapping "log in" you accept our ',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: kblack00005,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'privacy policy',
                      recognizer: _onTapRecognizer,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: kblue12915824210,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    /*
                      TextSpan(
                        text: '\nand',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: kblackgrey48484810,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: ' conditions ',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: kpurple1215720310,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      */
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePress() {
    HapticFeedback.vibrate();
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => const WebViewApp(
          uri:
              'https://www.termsfeed.com/live/9d18bc24-93ed-44b4-8296-6d6bff1a71f2',
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      Text(
        'Email',
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            color: kblackgrey48484810,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Email';
          }
          return null;
        },
        initialValue: '',
        onSaved: (value) => _email = value!.trim(),
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
            color: kblackgrey62606310,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedMail01,
            color: kblack00008,
            size: 24.0,
          ),
          fillColor: kwhite25525525510,
          label: Text(
            ' Email ',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: kblackgrey62606310,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          filled: true,
          hintText: '',
          labelStyle: const TextStyle(
            color: kblackgrey62606310,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusColor: const Color.fromRGBO(243, 242, 242, 1),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintStyle: GoogleFonts.dmSans(
            textStyle: const TextStyle(
              color: kblackgrey62606310,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        maxLines: 1,
        textAlign: TextAlign.start,
      ),
      const SizedBox(
        height: 15,
      ),
      Text(
        'Password',
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            color: kblackgrey48484810,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Password';
          }
          return null;
        },
        initialValue: '',
        onSaved: (value) => _password = value!.trim(),
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
            color: kblackgrey62606310,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        decoration: InputDecoration(
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedLockPassword,
            color: kblack00008,
            size: 24.0,
          ),
          fillColor: kwhite25525525510,
          filled: true,
          label: Text(
            ' Password ',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: kblackgrey62606310,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          hintText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusColor: const Color.fromRGBO(243, 242, 242, 1),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintStyle: GoogleFonts.dmSans(
            textStyle: const TextStyle(
              color: kblackgrey62606310,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        maxLines: 1,
        textAlign: TextAlign.start,
      ),
    ];
  }
}
