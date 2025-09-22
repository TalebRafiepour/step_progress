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
import 'package:example/example_seven.dart';
import 'package:example/example_seventeen.dart';
import 'package:example/example_six.dart';
import 'package:example/example_sixteen.dart';
import 'package:example/example_ten.dart';
import 'package:example/example_thirteen.dart';
import 'package:example/example_three.dart';
import 'package:example/example_twelve.dart';
import 'package:example/example_twenty.dart';
import 'package:example/example_twenty_one.dart';
import 'package:example/example_twenty_two.dart';
import 'package:example/example_two.dart';
import 'package:example/reproduce_issues.dart';
import 'package:example/reproduce_large_labels.dart';
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
                child: const Text('1-Vertical'),
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
                child: const Text('2-HorizontalWithoutLabels'),
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
                child: const Text('3-LineOnlyCustom'),
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
                child: const Text('4-LineOnlyCustom'),
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
                child: const Text('5-Border'),
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
                child: const Text('6-PositionedLabels'),
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
                child: const Text('7-NodeOnly'),
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
                child: const Text('8-LineSpacing'),
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
                child: const Text('9-SquareShape'),
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
                child: const Text('10-TriangleShape'),
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
                child: const Text('11-DiamondShape'),
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
                child: const Text('12-HexagonShape'),
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
                child: const Text('13-StarShape'),
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
                child: const Text('14-LineLabels'),
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
                child: const Text('15-CustomVerticalTimeLine'),
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
                child: const Text('16-BreadCrumbLine'),
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
                child: const Text('17-DottedLine'),
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
                child: const Text('18-RippleEffectNode'),
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
                child: const Text('19-HighlitCurrentStepNode'),
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
                child: const Text(
                  '20-CustomStepperWithoutLines',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleTwentyOne(),
                    ),
                  );
                },
                child: const Text(
                  '21-InstagramStoryLikeStepper',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExampleTwentyTwo(),
                    ),
                  );
                },
                child: const Text(
                  '22-LineFirstMode',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReproduceLargeLabels(),
                    ),
                  );
                },
                child: const Text('ReproduceLargeLabels'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReproduceIssues(),
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
