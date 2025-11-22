import 'package:flutter/material.dart';

const double iconOff = -3;
const double iconOn = 0;
const double textOff = 3;
const double textOn = 1;
const double alphaOff = 0;
const double alphaOn = 1;
const int animDuration = 300;

class MotionTabItem extends StatefulWidget {
  final String? title;
  final bool selected;
  final Widget? icon;
  final TextStyle textStyle;
  final Function callbackFunction;
  final Color tabIconColor;
  final double? tabIconSize;
  final Widget? badge;

  const MotionTabItem({super.key,
    required this.title,
    required this.selected,
    required this.icon,
    required this.textStyle,
    required this.tabIconColor,
    required this.callbackFunction,
    this.tabIconSize = 24,
    this.badge,
  });

  @override
  State<MotionTabItem> createState() => _MotionTabItemState();
}

class _MotionTabItemState extends State<MotionTabItem> {
  double iconYAlign = iconOn;
  double textYAlign = textOff;
  double iconAlpha = textOn;

  @override
  void initState() {
    super.initState();
    _setIconTextAlpha();
  }

  @override
  void didUpdateWidget(MotionTabItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setIconTextAlpha();
  }

  _setIconTextAlpha() {
    setState(() {
      iconYAlign = (widget.selected) ? iconOff : iconOn;
      textYAlign = (widget.selected) ? textOn : textOff;
      iconAlpha = (widget.selected) ? alphaOff : alphaOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            child: AnimatedAlign(
              duration: const Duration(milliseconds: animDuration),
              alignment: Alignment(0, textYAlign),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.selected
                    ? Text(
                        widget.title!,
                        style: widget.textStyle,
                        softWrap: false,
                        maxLines: 1,
                        textAlign: TextAlign.center,

                      )
                    : const Text(''),
              ),
            ),
          ),
          InkWell(
            onTap: () => widget.callbackFunction(),
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: AnimatedAlign(
                duration: const Duration(milliseconds: animDuration),
                curve: Curves.easeIn,
                alignment: Alignment(0, iconYAlign),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: animDuration),
                  opacity: iconAlpha,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        padding: const EdgeInsets.all(0),
                        alignment: const Alignment(0, 0),
                        icon: widget.icon??const SizedBox(),
                        onPressed: () => widget.callbackFunction(),
                      ),
                      widget.badge != null
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: widget.badge!,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
