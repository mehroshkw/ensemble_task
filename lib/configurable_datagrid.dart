import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ConfigurableDataGrid extends StatefulWidget {
  final String apiUrl;
  final List<Map<String, dynamic>> columns;
  final Map<String, String> jsonPaths;
  final String titleColumnKey;
  final String subtitleColumnKey;

  ConfigurableDataGrid({
    required this.apiUrl,
    required this.columns,
    required this.jsonPaths,
    required this.titleColumnKey,
    required this.subtitleColumnKey,
  });

  @override
  _ConfigurableDataGridState createState() => _ConfigurableDataGridState();
}

class _ConfigurableDataGridState extends State<ConfigurableDataGrid> {
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  // Future<void> _getData() async {
  //   final response = await http.get(Uri.parse(widget.apiUrl));
  //   final jsonData = json.decode(response.body);
  //   print('jsonData: $jsonData');
  //
  //   final data = <Map<String, dynamic>>[];
  //   if (jsonData != null) {
  //     for (final item in jsonData) {
  //       final row = <String, dynamic>{};
  //       for (final column in widget.columns) {
  //         final key = column['key']!;
  //         final jsonPath = widget.jsonPaths[key]!;
  //         final value = jsonPath.split('.').fold(item, (dynamic value, element) => value[element]);
  //         row[key] = value;
  //       }
  //       data.add(row);
  //     }
  //   }
  //   print('data: $data');
  //
  //   setState(() {
  //     _data = data;
  //   });
  // }

  Future<void> _getData() async {
    final response = await http.get(Uri.parse(widget.apiUrl));
    final jsonData = json.decode(response.body);
    print('jsonData: $jsonData');

    final data = <Map<String, dynamic>>[];
    if (jsonData is List) {
      for (final item in jsonData) {
        final row = <String, dynamic>{};
        for (final column in widget.columns) {
          final key = column['key']!;
          final jsonPath = widget.jsonPaths[key]!;
          final value = jsonPath.split('.').fold(item, (dynamic value, element) => value[element]);
          row[key] = value;
        }
        data.add(row);
      }
    }
    print('data: $data');

    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          for (final column in widget.columns)
            DataColumn(
              label: Text(column['label']!),
            ),
        ],
        rows: [
          for (final row in _data)
            DataRow(
              cells: [
                for (final column in widget.columns)
                  DataCell(
                    Text(row[column['key']]?.toString() ?? ''),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
