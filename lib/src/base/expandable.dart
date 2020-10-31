import 'package:flutter/material.dart';

class ExpandableView extends StatefulWidget {
  const ExpandableView(
      {Key key,
      this.expandedChild,
      this.collapseHeader,
      this.headerMargin,
      this.headerBorderRadius,
      this.onCollapseStatusChange,
      this.showDownArrow = true,
      this.childrenPadding,
      this.expandedInitialState = false,
      this.headerBackgorundColor})
      : super(key: key);
  final EdgeInsetsGeometry headerMargin;
  final EdgeInsetsGeometry childrenPadding;
  final BorderRadius headerBorderRadius;
  final Widget collapseHeader;
  final Widget expandedChild;
  final ValueChanged<bool> onCollapseStatusChange;
  final bool showDownArrow;
  final bool expandedInitialState;
  final Color headerBackgorundColor;

  @override
  ExpandableViewState createState() => ExpandableViewState();
}

class ExpandableViewState extends State<ExpandableView>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static const _expandDuration = Duration(milliseconds: 200);
  AnimationController _controller;
  Animation<double> _childrenHeightFactor;
  Animation<double> _headerChevronOpacity;
  Animation<double> _headerHeight;
  Animation<EdgeInsetsGeometry> _headerMargin;
  Animation<EdgeInsetsGeometry> _childrenPadding;
  Animation<BorderRadius> _headerBorderRadius;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _expandDuration, vsync: this);
    _childrenHeightFactor = _controller.drive(_easeInTween);
    _headerChevronOpacity = _controller.drive(_easeInTween);
    _headerHeight = Tween<double>(
      begin: 80,
      end: 96,
    ).animate(_controller);
    _headerMargin = EdgeInsetsGeometryTween(
      begin: widget.headerMargin ?? const EdgeInsets.fromLTRB(8, 2, 8, 2),
      end: EdgeInsets.zero,
    ).animate(_controller);
    _childrenPadding = EdgeInsetsGeometryTween(
      begin: widget.childrenPadding ?? EdgeInsets.symmetric(horizontal: 32),
      end: EdgeInsets.zero,
    ).animate(_controller);
    _headerBorderRadius = BorderRadiusTween(
      begin: widget.headerBorderRadius ?? BorderRadius.circular(10),
      end: BorderRadius.circular(2),
    ).animate(_controller);

    if (widget.expandedInitialState) {
      isExpanded = true;
      _controller.forward();
    }

    if (isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleTap() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild.
          });
        });
      }
      if (widget.onCollapseStatusChange != null)
        widget.onCollapseStatusChange(isExpanded);
    });
  }

  Widget _buildHeaderWithChildren(BuildContext context, Widget child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CollapseHeader(
          margin: _headerMargin.value,
          borderRadius: _headerBorderRadius.value,
          height: _headerHeight.value,
          chevronOpacity:
              widget.showDownArrow ? 1 : _headerChevronOpacity.value,
          collapseHeader: widget.collapseHeader,
          isExpanded: isExpanded,
          onTap: handleTap,
          headerBackgorundColor: widget.headerBackgorundColor,
        ),
        Padding(
          padding: _childrenPadding.value,
          child: ClipRect(
            child: Align(
              heightFactor: _childrenHeightFactor.value,
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildHeaderWithChildren,

      child: closed ? null : widget.expandedChild,
      // Container(height: closed ? 0 : null, child: widget.expandedChild)
    );
  }
}

class _CollapseHeader extends StatelessWidget {
  const _CollapseHeader(
      {Key key,
      this.margin,
      this.borderRadius,
      this.height,
      this.chevronOpacity,
      this.onTap,
      this.collapseHeader,
      this.isExpanded,
      this.headerBackgorundColor})
      : super(key: key);

  final EdgeInsetsGeometry margin;
  final bool isExpanded;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final Widget collapseHeader;
  final double chevronOpacity;
  final GestureTapCallback onTap;
  final Color headerBackgorundColor;
  @override
  Widget build(BuildContext context) {
    final colorScheme = headerBackgorundColor ?? Theme.of(context).cardColor;
    return Container(
      margin: margin,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        color: colorScheme,
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Expanded(child: collapseHeader),
                Opacity(
                    opacity: chevronOpacity,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 8,
                        end: 8,
                      ),
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color:
                            headerBackgorundColor != null ? Colors.white : null,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
