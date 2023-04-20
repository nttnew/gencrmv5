import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';

import '../src/src_index.dart';

class RippleLogo extends StatefulWidget {
  const RippleLogo({
    Key? key,
    required this.pitelCall,
    required this.timeLabel,
    required this.isCall,
  }) : super(key: key);
  final PitelCall pitelCall;
  final String timeLabel;
  final bool isCall;

  @override
  State<RippleLogo> createState() => _RippleLogoState();
}

class _RippleLogoState extends State<RippleLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              if (!widget.isCall) ...[
                _buildContainer(90 * _controller.value),
                _buildContainer(130 * _controller.value),
                _buildContainer(170 * _controller.value),
                _buildContainer(210 * _controller.value),
                _buildContainer(250 * _controller.value),
              ],
              Positioned(
                bottom: 0,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: WidgetText(
                        title:
                            '${(widget.pitelCall.remoteIdentity?.length ?? 0) < 10 ? '0' + widget.pitelCall.remoteIdentity.toString() : widget.pitelCall.remoteIdentity}',
                        style: AppStyle.DEFAULT_24.copyWith(
                            fontSize: 32, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: WidgetText(
                        title: widget.timeLabel,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                ICONS.IC_FAVICON_PNG,
                height: MediaQuery.of(context).size.width / 3,
                width: MediaQuery.of(context).size.width / 3,
                fit: BoxFit.contain,
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
        color: Colors.white.withOpacity(0.15),
      ),
    );
  }
}
