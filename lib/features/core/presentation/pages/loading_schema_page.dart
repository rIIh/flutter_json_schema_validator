import 'package:flutter/material.dart';

class LoadingSchemaPage<T> extends StatefulWidget {
  final Future<T> future;

  const LoadingSchemaPage({super.key, required this.future});

  @override
  State<LoadingSchemaPage> createState() => _LoadingSchemaPageState();
}

class _LoadingSchemaPageState<T> extends State<LoadingSchemaPage<T>> {
  @override
  void initState() {
    waitForFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Future<void> waitForFuture() async {
    await widget.future;
    await Future.microtask(() => mounted ? Navigator.of(context).pop() : null);
  }
}
