import 'package:flutter/material.dart';

import '../src/color.dart';

class RippleButton extends StatefulWidget {
  const RippleButton({Key? key, required this.icon, required this.color})
      : super(key: key);
  final IconData icon;
  final Color color;
  @override
  State<RippleButton> createState() => _RippleButtonState();
}

class _RippleButtonState extends State<RippleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.6,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Container(
          height: MediaQuery.of(context).size.width / 3.3,
          width: MediaQuery.of(context).size.width / 3.3,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              _buildContainer(30 * _controller.value),
              _buildContainer(60 * _controller.value),
              _buildContainer(90 * _controller.value),
              _buildContainer(120 * _controller.value),
              _buildContainer(150 * _controller.value),
              AnimatedIconExample(
                icon: widget.icon,
                color: widget.color,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: COLORS.WHITE.withOpacity(0.15),
      ),
    );
  }
}

class AnimatedIconExample extends StatefulWidget {
  AnimatedIconExample({required this.icon, required this.color, Key? key})
      : super(key: key);
  final IconData icon;
  final Color color;

  @override
  State<AnimatedIconExample> createState() => _AnimatedIconExampleState();
}

class _AnimatedIconExampleState extends State<AnimatedIconExample>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )
      ..forward()
      ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 0.1).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: widget.color,
        shape: BoxShape.circle,
      ),
      child: widget.icon == Icons.phone && controller.value > 0.5
          ? Transform.rotate(
              angle: 170,
              child: Icon(
                Icons.phone,
                size: 34.0,
                color: COLORS.WHITE,
              ))
          : Icon(
              widget.icon,
              size: 34.0,
              color: COLORS.WHITE,
            ),
    );
  }
}
