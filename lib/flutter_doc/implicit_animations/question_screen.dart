import 'package:animation_gallery/flutter_doc/implicit_animations/scoreboard.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'flip_effect.dart';
import 'view_model.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late final QuizViewModel viewModel = QuizViewModel(
    onGameOver: _handleGameOver,
  );
  VoidCallback? _showGameOverScreen;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed:
                    viewModel.hasNextQuestion && viewModel.didAnswerQuestion
                        ? () {
                            viewModel.getNextQuestion();
                          }
                        : null,
                child: const Text('Next'),
              ),
            ],
          ),
          body: Center(
            child: Column(
              children: [
                QuestionCard(                                           // NEW
                  onChangeOpenContainer: _handleChangeOpenContainer,    // NEW
                  question: viewModel.currentQuestion?.question,        // NEW
                  viewModel: viewModel,                                 // NEW
                ),
                Spacer(),
                AnswerCards(
                  onTapped: (index) {
                    viewModel.checkAnswer(index);
                  },
                  answers: viewModel.currentQuestion?.possibleAnswers ?? [],
                  correctAnswer: viewModel.didAnswerQuestion
                      ? viewModel.currentQuestion?.correctAnswer
                      : null,
                ),
                StatusBar(viewModel: viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleChangeOpenContainer(VoidCallback openContainer) {        // NEW
    _showGameOverScreen = openContainer;                               // NEW
  }                                                                    // NEW

  void _handleGameOver() {                                             // NEW
    if (_showGameOverScreen != null) {                                 // NEW
      _showGameOverScreen!();                                          // NEW
    }                                                                  // NEW
  }

  void _handleGameOverOld() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Game Over!'),
          content: Text('Score: ${viewModel.score}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String? question;

  const QuestionCard({
    required this.onChangeOpenContainer,
    required this.question,
    required this.viewModel,
    super.key,
  });

  final ValueChanged<VoidCallback> onChangeOpenContainer;
  final QuizViewModel viewModel;

  static const _backgroundColor = Color(0xfff2f3fa);

  @override
  Widget build(BuildContext context) {
    // return AnimatedSwitcher(
    //   layoutBuilder: (currentChild, previousChildren) {
    //     return Stack(
    //       alignment: Alignment.topCenter,
    //       children: <Widget>[
    //         ...previousChildren,
    //         if (currentChild != null) currentChild,
    //       ],
    //     );
    //   },
    //   transitionBuilder: (child, animation) {
    //     // var offsetAnimation = animation
    //     //     .drive(CurveTween(curve: Curves.easeInCubic))
    //     //     .drive(Tween<Offset>(
    //     //         begin: const Offset(-0.1, 0.0), end: Offset.zero));
    //     // return SlideTransition(position: offsetAnimation, child: child);
    //     // Add from here...
    //
    //     final curveAnimation = CurveTween(
    //       curve: Curves.easeInCubic,
    //     ).animate(animation);
    //     final offsetAnimation = Tween<Offset>(
    //       begin: const Offset(-0.1, 0.0),
    //       end: Offset.zero,
    //     ).animate(curveAnimation);
    //     final fadeInAnimation = curveAnimation; // NEW
    //     return FadeTransition(
    //       // NEW
    //       opacity: fadeInAnimation, // NEW
    //       child:
    //           SlideTransition(position: offsetAnimation, child: child), // NEW
    //     );
    //   },
    //   duration: const Duration(milliseconds: 300),
    //   child: Card(
    //     key: ValueKey(question),
    //     elevation: 4,
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Text(
    //         question ?? '',
    //         style: Theme.of(context).textTheme.displaySmall,
    //       ),
    //     ),
    //   ),
    // );

    /// solution 2:
    // return PageTransitionSwitcher(
    //   // Add from here...
    //   layoutBuilder: (entries) {
    //     return Stack(alignment: Alignment.topCenter, children: entries);
    //   },
    //   transitionBuilder: (child, animation, secondaryAnimation) {
    //     return FadeThroughTransition(
    //       animation: animation,
    //       secondaryAnimation: secondaryAnimation,
    //       child: child,
    //     );
    //   }, // To here.
    //   duration: const Duration(milliseconds: 300),
    //   child: Card(
    //     key: ValueKey(question),
    //     elevation: 4,
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Text(
    //         question ?? '',
    //         style: Theme.of(context).textTheme.displaySmall,
    //       ),
    //     ),
    //   ),
    // );

    /// solution 3:
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation, secondaryAnimation) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: OpenContainer(                                         // NEW
        key: ValueKey(question),                                    // NEW
        tappable: false,                                            // NEW
        closedColor: _backgroundColor,                              // NEW
        closedShape: const RoundedRectangleBorder(                  // NEW
          borderRadius: BorderRadius.all(Radius.circular(12.0)),    // NEW
        ),                                                          // NEW
        closedElevation: 4,                                         // NEW
        closedBuilder: (context, openContainer) {                   // NEW
          onChangeOpenContainer(openContainer);                     // NEW
          return ColoredBox(                                        // NEW
            color: _backgroundColor,                                // NEW
            child: Padding(                                         // NEW
              padding: const EdgeInsets.all(16.0),                  // NEW
              child: Text(
                question ?? '',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          );
        },
        openBuilder: (context, closeContainer) {                    // NEW
          return GameOverScreen(viewModel: viewModel);              // NEW
        },                                                          // NEW
      ),
    );
  }
}

class AnswerCards extends StatelessWidget {
  final List<String> answers;
  final ValueChanged<int> onTapped;
  final int? correctAnswer;

  const AnswerCards({
    required this.answers,
    required this.onTapped,
    required this.correctAnswer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 5 / 2,
      children: List.generate(answers.length, (index) {
        var color = Theme.of(context).colorScheme.primaryContainer;
        if (correctAnswer == index) {
          color = Theme.of(context).colorScheme.tertiaryContainer;
        }
        return CardFlipEffect(
          delayAmount: index.toDouble() / 2,
          duration: const Duration(milliseconds: 300),
          child: Card.filled(
            key: ValueKey(answers[index]),
            color: color,
            elevation: 2,
            margin: EdgeInsets.all(8),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () => onTapped(index),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    answers.length > index ? answers[index] : '',
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class StatusBar extends StatelessWidget {
  final QuizViewModel viewModel;

  const StatusBar({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Scoreboard(
              score: viewModel.score,
              totalQuestions: viewModel.totalQuestions,
            ),
          ],
        ),
      ),
    );
  }
}


class GameOverScreen extends StatelessWidget {
  final QuizViewModel viewModel;
  const GameOverScreen({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Scoreboard(
              score: viewModel.score,
              totalQuestions: viewModel.totalQuestions,
            ),
            Text('You Win!', style: Theme.of(context).textTheme.displayLarge),
            Text(
              'Score: ${viewModel.score} / ${viewModel.totalQuestions}',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}