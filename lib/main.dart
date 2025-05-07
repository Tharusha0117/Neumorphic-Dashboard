import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Neumorphic Animated Dashboard',
      theme: NeumorphicThemeData(
        baseColor: Colors.transparent,
        lightSource: LightSource.topLeft,
        depth: 8,
      ),
      home: const NeumorphicDashboard(),
    );
  }
}

class NeumorphicDashboard extends StatefulWidget {
  const NeumorphicDashboard({super.key});

  @override
  State<NeumorphicDashboard> createState() => _NeumorphicDashboardState();
}

class _NeumorphicDashboardState extends State<NeumorphicDashboard> with TickerProviderStateMixin {
  bool animateCards = false;
  bool showUI = false;
  late AnimationController _titleController;
  late Animation<Offset> _titleOffset;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _titleOffset = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _titleController, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 300), () {
      _titleController.forward();
      setState(() {
        animateCards = true;
        showUI = true;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AnimatedGradientBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: NeumorphicAppBar(
            title: SlideTransition(
              position: _titleOffset,
              child: const Text(
                'smart Home',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                buildAnimatedCard(GadgetCard(icon: Icons.thermostat, label: "Temperature", value: "24°C"), 0),
                buildAnimatedCard(GadgetCard(icon: Icons.battery_charging_full, label: "Battery", value: "87%"), 1),
                buildAnimatedCard(const ClockCard(), 2),
                buildAnimatedCard(GadgetCard(icon: Icons.wifi, label: "Wi-Fi", value: "Connected"), 3),
                buildAnimatedCard(GadgetCard(icon: Icons.music_note, label: "Music", value: "Playing"), 4),
                buildAnimatedCard(GadgetCard(icon: Icons.lightbulb, label: "Lights", value: "5 On"), 5),
                buildAnimatedCard(GadgetCard(icon: Icons.security, label: "Security", value: "Active"), 6),
                buildAnimatedCard(GadgetCard(icon: Icons.cloud, label: "Weather", value: "Sunny"), 7),
              ],
            ),
          ),
          floatingActionButton: AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: showUI ? 1 : 0,
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_fabController),
              child: NeumorphicButton(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  boxShape: NeumorphicBoxShape.circle(),
                  depth: 8,
                  intensity: 1,
                  color: Colors.white.withOpacity(0.5),
                  shadowLightColor: Colors.white,
                  shadowDarkColor: Colors.grey.shade500,
                ),
                child: const Icon(Icons.refresh, size: 30),
                onPressed: () {
                  _fabController.forward(from: 0.0);
                },
              ),
            ),
          ),
          bottomNavigationBar: AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: showUI ? 1 : 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: -5,
                  color: Colors.white.withOpacity(0.3),
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                ),
                padding: const EdgeInsets.all(16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.home),
                    Icon(Icons.settings),
                    Icon(Icons.person),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAnimatedCard(Widget card, int index) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 400 + index * 100),
      opacity: animateCards ? 1 : 0,
      child: AnimatedScale(
        duration: Duration(milliseconds: 400 + index * 100),
        scale: animateCards ? 1 : 0.8,
        child: card,
      ),
    );
  }
}

class GadgetCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;

  const GadgetCard({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  @override
  State<GadgetCard> createState() => _GadgetCardState();
}

class _GadgetCardState extends State<GadgetCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
  }

  void _onTap() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      ),
      child: GestureDetector(
        onTap: _onTap,
        child: Neumorphic(
          style: NeumorphicStyle(
            depth: 6,
            color: Colors.white.withOpacity(0.3),
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 40, color: Colors.black),
              const SizedBox(height: 10),
              Text(widget.label, style: const TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 5),
              Text(widget.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ClockCard extends StatefulWidget {
  const ClockCard({super.key});

  @override
  State<ClockCard> createState() => _ClockCardState();
}

class _ClockCardState extends State<ClockCard> {
  late String _time;

  @override
  void initState() {
    super.initState();
    _time = _formatTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _time = _formatTime(DateTime.now());
      });
    });
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')} : ${time.minute.toString().padLeft(2, '0')} : ${time.second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 6,
        color: Colors.white.withOpacity(0.3),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.access_time, size: 40, color: Colors.black),
          const SizedBox(height: 10),
          const Text("Clock", style: TextStyle(fontSize: 16, color: Colors.black87)),
          const SizedBox(height: 5),
          Text(_time, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }
}

class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key});

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground> {
  List<Color> colors1 = [const Color(0xFF89F7FE), const Color(0xFF66A6FF)];
  List<Color> colors2 = [const Color(0xFFFBD786), const Color(0xFFF7797D)];
  bool toggle = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 6), (timer) {
      setState(() {
        toggle = !toggle;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: toggle ? colors1 : colors2,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
