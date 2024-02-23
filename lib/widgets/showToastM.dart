import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gen_crm/src/src_index.dart';

enum ToastState {
  SUCCESS,
  ERROR,
  WARNING,
}

Future<void> showToastM(
  BuildContext context, {
  String? image,
  String? message,
  String? title,
  EdgeInsets? margin,
  bool autoClose = true,
  bool hasClose = true,
  Widget? action,
  Duration? durationClose,
}) async {
  final toast = FToast();
  toast.init(context);
  toast.removeQueuedCustomToasts();
  toast.showToast(
    child: ToastView(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
      message: message,
      title: title,
      action: action,
    ),
  );
}

class ToastCustom extends StatefulWidget {
  const ToastCustom({
    Key? key,
    this.image,
    this.message,
    this.autoClose = true,
    this.action,
    this.state = ToastState.SUCCESS,
    this.durationClose,
    required this.hasClose,
    this.title,
  }) : super(key: key);

  final Widget? image;
  final String? message;
  final String? title;
  final bool autoClose;
  final bool hasClose;
  final Widget? action;
  final ToastState state;
  final Duration? durationClose;

  @override
  State<ToastCustom> createState() => _DialogIconState();
}

class _DialogIconState extends State<ToastCustom> {
  @override
  void initState() {
    super.initState();
    if (widget.autoClose) {
      Future.delayed(widget.durationClose ?? const Duration(milliseconds: 1000),
          () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          if (widget.hasClose) {
            Navigator.of(context).pop();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ToastView(
              image: widget.image,
              title: widget.title,
              action: widget.action,
              message: widget.message,
              state: widget.state,
            )
          ],
        ),
      ),
    );
  }
}

class ToastView extends StatelessWidget {
  const ToastView({
    Key? key,
    this.image,
    this.message,
    this.title,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    this.action,
    this.state = ToastState.ERROR,
  }) : super(key: key);

  final Widget? image;
  final String? message;
  final String? title;
  final Widget? action;
  final ToastState state;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        color: COLORS.WHITE,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: COLORS.GREY,
            blurRadius: 15,
            offset: Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 19,
        vertical: 16,
      ),
      margin: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title ?? '',
              style: AppStyle.DEFAULT_14_BOLD.apply(color: COLORS.BLACK),
            ),
          if (message != null)
            Text(
              message ?? '',
              style: AppStyle.DEFAULT_14_BOLD.copyWith(fontSize: 12),
            ),
        ],
      ),
    );
  }
}
