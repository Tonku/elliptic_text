// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// ELLIPTIC TEXT - FULL USAGE EXAMPLE
//
// Coded by Robert Mollentze
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:flutter/material.dart';
import 'elliptic_text.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main() {
  runApp(MyApp());
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 270,
              height: 135,
              child: Stack(
                children: [
                  EllipticText(
                    text: "Die ellips is die eerste keer bestudeer deur "
                        "Menaechmus, toe ondersoek deur Euclid, en benoem deur "
                        "Apollonius.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                    ),
                    // Tip 1 of 8:
                    // Set text position by choosing one of the alignment
                    // options.
                    perimiterAlignment: EllipticText_PerimiterAlignment.right,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 340,
              height: 340,
              child: Stack(
                children: [
                  EllipticText(
                    text: " This is elliptic_text by @robmllze",
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 28.0,
                    ),
                    perimiterAlignment: EllipticText_PerimiterAlignment.top,
                    fitType: EllipticText_FitType.comboFit,
                  ),
                  EllipticText(
                    text: " Ask yourself: "
                        "\"Why should text always be straight?\" ",
                    style: TextStyle(
                      color: Colors.lime,
                      fontSize: 20.0,
                    ),
                    perimiterAlignment: EllipticText_PerimiterAlignment.bottom,
                    // Tip 2 of 8:
                    // Adjust text position relative to perimiterAlignment.
                    offsetPosition: 0.0,
                    // Tip 3 of 8:
                    // There are 3 fit types:
                    // * "scaleFit" alters the font size.
                    // * "stretchFit" alters the letter spacing.
                    // * "comboFit" alters both the font size and letter spacing.
                    fitType: EllipticText_FitType.comboFit,
                    // Tip 4 of 8:
                    // Set the fit factor e.g. 1/2 stretches the text over half
                    // the perimiter while 1/4 over a quarter, etc.
                    // Note: If fitType is "noFit" (the default) this will have
                    // no affect.
                    fitFactor: 1.0 / 2.0,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 500.0,
              height: 700.0,
              child: Stack(
                children: [
                  EllipticText(
                    text: "Die Spitze der Ellipse",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                    perimiterAlignment: EllipticText_PerimiterAlignment.top,
                  ),
                  EllipticText(
                    text: "Top-Right",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 32.0,
                      fontStyle: FontStyle.italic,
                    ),
                    perimiterAlignment:
                        EllipticText_PerimiterAlignment.topRight,
                    // Tip 5 of 8:
                    // Set side of text to face centre of the ellipse.
                    centreAlignment: EllipticText_CentreAlignment.bottom,
                  ),
                  EllipticText(
                    text: "La Derecha (Stretched)",
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    perimiterAlignment: EllipticText_PerimiterAlignment.right,
                    // Tip 6 of 8:
                    // Stretch the text around perimiter.
                    textStretch: 1.5,
                  ),
                  EllipticText(
                    text: "Onder-Rechts",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    perimiterAlignment:
                        EllipticText_PerimiterAlignment.bottomRight,
                  ),
                  EllipticText(
                    text: "Bottom (Right-Aligned)",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 15.0,
                    ),
                    textStretch: 1.0,
                    perimiterAlignment: EllipticText_PerimiterAlignment.bottom,
                    // Tip 7 of 8:
                    // Align the text to the right, the left or keep it nicely
                    // in the centre.
                    textAlignment: EllipticText_TextAlignment.right,
                  ),
                  EllipticText(
                    text: "BOTTOM-LEFT (LETTER SPACING)",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      // Tip 8 of 8:
                      // Feel free to change the letter spacing.
                      letterSpacing: 5.0,
                    ),
                    perimiterAlignment:
                        EllipticText_PerimiterAlignment.bottomLeft,
                  ),
                  EllipticText(
                    text: " Left ",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    perimiterAlignment: EllipticText_PerimiterAlignment.left,
                    textAlignment: EllipticText_TextAlignment.right,
                  ),
                  EllipticText(
                    text: " Vinstri hlið",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                    perimiterAlignment: EllipticText_PerimiterAlignment.left,
                    textAlignment: EllipticText_TextAlignment.right,
                    centreAlignment: EllipticText_CentreAlignment.top,
                  ),
                  EllipticText(
                    text: "Bo-Links",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                    perimiterAlignment: EllipticText_PerimiterAlignment.topLeft,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
