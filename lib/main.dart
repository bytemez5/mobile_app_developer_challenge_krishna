import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'app_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const PebloApp(),
    ),
  );
}

class PebloApp extends StatelessWidget {
  const PebloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peblo Intern Challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const StoryBuddyScreen(),
    );
  }
}

class StoryBuddyScreen extends StatefulWidget {
  const StoryBuddyScreen({super.key});

  @override
  State<StoryBuddyScreen> createState() => _StoryBuddyScreenState();
}

class _StoryBuddyScreenState extends State<StoryBuddyScreen> with SingleTickerProviderStateMixin {
  final String storyText = "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...";
  late ConfettiController _confettiController;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Animation<double> get _shakeAnimation => Tween<double>(begin: 0.0, end: 24.0)
      .chain(CurveTween(curve: Curves.elasticIn))
      .animate(_shakeController);

  void _handleAnswer(String selected, String correct) {
    if (selected == correct) {
      _confettiController.play();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Awesome Job! That is Correct!'), 
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      _shakeController.forward(from: 0.0);
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: const Text('❌ Not quite! Try again, friend!'), 
          backgroundColor: Colors.orange,
          duration: Duration(milliseconds: 1500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Soft child-friendly backdrop
      appBar: AppBar(
        title: const Text('Peblo AI Story Buddy', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  // AI Buddy Placeholder
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFF3B82F6),
                    child: Text('🤖', style: TextStyle(fontSize: 55)),
                  ),
                  const SizedBox(height: 12),
                  const Text("Pip the Robot", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 20),

                  // Story Card Spec
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        storyText,
                        style: const TextStyle(fontSize: 18, height: 1.6, color: Color(0xFF334155)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Interactive Voice Control Trigger
                  _buildAudioButton(provider),

                  const SizedBox(height: 32),

                  // Data-Driven Quiz Block
                  if (provider.showQuiz && provider.quiz != null)
                    AnimatedBuilder(
                      animation: _shakeController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(sin(_shakeAnimation.value * pi * 2) * 8, 0),
                          child: child,
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                provider.quiz!.question,
                                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ...provider.quiz!.options.map((option) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(double.infinity, 52),
                                      backgroundColor: const Color(0xFFEFF6FF),
                                      foregroundColor: const Color(0xFF2563EB),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: const BorderSide(color: Color(0xFFBFDBFE), width: 1.5),
                                      ),
                                    ),
                                    onPressed: () => _handleAnswer(option, provider.quiz!.answer),
                                    child: Text(option, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioButton(AppProvider provider) {
    if (provider.currentState == AppState.loading) {
      return const CircularProgressIndicator();
    }
    if (provider.currentState == AppState.error) {
      return Column(
        children: [
          Text(provider.errorMessage, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () => provider.readStory(storyText), child: const Text("Retry")),
        ],
      );
    }
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: const Color(0xFFF59E0B),
        elevation: 3,
      ),
      onPressed: provider.currentState == AppState.playing ? null : () => provider.readStory(storyText),
      icon: const Icon(Icons.volume_up, color: Colors.white, size: 24),
      label: Text(
        provider.currentState == AppState.playing ? "Listening..." : "Read Me a Story",
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}