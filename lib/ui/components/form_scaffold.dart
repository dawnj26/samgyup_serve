import 'package:flutter/material.dart';

class FormScaffold extends StatelessWidget {
  const FormScaffold({
    super.key,
    this.body,
    this.appBar,
    this.bottomNavigationBar,
  });

  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBar,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
