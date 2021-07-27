# Welcome to elliptic_text

This package lets you draw curved text in Flutter along the perimiter of an ellipse or circle. Using the EllipticText widget included in this package is as easy as using any widget in Flutter:

## Example

```dart
final _ellipticText = SizedBox(
    height: 450.0,
    width: 300.0,
    child: EllipticText(
        text: "Smile! :) Why should text always be straight?",
    ),
);
```

Here's an example of what your text could look like:

<img src="https://robmllze.github.io/elliptic_text/readme_assets/smile.gif" style="max-height: 400px; max-width: 400px; object-fit: contain" />

## Properties

The following snippet demonstrates all the properties of the EllipticText widget:

```dart
final _ellipticTextStack = Stack(
  // To draw multiple texts on the same curve, use a Stack.
  children: [
    // To set the size of your ellipse, wrap a SizedBox around it.
    SizedBox(
      height: 450.0,
      width: 300.0,
      child: EllipticText(

        // Write a nice message to the Germans and the Spanish for being great
        // people.
        text: "Deutschland ist ein tolles Land... ¡y España tambien!",

        // Style your text.
        style: TextStyle(
          color: Colors.purple,
          fontSize: 20.0,

          // Space your letters out by specifying the letterSpacing.
          letterSpacing: 2.0,
          
          // Text decorations are NOT supported and will throw an error if
          // specified.
          //decoration: TextDecoration.overline

          // Word spacing is NOT supported  and will throw an error if
          // specified.
          //wordSpacing: 5.0
        ),

        // Align your text nicely in the middle.
        textAlignment: EllipticText_TextAlignment.centre,

        // Draw your text at the bottom of the ellipse.
        perimiterAlignment: EllipticText_PerimiterAlignment.bottom,

        // Offset your text by -5 pixels.
        offset: -5.0,

        // Ensure the bottom of your text faces away from the centre of the
        // ellipse.
        centreAlignment: EllipticText_CentreAlignment.bottomSideAway,

        // Stretch text to half of the circumference of the ellipse.
        fitFactor: 1 / 2,

        // Specify how you'd like to stretch your text. By adjusting the
        // letterSpacing, the fontSize, or maybe both?
        fitType: EllipticText_FitType.stretchFit,

        // Use this to stretch your text some more.
        stretchFactor: 1.0,

        // Finally, if you're debugging your application, add the following line
        // to see the ellipse on which your text is drawn.
        debugStrokeWidth: 1.0,
      ),
    ),
  ],
);
```

## Conclusion

Finally, here's an example of all the different alignments and properties in action:

<img src="https://robmllze.github.io/elliptic_text/readme_assets/sample.png" style="max-height: 400px; max-width: 400px; object-fit: contain" />

Please let me know if you find any bugs or if you have suggestions.

Thanks,

Robert Mollentze

GitHub: /robmllze

Email: robmllze@gmail.com
