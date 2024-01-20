import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

dynamic appBarGradient(BuildContext context) {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [context.primaryColor, context.primaryColor.withOpacity(0.5)],
  );
}
