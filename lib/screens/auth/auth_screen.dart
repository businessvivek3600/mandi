import 'package:coinxfiat/utils/utils_index.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constants/constants_index.dart';
import '../../routes/route_index.dart';
import '../../services/service_index.dart';
import '../../store/store_index.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key, required this.returnExpected, this.returnPath})
      : super(key: key);
  final bool returnExpected;
  final String? returnPath;
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _pageController = PageController();

  bool _isLogin = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _togglePage() {
    _pageController.animateToPage(
      _isLogin ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
    setState(() => _isLogin = !_isLogin);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: assetImages('app/auth-bg2.jpg').image,
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(20),

            height: size.height,
            width: size.width,
            // constraints: const BoxConstraints(maxWidth: 500),
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                LoginScreen(
                    returnPath: widget.returnPath, onTogglePage: _togglePage),
                RegisterScreen(
                    returnPath: widget.returnPath, onTogglePage: _togglePage),
              ],
            ),
          ),
        ).onTap(() => hideKeyboard(context), splashColor: Colors.transparent),
      ),
    );
  }
}

///login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.returnPath, this.onTogglePage});
  final String? returnPath;
  final VoidCallback? onTogglePage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  bool obscureText = true;

  setObscureText() => setState(() => obscureText = !obscureText);

  ///login
  void _login() {
    hideKeyboard(context);
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    _loginFormKey.currentState!.save();
    setState(() => _isLoading = true);
    AuthService()
        .login(_phoneController.text, _passwordController.text)
        .then((value) {
      setState(() => _isLoading = false);
      if (appStore.isLoggedIn) {
        context.goNamed(Routes.dashboard);
      }
      if (widget.returnPath.validate().isNotEmpty) {
        goRouter.push(widget.returnPath!);
      }
    });
    // GoRouter.of(context).goNamed(HomeScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Form(
      key: _loginFormKey,
      child: AnimatedScrollView(
        padding: const EdgeInsets.all(20),
        children: [
          assetImages(MyPng.logoLBlack),

          ///login text
          Text(
            'Login',
            style: theme.textTheme.displaySmall!
                .copyWith(color: theme.primaryColor),
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: _phoneController,
            // focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: _buildInputDecoration(
              theme,
              'Mobile or Username',
              Icons.email_outlined,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter mobile or username';
              }

              return null;
            },
            // onFieldSubmitted: (_) {
            // FocusScope.of(context).requestFocus(_passwordFocusNode);
            // },
          ),
          const SizedBox(height: 20),
          TextFormField(

              ///password
              controller: _passwordController,
              // focusNode: _passwordFocusNode,
              obscureText: obscureText,
              textInputAction: TextInputAction.done,
              decoration: _buildInputDecoration(
                theme,
                'Password',
                Icons.lock_outline,
                suffix: IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: theme.primaryColor,
                  ),
                  onPressed: setObscureText,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              onFieldSubmitted: (_) => _login()),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _login,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                      .center()
                  : Text(
                      'Login',
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Forgot Password? ',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: Colors.blueAccent,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => context.goNamed(Routes.dashboard),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: theme.textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: 'Register',
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onTogglePage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// create seperate register screen  stateful and copy the above

///register screen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.returnPath, this.onTogglePage});
  final String? returnPath;
  final VoidCallback? onTogglePage;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _phoneCodeController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _isLoading = false;
  final countryPicker = const FlCountryCodePicker();
  CountryCode? countryCode;
  static RegExp passwordRegExp =
      RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{6,}$');

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (!passwordRegExp.hasMatch(value)) {
      return 'Password must be at least 6 characters long and include at least one uppercase letter, one lowercase letter, one digit, and one symbol.';
    }
    return null;
  }

  ///register
  void _register() {
    hideKeyboard(context);
    if (!_registerFormKey.currentState!.validate()) {
      return;
    }
    _registerFormKey.currentState!.save();
    setState(() => _isLoading = true);
    AuthService()
        .register(
      // firstName: _firstNameController.text,
      // lastName: _lastNameController.text,
      // userName: _usernameController.text,
      // email: _emailController.text,
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
      phoneCode: _phoneCodeController.text.trim(),
    )
        .then((value) {
      setState(() => _isLoading = false);
      if (appStore.isLoggedIn) {
        context.goNamed(Routes.dashboard);
      }
      if (widget.returnPath.validate().isNotEmpty) {
        goRouter.push(widget.returnPath!);
      }
    });
    // GoRouter.of(context).goNamed(HomeScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _phoneCodeController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Form(
      key: _registerFormKey,
      child: AnimatedScrollView(
        padding: const EdgeInsets.all(DEFAULT_PADDING / 2),
        children: [
          assetImages(MyPng.logoLBlack),

          ///register text
          Text(
            'Register',
            style: theme.textTheme.displaySmall!
                .copyWith(color: theme.primaryColor),
          ),
          const SizedBox(height: 20),
          /*
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  // focusNode: _firstNameFocusNode,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: _buildInputDecoration(
                    theme,
                    'First Name',
                    Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                  // onFieldSubmitted: (_) {
                  // FocusScope.of(context).requestFocus(_lastNameFocusNode);
                  // },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  // focusNode: _lastNameFocusNode,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: _buildInputDecoration(
                    theme,
                    'Last Name',
                    Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                  // onFieldSubmitted: (_) {
                  // FocusScope.of(context).requestFocus(_emailFocusNode);
                  // },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ///username
          TextFormField(
            controller: _usernameController,
            // focusNode: _emailFocusNode,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration:
                _buildInputDecoration(theme, 'Username', Icons.person_outline),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            // focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: _buildInputDecoration(
              theme,
              'Email',
              Icons.email_outlined,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter email';
              }
              if (!value.contains('@')) {
                return 'Please enter valid email';
              }
              return null;
            },
            // onFieldSubmitted: (_) {
            // FocusScope.of(context).requestFocus(_phoneFocusNode);
            // },
          ),
          const SizedBox(height: 20),
          */
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///phone code
              Container(
                constraints: const BoxConstraints(maxWidth: 100),
                child: TextFormField(
                  controller: _phoneCodeController,
                  readOnly: true,
                  onTap: () async {
                    final picked = await countryPicker.showPicker(
                      context: context,
                    );
                    // Null check
                    if (picked != null) {
                      setState(() {
                        countryCode = picked;
                        _phoneCodeController.text = countryCode!.dialCode;
                      });
                    }
                    print(countryCode?.flagImage());
                  },
                  // focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: _buildInputDecoration(
                    theme,
                    '',
                    (countryCode != null)
                        ? countryCode!.flagImage(width: 10)
                        : Icons.flag_circle_rounded,
                    hint: countryCode?.dialCode ?? 'e.g +234',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return '* required';
                    return null;
                  },
                  // onFieldSubmitted: (_) {
                  // FocusScope.of(context).requestFocus(_phoneFocusNode);
                  // },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  // focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: _buildInputDecoration(
                      theme, 'Phone', Icons.phone_outlined),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                  // onFieldSubmitted: (_) {
                  // FocusScope.of(context).requestFocus(_passwordFocusNode);
                  // },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            // focusNode: _passwordFocusNode,
            // obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            decoration: _buildInputDecoration(
              theme,
              'Password',
              Icons.lock_outline,
              errorMaxLines: 3,
            ),
            validator: validatePassword,
            // onFieldSubmitted: (_) {
            // FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
            // },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _confirmPasswordController,
            // focusNode: _confirmPasswordFocusNode,
            // obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: _buildInputDecoration(
              theme,
              'Confirm Password',
              Icons.lock_outline,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter confirm password';
              }
              if (value != _passwordController.text) {
                return 'Password does not match';
              }
              return null;
            },
            onFieldSubmitted: (_) => _register(),
          ),

          const SizedBox(height: 20),

          ///register button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _register,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                      .center()
                  : Text(
                      'Register',
                      style: theme.textTheme.titleLarge!
                          .copyWith(color: Colors.white),
                    ),
            ),
          ),

          /// rich text for already have account and toogle page to login page .
          const SizedBox(height: 20),

          ///toolge page to login page
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: theme.textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: 'Login',
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onTogglePage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

