import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion DataGrid Demo',
      theme:
      ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      home: JsonDataGrid(),
    );
  }
}

class JsonDataGrid extends StatefulWidget {
  @override
  _JsonDataGridState createState() => _JsonDataGridState();
}

class _JsonDataGridState extends State<JsonDataGrid> {
  late _JsonDataGridSource jsonDataGridSource;
  List<_Product> productlist = [];

  Future generateProductList() async {
    var response = await http.get(Uri.parse(
        'https://us-central1-fir-apps-services.cloudfunctions.net/transactions'));
    var list = json.decode(response.body).cast<Map<String, dynamic>>();
    productlist =
    await list.map<_Product>((json) => _Product.fromJson(json)).toList();
    jsonDataGridSource = _JsonDataGridSource(productlist);
    return productlist;
  }

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = ([
      GridColumn(
        columnName: 'name',
        width: 70,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Name',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'date',
        width: 100,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            'Date',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'category',
        width: 95,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            'Category',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'amount',
        width: 95,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Amount',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),

      GridColumn(
        columnName: 'created_at',
        width: 70,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text('Created at'),
        ),
      )
    ]);
    return columns;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter DataGrid Sample'),
      ),
      body: Container(
          child: FutureBuilder(
              future: generateProductList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.hasData
                    ? SfDataGrid(
                    source: jsonDataGridSource, columns: getColumns())
                    : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                );
              })),
    );
  }
}

class _Product {
  factory _Product.fromJson(Map<String, dynamic> json) {
    return _Product(
        id: json['id'],
        accountId: json['account_id'],
        itemId: json['item_id'],
        userId: json['user_id'],
        // userId: DateTime.parse(json['OrderDate']),
        name: json['name'],
        type: json['type'],
        date: DateTime.parse(json['date']),
        category: categoryValues.map[json["category"]],
        amount: json["amount"].toDouble(),
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),


        // shipCity: json['ShipCity'],
        // shipPostelCode: json['ShipPostelCode'],
        // shipCountry: json['ShipCountry']
    );
  }

  _Product(
      {
        this.id,
        this.accountId,
        this.itemId,
        this.userId,
        this.name,
        this.type,
        this.date,
        this.category,
        this.amount,
        this.createdAt,
        this.updatedAt,
      });
  int? id;
  int? accountId;
  int? itemId;
  int? userId;
  String? name;
  Type? type;
  DateTime? date;
  Category? category;
  double? amount;
  DateTime? createdAt;
  DateTime? updatedAt;

  Map<String, dynamic> toJson() => {
    "id": id,
    "account_id": accountId,
    "item_id": itemId,
    "user_id": userId,
    "name": name,
    "type": typeValues.reverse[type],
    "date": date?.toIso8601String(),
    "category": categoryValues.reverse[category],
    "amount": amount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

enum Category { PAYMENT, TRAVEL, TRANSFER, RECREATION, FOOD_AND_DRINK, SHOPS }

final categoryValues = EnumValues({
  "Food and Drink": Category.FOOD_AND_DRINK,
  "Payment": Category.PAYMENT,
  "Recreation": Category.RECREATION,
  "Shops": Category.SHOPS,
  "Transfer": Category.TRANSFER,
  "Travel": Category.TRAVEL
});

enum Type { SPECIAL, PLACE }

final typeValues = EnumValues({
  "place": Type.PLACE,
  "special": Type.SPECIAL
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class _JsonDataGridSource extends DataGridSource {
  _JsonDataGridSource(this.productlist) {
    buildDataGridRow();
  }

  List<DataGridRow> dataGridRows = [];
  List<_Product> productlist = [];

  void buildDataGridRow() {
    dataGridRows = productlist.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
        DataGridCell<DateTime>(
            columnName: 'date', value: dataGridRow.date),
        DataGridCell<String>(
            columnName: 'category', value: dataGridRow.name),
        DataGridCell<double>(
            columnName: 'amount', value: dataGridRow.amount),
        DataGridCell<DateTime>(columnName: 'created_at', value: dataGridRow.createdAt),
      ]);
    }).toList(growable: false);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),

      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          DateFormat('MM/dd/yyyy').format(row.getCells()[1].value).toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),

      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }
}

//
//
// import 'package:flutter/material.dart';
//
// // import 'configurable_datagrid.dart';
// import 'configurable_datagrid.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Configurable DataGrid Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Configurable DataGrid Demo'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ConfigurableDataGrid(
//               apiUrl: 'https://us-central1-fir-apps-services.cloudfunctions.net/transactions',
//               columns: [
//                 {'label': 'Name', 'key': 'name', 'type': 'string'},
//                 {'label': 'Date', 'key': 'date', 'type': 'date'},
//                 {'label': 'Category', 'key': 'category', 'type': 'string'},
//                 {'label': 'Amount', 'key': 'amount', 'type': 'number'},
//                 {'label': 'Created At', 'key': 'created_at', 'type': 'date'},
//               ],
//               jsonPaths: {
//                 'name': '\$.name',
//                 'date': '\$.date',
//                 'category': '\$.category',
//                 'amount': '\$.amount',
//                 'created_at': '\$.created_at'
//               },
//               titleColumnKey: 'name',
//               subtitleColumnKey: 'category',
//
//             ),
//
//           ),
//         ],
//       ),
//     );
//   }
// }
