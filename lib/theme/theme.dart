import 'package:flutter/material.dart';
import 'package:themallbd_new/theme/widget_theme/app_bar_theme.dart';
import 'package:themallbd_new/theme/widget_theme/button_theme.dart';
import 'package:themallbd_new/theme/widget_theme/custom_icon_theme.dart';
import 'package:themallbd_new/theme/widget_theme/progress_indicator_theme.dart';
import 'package:themallbd_new/theme/widget_theme/scroll_bar_theme.dart';

import '../constraints/app_colors.dart';
class CustomTheme{
CustomTheme._();

static ThemeData lightTheme=ThemeData(
  brightness: Brightness.light,
 // iconTheme: CustomIconTheme.iconTheme,
  appBarTheme: CustomAppBarTheme.appBarTheme,
  progressIndicatorTheme: CustomProgressBarTheme.progressIndicatorTheme,
  scaffoldBackgroundColor: Colors.white,
 // primarySwatch: AppColors.primarySwatchColor,
 // buttonTheme: CustomButtonTheme.buttonTheme,
  splashColor: AppColors.mainColorRed.withOpacity(.5),
  scrollbarTheme: CustomScrollBarTheme.scrollBarTheme,
 // fontFamily: 'Cabin',//GoogleFonts.inter().fontFamily,
  fontFamily: 'Lato',//GoogleFonts.inter().fontFamily,
 // fontFamily: GoogleFonts.cabin().fontFamily,
);

static ThemeData darkTheme=ThemeData(
  brightness: Brightness.dark,
  primaryColorDark: AppColors.mainColorRed,
 // primarySwatch: AppColors.primarySwatchColor,
  //fontFamily: GoogleFonts.inter().fontFamily,
  splashColor: AppColors.mainColorRed.withOpacity(.5),

);
}