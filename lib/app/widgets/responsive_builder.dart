import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// Responsive layout builder that provides device type detection and responsive building
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
    bool isMobile,
  )
  builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Responsive.init(constraints);
        return builder(
          context,
          Responsive.isDesktop,
          Responsive.isTabletPortrait || Responsive.isTabletLandscape,
          Responsive.isMobilePortrait || Responsive.isMobileLandscape,
        );
      },
    );
  }
}

/// Responsive container that adapts to screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? maxWidth;
  final Alignment alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Responsive.init(constraints);
        return Align(
          alignment: alignment,
          child: Container(
            width: maxWidth ?? Responsive.maxContentWidth,
            padding: padding ?? Responsive.responsivePadding,
            child: child,
          ),
        );
      },
    );
  }
}

/// Responsive grid view
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.childAspectRatio = 1.0,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Responsive.init(constraints);
        return GridView.builder(
          itemCount: children.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.gridCrossAxisCount,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
          ),
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

/// Responsive row/column switcher
class ResponsiveLayout extends StatelessWidget {
  final Widget desktopBody;
  final Widget tabletBody;
  final Widget mobileBody;

  const ResponsiveLayout({
    super.key,
    required this.desktopBody,
    required this.tabletBody,
    required this.mobileBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Responsive.init(constraints);

        if (Responsive.isDesktop) {
          return desktopBody;
        } else if (Responsive.isTabletPortrait ||
            Responsive.isTabletLandscape) {
          return tabletBody;
        } else {
          return mobileBody;
        }
      },
    );
  }
}
