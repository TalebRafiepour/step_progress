import 'package:example/example_eight.dart';
import 'package:example/example_eighteen.dart';
import 'package:example/example_eleven.dart';
import 'package:example/example_fifteen.dart';
import 'package:example/example_five.dart';
import 'package:example/example_four.dart';
import 'package:example/example_fourteen.dart';
import 'package:example/example_nine.dart';
import 'package:example/example_nineteen.dart';
import 'package:example/example_one.dart';
import 'package:example/example_reproduce_issues.dart';
import 'package:example/example_seven.dart';
import 'package:example/example_seventeen.dart';
import 'package:example/example_six.dart';
import 'package:example/example_sixteen.dart';
import 'package:example/example_ten.dart';
import 'package:example/example_thirteen.dart';
import 'package:example/example_three.dart';
import 'package:example/example_twelve.dart';
import 'package:example/example_twenty.dart';
import 'package:example/example_two.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterStepProgressDemo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 18,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleOne(),
                    ),
                  );
                },
                child: const Text('Example One (Vertical)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleTwo(),
                    ),
                  );
                },
                child: const Text('Example Two (Horizontal - without labels)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleThree(),
                    ),
                  );
                },
                child: const Text('Example Three (LineOnly-Custom)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleFour(),
                    ),
                  );
                },
                child: const Text('Example Four (LineOnly Custom)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleFive(),
                    ),
                  );
                },
                child: const Text('Example Five (Border)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleSix(),
                    ),
                  );
                },
                child: const Text('Example Six (Positioned Labels)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleSeven(),
                    ),
                  );
                },
                child: const Text('Example Seven (NodeOnly)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleEight(),
                    ),
                  );
                },
                child: const Text('Example Eight (LineSpacing)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleNine(),
                    ),
                  );
                },
                child: const Text('Example Nine (SquareShape)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleTen(),
                    ),
                  );
                },
                child: const Text('Example Ten (TriangleShape)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleEleven(),
                    ),
                  );
                },
                child: const Text('Example Elevn (DiamondShape)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleTwelve(),
                    ),
                  );
                },
                child: const Text('Example Twelve (HexagonShape)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleThirteen(),
                    ),
                  );
                },
                child: const Text('Example Thirteen (StarShape)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleFourteen(),
                    ),
                  );
                },
                child: const Text('Example Fourteen (LargeLabel)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleFifteen(),
                    ),
                  );
                },
                child: const Text('Example Fifteen (LineLabel)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleSixteen(),
                    ),
                  );
                },
                child: const Text('Example Sixteen (CustomVerticalTimeLine)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleSeventeen(),
                    ),
                  );
                },
                child: const Text('Example Seventeen (BreadCrumbLine)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleEighteen(),
                    ),
                  );
                },
                child: const Text('Example Eighteen (DottedLine)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleNineteen(),
                    ),
                  );
                },
                child: const Text('Example Nineteen (RippleEffect node)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleTwenty(),
                    ),
                  );
                },
                child: const Text('Example Twenty (HighlitCurrentStepNode)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleReproduceIssues(),
                    ),
                  );
                },
                child: const Text('Reproduce Issue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
