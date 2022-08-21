import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:royaltouch/config/colors.dart';

//Text Styles

class TfDecoration {
  static TextStyle textInputStyle() {
    return GoogleFonts.publicSans(
        color: statusBarColor, fontWeight: FontWeight.w400);
  }

  static InputDecoration inputDecoration({String textHint}) {
    return InputDecoration(
      isDense: true,
      // contentPadding: bothHorAndVertical,
      focusColor: Colors.white,
      filled: true,
      fillColor: Colors.white,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 0.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(5),
      ),
      hintText: textHint,
      hintStyle: GoogleFonts.publicSans(
        color: hintText,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static InputDecoration modifyTextFieldDec(String textHint) {
    return InputDecoration(
      isDense: true,
      // contentPadding: bothHorAndVertical,
      focusColor: Colors.white,
      filled: true,
      fillColor: bg,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 0.0),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      hintText: textHint,
      hintStyle: GoogleFonts.publicSans(
        color: hintText,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
