import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../../generated/assets.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_l10n.dart';

/// A class that represents send button widget.
class SendButton extends StatelessWidget {
  /// Creates send button widget.
  const SendButton({
    super.key,
    required this.onPressed,
    this.padding = EdgeInsets.zero,
  });

  /// Callback for send button tap event.
  final VoidCallback onPressed;

  /// Padding around the button.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Semantics(
    label: InheritedL10n.of(context).l10n.sendButtonAccessibilityLabel,
    child: IconButton(
      icon: InheritedChatTheme.of(context).theme.sendButtonIcon ??
           ImageMultiType(
            url: Assets.svgSend,
            color: InheritedChatTheme.of(context).theme.inputTextColor,

          ),
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 15.0).w,
      splashRadius: 24,
      tooltip:
          InheritedL10n.of(context).l10n.sendButtonAccessibilityLabel,
    ),
  );
}
