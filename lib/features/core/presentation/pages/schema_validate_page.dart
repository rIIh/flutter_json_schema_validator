// ignore_for_file: implementation_imports

import 'dart:convert' hide json;

import 'package:code_text_field/code_text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/json.dart';
import 'package:json_schema/json_schema.dart';
import 'package:json_schema/src/json_schema/models/validation_results.dart';
import 'package:json_schema_validate/features/core/presentation/pages/loading_schema_page.dart';

class SchemaValidatePage extends StatefulWidget {
  final String? schema;

  const SchemaValidatePage({super.key, required this.schema});

  @override
  State<SchemaValidatePage> createState() => _SchemaValidatePageState();
}

class _SchemaValidatePageState extends State<SchemaValidatePage> {
  late final CodeController _schemaController = CodeController(language: json)
    ..addListener(() {
      setState(() {
        try {
          _schema = JsonSchema.create(_schemaController.text);
        } catch (e) {
          if (isRemote) {
            isRemote = false;
            _schemaController.text = '';
          }
        }
      });
    });
  late final CodeController _jsonController = CodeController(language: json)..addListener(() => setState(() {}));

  JsonSchema? _schema;
  late bool isRemote = widget.schema != null;

  @override
  void initState() {
    if (widget.schema != null) {
      Future.microtask(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoadingSchemaPage(future: loadGist())));
      });
    }

    super.initState();
  }

  Future<void> loadGist() async {
    try {
      final response = await Dio().get(widget.schema!);
      _schemaController.text = response.data;
    } catch (e) {
      setState(() => isRemote = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ValidationResults? result;
    String? error;
    try {
      result = _schema?.validate(
        jsonEncode(jsonDecode(_jsonController.text)),
        parseJson: true,
      );
    } catch (e) {
      error = e.toString();
    }

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CodeTheme(
              data: const CodeThemeData(styles: a11yLightTheme),
              child: Column(
                children: [
                  if (!isRemote)
                    Expanded(
                      child: SectionWidget(
                        child: CodeField(
                          background: Colors.transparent,
                          controller: _schemaController,
                          maxLines: null,
                          expands: true,
                        ),
                      ),
                    ),
                  Expanded(
                    child: SectionWidget(
                      child: CodeField(
                        background: Colors.transparent,
                        controller: _jsonController,
                        maxLines: null,
                        expands: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SectionWidget(
              child: ListView(
                children: [
                  if (error != null)
                    ListTile(
                      title: Text(error),
                      textColor: Colors.red,
                    ),
                  for (final error in result?.errors ?? <ValidationError>[])
                    ListTile(
                      title: Text(
                        '\$${error.instancePath?.replaceAllMapped(RegExp(r'/(\d+)/'), (match) => '[${match.group(1)}].').replaceAll('/', '.')}: ${error.message}',
                      ),
                      textColor: Colors.red,
                    ),
                  if (result != null && result.isValid && error == null)
                    const ListTile(
                      title: Text("JSON is valid!"),
                      textColor: Colors.green,
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  final Widget child;

  const SectionWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
