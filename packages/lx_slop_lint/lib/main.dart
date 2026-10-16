import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/rules/default_theme.dart';
import 'src/rules/emoji_icon.dart';
import 'src/rules/framework_color.dart';
import 'src/rules/hardcoded_color.dart';
import 'src/rules/hardcoded_spacing.dart';
import 'src/rules/hardcoded_elevation.dart';
import 'src/rules/hardcoded_font_size.dart';
import 'src/rules/hardcoded_radius.dart';
import 'src/rules/linear_motion.dart';
import 'src/rules/orientation_lock.dart';

/// The analyzer plugin entry point. Referenced by the generated analysis
/// server code as the top-level `plugin` variable.
final plugin = LxSlopPlugin();

class LxSlopPlugin extends Plugin {
  @override
  String get name => 'lx_slop_lint';

  @override
  void register(PluginRegistry registry) {
    registry.registerWarningRule(HardcodedColorRule());
    registry.registerWarningRule(FrameworkColorRule());
    registry.registerWarningRule(DefaultThemeRule());
    registry.registerWarningRule(HardcodedSpacingRule());
    registry.registerWarningRule(HardcodedRadiusRule());
    registry.registerWarningRule(HardcodedFontSizeRule());
    registry.registerWarningRule(HardcodedElevationRule());
    registry.registerWarningRule(OrientationLockRule());
    registry.registerWarningRule(LinearMotionRule());
    registry.registerWarningRule(EmojiIconRule());
  }
}
