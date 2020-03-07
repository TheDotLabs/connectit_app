import 'package:flutter/material.dart';

class GNav extends StatefulWidget {
  GNav(
      {Key key,
      this.tabs,
      this.selectedIndex = 0,
      this.onTabChange,
      this.gap,
      this.padding,
      this.activeColor,
      this.color,
      this.backgroundColor,
      this.tabBackgroundColor,
      this.iconSize,
      this.textStyle,
      this.curve,
      this.duration});

  final List<GButton> tabs;
  final int selectedIndex;
  final Function onTabChange;
  final double gap;
  final double iconSize;
  final Color activeColor;
  final Color backgroundColor;
  final Color tabBackgroundColor;
  final Color color;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final Duration duration;
  final Curve curve;

  @override
  _GNavState createState() => _GNavState();
}

class _GNavState extends State<GNav> {
  int selectedIndex;
  bool clickable = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedIndex = widget.selectedIndex;

    return Container(
        color: widget.backgroundColor ?? Colors.transparent,
        // padding: EdgeInsets.all(12),
        // alignment: Alignment.center,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.tabs
                .map((t) => GButton(
                      active: selectedIndex == widget.tabs.indexOf(t),
                      gap: t.gap ?? widget.gap,
                      iconActiveColor: t.iconActiveColor ?? widget.activeColor,
                      iconColor: t.iconColor ?? widget.color,
                      iconSize: t.iconSize ?? widget.iconSize,
                      textColor: t.textColor ?? widget.activeColor,
                      padding: t.padding ?? widget.padding,
                      textStyle: t.textStyle ?? widget.textStyle,
                      text: t.text,
                      icon: t.icon,
                      curve: widget.curve ?? Curves.ease,
                      backgroundColor: t.backgroundColor ??
                          widget.tabBackgroundColor ??
                          Colors.transparent,
                      duration: widget.duration ?? Duration(milliseconds: 500),
                      onPressed: () {
                        if (!clickable) return;
                        setState(() {
                          selectedIndex = widget.tabs.indexOf(t);
                          clickable = false;
                        });
                        widget.onTabChange(selectedIndex);

                        Future.delayed(
                            widget.duration ?? Duration(milliseconds: 500), () {
                          setState(() {
                            clickable = true;
                          });
                        });
                      },
                    ))
                .toList()));
  }
}

class GButton extends StatefulWidget {
  final bool active;
  final double gap;
  final Color iconColor;
  final Color iconActiveColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final double iconSize;
  final Function onPressed;
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Duration duration;
  final Curve curve;

  GButton(
      {Key key,
      this.active,
      this.backgroundColor,
      this.icon,
      this.iconColor,
      this.iconActiveColor,
      this.text,
      this.textColor,
      this.padding,
      this.duration,
      this.gap,
      this.curve,
      this.textStyle,
      this.iconSize,
      this.onPressed});

  @override
  _GButtonState createState() => _GButtonState();
}

class _GButtonState extends State<GButton> {
  @override
  Widget build(BuildContext context) {
    return Button(
      duration: widget.duration,
      iconSize: widget.iconSize,
      active: widget.active,
      onPressed: () {
        widget.onPressed();
      },
      padding: widget.padding,
      gap: widget.gap,
      color: widget.backgroundColor,
      curve: widget.curve,
      icon: Icon(widget.icon,
          color: widget.active ? widget.iconActiveColor : widget.iconColor,
          size: widget.iconSize),
      text: Text(
        widget.text,
        style: widget.textStyle ??
            TextStyle(fontWeight: FontWeight.w600, color: widget.textColor),
      ),
    );
  }
}

class Button extends StatefulWidget {
  Button(
      {Key key,
      this.icon,
      this.iconSize,
      this.text,
      this.gap = 0,
      this.color,
      this.onPressed,
      this.duration,
      this.curve,
      this.padding = const EdgeInsets.all(25),
      this.margin = const EdgeInsets.all(0),
      this.active = false})
      : super(key: key);

  final Widget icon;
  final double iconSize;
  final Widget text;
  final Color color;
  final double gap;
  final bool active;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Duration duration;
  final Curve curve;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> with TickerProviderStateMixin {
  bool _expanded;

  AnimationController expandController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _expanded = widget.active;

    expandController =
        AnimationController(vsync: this, duration: widget.duration);
    animation = CurvedAnimation(
        parent: expandController,
        curve: widget.curve,
        reverseCurve: widget.curve.flipped
        // curve: Cubic(0.25, 1.03, 0.31, 0.92),
        // reverseCurve: Cubic(0.77, 0.67, 0, 10).flipped

        );
  }

  @override
  void dispose() {
    expandController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _expanded = !widget.active;
    if (_expanded)
      expandController.reverse();
    else
      expandController.forward();

    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: AnimatedContainer(
        // padding: EdgeInsets.symmetric(horizontal: 5),
        padding: widget.padding,
        // curve: Curves.easeOutQuad,
        duration: Duration(
            milliseconds: (widget.duration.inMilliseconds.toInt() / 2).round()),
        margin: widget.margin,
        decoration: BoxDecoration(
            color: _expanded ? widget.color.withOpacity(0) : widget.color,
            borderRadius: BorderRadius.all(Radius.circular(100))),
        child: Stack(overflow: Overflow.visible, children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: widget.padding.vertical / 2),
                child: widget.icon,
              ),
            ],
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                    width: 0,
                    padding: EdgeInsets.symmetric(
                        vertical: widget.padding.vertical / 2),
                    child: widget.icon),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizeTransition(
                      axis: Axis.horizontal,
                      axisAlignment: 1,
                      sizeFactor: animation,
                      child: AnimatedOpacity(
                        opacity: _expanded ? 0.0 : 1.0,
                        curve:
                            _expanded ? Curves.easeOutQuint : Curves.easeInQuad,
                        duration: Duration(
                            milliseconds:
                                (widget.duration.inMilliseconds.toInt() / 1.5)
                                    .round()),
                        child: Container(
                            margin: EdgeInsets.only(
                                left: widget.gap + widget.iconSize),
                            alignment: Alignment.centerRight,
                            child: widget.text),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: widget.padding.vertical / 2),
                            child: widget.icon),
                        SizeTransition(
                          axis: Axis.horizontal,
                          axisAlignment: 1,
                          sizeFactor: animation,
                          child: Opacity(
                            opacity: 0, // debug use
                            child: Container(
                                color: Colors.red.withOpacity(.2),
                                padding: EdgeInsets.symmetric(
                                    horizontal: widget.gap),
                                child: widget.text),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