InputDecoration _buildInputDecoration(
  ThemeData theme,
  String label,
  dynamic icon, {
  String? hint,
  Widget? suffix,
  int errorMaxLines = 1,
}) {
  return InputDecoration(
    // label: Text(label,
    //     style:
    //         theme.textTheme.bodyLarge!.copyWith(color: theme.primaryColor)),
    // labelText: label,
    hintText: hint ?? label,

    hintStyle: theme.textTheme.bodyLarge!.copyWith(color: Colors.grey),
    prefixIcon: icon is IconData
        ? Icon(icon, color: theme.primaryColor)
        : icon is Widget
            ? icon.cornerRadiusWithClipRRect(2).paddingAll(10)
            : null,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    errorStyle:
        theme.textTheme.bodySmall!.copyWith(color: Colors.red, fontSize: 10),
    errorMaxLines: errorMaxLines,
    suffixIcon: suffix,
  );
}

class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({super.key, required Animation<double> animation})
      : super(listenable: animation);

  // Make the Tweens static because they don't change.
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 300);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: _sizeTween.evaluate(animation),
          width: _sizeTween.evaluate(animation),
          child: const FlutterLogo(),
        ),
      ),
    );
  }
}

class LogoApp extends StatefulWidget {
  const LogoApp({super.key});

  @override
  State<LogoApp> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedLogo(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
