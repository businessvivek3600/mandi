import 'package:coinxfiat/services/auth_services.dart';
import 'package:coinxfiat/store/store_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constants/constants_index.dart';
import '../../utils/utils_index.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _key = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneCodeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final ValueNotifier<bool> _submittingForm = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      _firstNameController.text = appStore.userFirstName;
      _lastNameController.text = appStore.userLastName;
      _usernameController.text = appStore.userName;
      _phoneCodeController.text = appStore.phoneCode;
      _phoneNumberController.text =
          '${appStore.currencyCode} ${appStore.userContactNumber}';
      _emailController.text = appStore.userEmail;
      _addressController.text = appStore.address;
    });
  }

  _submit() async {
    FocusScope.of(context).unfocus();
    _submittingForm.value = true;

    if (!_key.currentState!.validate()) {
      setState(() {});
      _submittingForm.value = false;
      return;
    }
    setState(() => _key.currentState!.save());
    var data = {
      'firstname': _firstNameController.text,
      'lastname': _lastNameController.text,
      'phone_code': _phoneCodeController.text,
      'phone': _phoneNumberController.text,
      'email': _emailController.text,
      'address': _addressController.text,
    };

    const successSnackBar = SnackBar(
        content: Text('Profile update successfully! 🎉'),
        backgroundColor: Colors.green);
    await AuthService().updateProfile(data).then((value) {
      FocusScope.of(context)
        ..nextFocus()
        ..unfocus();
      if (value) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(successSnackBar);
      }
    });
    _submittingForm.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _submittingForm,
        builder: (context, submitting, _) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Profile'),
                centerTitle: true,
                elevation: 0,
                actions: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: submitting
                        ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CupertinoActivityIndicator())
                            .paddingRight(DEFAULT_PADDING)
                        : IconButton(
                            onPressed: _submit, icon: const Icon(Icons.check)),
                  ),
                ],
              ),
              body: Form(
                key: _key,
                child: ListView(
                  padding: const EdgeInsets.all(DEFAULT_PADDING),
                  children: [
                    /// edit profile form with all the fields, first name, last name, username, email, phone number with +91 , preferred language dropdown, address textarea
                    /// First Name
                    _textField(
                      context,
                      controller: _firstNameController,
                      title: 'First Name',
                      helperText:
                          'Only alphabets are allowed. No special characters',
                      readOnly: false,
                      prefixIcon: FontAwesomeIcons.user,
                      validator: (value) => value?.isEmpty == true
                          ? 'Please enter your first name'
                          : null,
                    ),

                    /// Last Name
                    _textField(
                      context,
                      controller: _lastNameController,
                      title: 'Last Name',
                      helperText:
                          'Only alphabets are allowed. No special characters',
                      readOnly: false,
                      prefixIcon: FontAwesomeIcons.user,
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///phone code
                        Container(
                          constraints: const BoxConstraints(maxWidth: 100),
                          child: _textField(
                            context,
                            controller: _phoneCodeController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            title: 'Phone Code',
                            hintText: '+91',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '* required';
                              }
                              return null;
                            },
                            prefixIcon: Icons.pin,
                            readOnly: false,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _textField(
                            context,
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            title: 'Phone Number',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '* required';
                              }
                              return null;
                            },
                            prefixIcon: Icons.phone,
                            readOnly: false,
                          ),
                        ),
                      ],
                    ),

                    /// Email Address
                    _textField(
                      context,
                      controller: _emailController,
                      title: 'Email Address',
                      helperText: 'A valid email e.g. user@gmail.com',
                      readOnly: false,
                      prefixIcon: FontAwesomeIcons.envelope,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value?.isEmpty == true
                          ? 'Please enter your email'
                          : null,
                    ),

                    /// Address
                    _textField(
                      context,
                      controller: _addressController,
                      title: 'Address',
                      helperText: 'Enter your address',
                      readOnly: false,
                      prefixIcon: FontAwesomeIcons.locationDot,
                      keyboardType: TextInputType.streetAddress,
                      validator: (value) => value?.isEmpty == true
                          ? 'Please enter your address'
                          : null,
                    ),
                  ],
                ),
              ));
        });
  }

  Widget _textField(
    BuildContext context, {
    required TextEditingController controller,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    required String title,
    String? hintText,
    String? helperText,
    required bool readOnly,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    List<TextInputFormatter> inputFormatters = const [],
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: boldTextStyle()),
        height5(),
        Container(
          margin: const EdgeInsets.only(bottom: DEFAULT_PADDING),
          child: TextFormField(
            controller: controller,
            readOnly: readOnly,
            textInputAction: textInputAction ?? TextInputAction.next,
            keyboardType: keyboardType ?? TextInputType.text,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: readOnly ? Colors.grey.shade200 : Colors.white,
              prefixIcon: FaIcon(prefixIcon).paddingAll(DEFAULT_PADDING),
              hintText: hintText ?? title,
              helperText: helperText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
/*
class MyForm extends StatefulWidget {
  MyForm({super.key, Random? seed}) : seed = seed ?? Random();

  final Random seed;

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _key = GlobalKey<FormState>();
  late MyFormState _state;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _phoneNumberController;

  void _onFirstNameChanged() {
    setState(() {
      _state = _state.copyWith(
        firstName: FirstName.dirty(_firstNameController.text),
      );
    });
  }

  void _onLastNameChanged() {
    setState(() {
      _state = _state.copyWith(
        lastName: LastName.dirty(_lastNameController.text),
      );
    });
  }

  void _onUsernameChanged() {
    setState(() {
      _state = _state.copyWith(
        username: Username.dirty(_usernameController.text),
      );
    });
  }

  void _onPhoneNumberChanged() {
    setState(() {
      _state = _state.copyWith(
        phoneNumber: PhoneNumber.dirty(_phoneNumberController.text),
      );
    });
  }

  void _onEmailChanged() {
    setState(() {
      _state = _state.copyWith(email: Email.dirty(_emailController.text));
    });
  }

  void _onPasswordChanged() {
    setState(() {
      _state = _state.copyWith(
        password: Password.dirty(_passwordController.text),
      );
    });
  }

  Future<void> _onSubmit() async {
    if (!_key.currentState!.validate()) return;

    setState(() {
      _state = _state.copyWith(status: FormzSubmissionStatus.inProgress);
    });

    try {
      await _submitForm();
      _state = _state.copyWith(status: FormzSubmissionStatus.success);
    } catch (_) {
      _state = _state.copyWith(status: FormzSubmissionStatus.failure);
    }

    if (!mounted) return;

    setState(() {});

    FocusScope.of(context)
      ..nextFocus()
      ..unfocus();

    const successSnackBar = SnackBar(
      content: Text('Submitted successfully! 🎉'),
    );
    const failureSnackBar = SnackBar(
      content: Text('Something went wrong... 🚨'),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        _state.status.isSuccess ? successSnackBar : failureSnackBar,
      );

    if (_state.status.isSuccess) _resetForm();
  }

  Future<void> _submitForm() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    if (widget.seed.nextInt(2) == 0) throw Exception();
  }

  void _resetForm() {
    _key.currentState!.reset();
    _emailController.clear();
    _passwordController.clear();
    setState(() => _state = MyFormState());
  }

  @override
  void initState() {
    super.initState();
    _state = MyFormState();
    _emailController = TextEditingController(text: _state.email.value)
      ..addListener(_onEmailChanged);
    _passwordController = TextEditingController(text: _state.password.value)
      ..addListener(_onPasswordChanged);
    _firstNameController = TextEditingController(text: _state.firstName.value)
      ..addListener(_onFirstNameChanged);
    _lastNameController = TextEditingController(text: _state.lastName.value)
      ..addListener(_onLastNameChanged);
    _usernameController = TextEditingController(text: _state.username.value)
      ..addListener(_onUsernameChanged);
    _phoneNumberController =
        TextEditingController(text: _state.phoneNumber.value)
          ..addListener(_onPhoneNumberChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: [
          TextFormField(
            key: const Key('myForm_firstNameInput'),
            controller: _firstNameController,
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                icon: const Icon(Icons.person),
                labelText: 'First Name',
                helperText: 'Your first name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
            validator: (value) => _state.email.validator(value ?? '')?.text(),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
          height5(),
          TextFormField(
            key: const Key('myForm_lastNameInput'),
            controller: _lastNameController,
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                icon: const Icon(Icons.person),
                labelText: 'Last Name',
                helperText: 'Your last name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
            validator: (value) => _state.email.validator(value ?? '')?.text(),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
          height5(),
          TextFormField(
            key: const Key('myForm_usernameInput'),
            controller: _usernameController,
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                icon: const Icon(Icons.person),
                labelText: 'Username',
                helperText: 'Your username',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
            validator: (value) => _state.email.validator(value ?? '')?.text(),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
          height5(),
          TextFormField(
            key: const Key('myForm_phoneNumberInput'),
            controller: _phoneNumberController,
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                icon: const Icon(Icons.phone),
                labelText: 'Phone Number',
                helperText: 'Your phone number',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
            validator: (value) => _state.email.validator(value ?? '')?.text(),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          height5(),
          TextFormField(
            key: const Key('myForm_emailInput'),
            controller: _emailController,
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                icon: const Icon(Icons.email),
                labelText: 'Email',
                helperText: 'A valid email e.g. joe.doe@gmail.com',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
            validator: (value) => _state.email.validator(value ?? '')?.text(),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          height5(),
          TextFormField(
            key: const Key('myForm_passwordInput'),
            controller: _passwordController,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              icon: const Icon(Icons.lock),
              helperText:
                  'At least 8 characters including one letter and number',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              helperMaxLines: 2,
              labelText: 'Password',
              errorMaxLines: 2,
            ),
            validator: (value) =>
                _state.password.validator(value ?? '')?.text(),
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),
          if (_state.status.isInProgress)
            const CircularProgressIndicator()
          else
            ElevatedButton(
              key: const Key('myForm_submit'),
              onPressed: _onSubmit,
              child: const Text('Submit'),
            ),
        ],
      ),
    );
  }
}

class MyFormState with FormzMixin {
  MyFormState({
    this.firstName = const FirstName.pure(),
    this.lastName = const LastName.pure(),
    this.username = const Username.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    Email? email,
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
  }) : email = email ?? Email.pure();

  final FirstName firstName;
  final LastName lastName;
  final Username username;
  final PhoneNumber phoneNumber;

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;

  MyFormState copyWith({
    FirstName? firstName,
    LastName? lastName,
    Username? username,
    PhoneNumber? phoneNumber,
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
  }) {
    return MyFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs =>
      [email, password, firstName, lastName, username, phoneNumber];
}

class FirstName extends FormzInput<String, String> {
  const FirstName.pure([super.value = '']) : super.pure();

  const FirstName.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }
}

class LastName extends FormzInput<String, String> {
  const LastName.pure([super.value = '']) : super.pure();

  const LastName.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your last name';
    }
    return null;
  }
}

class Username extends FormzInput<String, String> {
  const Username.pure([super.value = '']) : super.pure();

  const Username.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }
}

class PhoneNumber extends FormzInput<String, String> {
  const PhoneNumber.pure([super.value = '']) : super.pure();

  const PhoneNumber.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    return null;
  }
}

enum EmailValidationError { invalid, empty }

class Email extends FormzInput<String, EmailValidationError>
    with FormzInputErrorCacheMixin {
  Email.pure([super.value = '']) : super.pure();

  Email.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    } else if (!_emailRegExp.hasMatch(value)) {
      return EmailValidationError.invalid;
    }

    return null;
  }
}

enum PasswordValidationError { invalid, empty }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure([super.value = '']) : super.pure();

  const Password.dirty([super.value = '']) : super.dirty();

  static final _passwordRegex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (!_passwordRegex.hasMatch(value)) {
      return PasswordValidationError.invalid;
    }

    return null;
  }
}

extension on EmailValidationError {
  String text() {
    switch (this) {
      case EmailValidationError.invalid:
        return 'Please ensure the email entered is valid';
      case EmailValidationError.empty:
        return 'Please enter an email';
    }
  }
}

extension on PasswordValidationError {
  String text() {
    switch (this) {
      case PasswordValidationError.invalid:
        return '''Password must be at least 8 characters and contain at least one letter and number''';
      case PasswordValidationError.empty:
        return 'Please enter a password';
    }
  }
}

*/