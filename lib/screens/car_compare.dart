import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:carmobileapplication/screens/community_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'car_controller.dart';
import 'car_selected.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CompareCarScreen extends StatefulWidget {
  const CompareCarScreen({Key? key}) : super(key: key);

  @override
  State<CompareCarScreen> createState() => _CompareCarScreenState();
}

/*Future<String> suggestCar (String carName) async{
  var response = await http.post(Uri.parse('http://192.168.0.152:8000/'),
  body: jsonDecode(<String, String) {
    "carName": carName
  });
}*/

class _CompareCarScreenState extends State<CompareCarScreen> {
  //List<Employee> employees = <Employee>[];
  //late EmployeeDataSource employeeDataSource;
  List<CarDataModel> carsList = <CarDataModel>[];
  late CarDataSource carDataSource;
  bool visibleFA = false;
  int cellIndex = 0;
  String tempName = '';
  final DataGridController _dataGridController = DataGridController();

  /*Future<http.Response> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
  if (response.statusCode == 200){
    return response.body;
  }
}*/

  @override
  void initState() {
    super.initState();
    //carsList = getEmployeeData();
    carDataSource = CarDataSource(carData: carsList);
  }

  @override
  Widget build(BuildContext context) {
    final addCarButton = Material(
      elevation: 5,
      //borderRadius: BorderRadius.circular(30),
      color: Colors.lightGreen[100],
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          //minWidth: MediaQuery.of(context).size.width,
          minWidth: 200.0,
          onPressed: () async {
            if (carsList.isEmpty) {
              var cartemp = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CarControllerScreen('')));
              if (cartemp != '') {
                CarDataModel carsData = cartemp;
                setState(() {
                  //carsList = [...carsList,carsData];
                  //CarDataModel tempData = CarDataModel.fromMap(carsData);
                  carsList.add(carsData);
                  carDataSource = CarDataSource(carData: carsList);
                });
              } else {
                return;
              }

              //print(carsData.brand);
              print(carsList[0].name);
            } else {
              var cartemp = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      CarControllerScreen(carsList[carsList.length - 1].name)));
              if (cartemp != '') {
                CarDataModel carsData = cartemp;
                setState(() {
                  //carsList = [...carsList,carsData];
                  //CarDataModel tempData = CarDataModel.fromMap(carsData);
                  carsList.add(carsData);
                  carDataSource = CarDataSource(carData: carsList);
                });
              } else {
                return;
              }

              //print(carsData.brand);
              print(carsList[0].name);
            }
          },
          child: const Text(
            "Add Car",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, color: Colors.black),
          )),
    );

    /*final testCarButton = Material(
                elevation: 5,
                //borderRadius: BorderRadius.circular(30),
                color: Colors.lightGreen[100],
                child: MaterialButton(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  //minWidth: MediaQuery.of(context).size.width,
                  minWidth: 200.0,
                  onPressed: () {
                    print(carsList);
                    print(carsList[0].name);
                 
                  },
                  child: const Text(
                    "Add Car",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25, color: Colors.black
                      ),
                    )
                  ),
              );*/
    return Scaffold(
      appBar: AppBar(title: const Text('Car Comparison Page')),
      body: Column(children: [
        const SizedBox(height: 10),
        addCarButton,
        const SizedBox(height: 10),
        //testCarButton,
        Container(
          height: 1.0,
          color: Colors.black,
        ),

        Expanded(
          child: SfDataGridTheme(
            data: SfDataGridThemeData(
                headerColor: Colors.indigo[100],
                gridLineColor: Colors.black,
                gridLineStrokeWidth: 1.0),
            child: SfDataGrid(
              frozenColumnsCount: 1,
              source: carDataSource,
              columnWidthMode: ColumnWidthMode.auto,
              allowSwiping: true,

              swipeMaxOffset: 100,
              selectionMode: SelectionMode.single,
              navigationMode: GridNavigationMode.cell,
              isScrollbarAlwaysShown: true,

              allowSorting: true,
              //allowMultiColumnSorting: true,
              allowTriStateSorting: true,

              onQueryRowHeight: (details) {
                return details.getIntrinsicRowHeight(details.rowIndex);
              },
              onSwipeStart: (details) {
                if (details.swipeDirection ==
                    DataGridRowSwipeDirection.startToEnd) {
                  details.setSwipeMaxOffset(0);
                } else if (details.swipeDirection ==
                    DataGridRowSwipeDirection.endToStart) {
                  details.setSwipeMaxOffset(90);
                }
                return true;
              },

              endSwipeActionsBuilder:
                  (BuildContext context, DataGridRow row, int rowIndex) {
                return GestureDetector(
                    onTap: () {
                      carDataSource._carData.removeAt(rowIndex);
                      carsList.remove(carsList[rowIndex]);
                      carDataSource.updateDataGridSource();
                    },
                    child: Container(
                        color: Colors.redAccent,
                        child: const Center(
                          child: Icon(Icons.delete),
                        )));
              },

              //columnWidthMode: ColumnWidthMode.auto,
              //defaultColumnWidth: 100,
              columns: <GridColumn>[
                GridColumn(
                    //columnWidthMode: ColumnWidthMode.auto,
                    maximumWidth: 100,
                    columnName: 'id',
                    label: Container(
                        //padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Name',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ))),
                GridColumn(
                    columnName: 'name',
                    label: Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Price'))),
                GridColumn(
                    //columnWidthMode: ColumnWidthMode.auto,
                    //width: 150,
                    columnName: 'designation',
                    label: Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Year',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ))),
                GridColumn(
                    //columnWidthMode: ColumnWidthMode.auto,
                    columnName: 'salary',
                    label: Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Engine'))),
                GridColumn(
                    //columnWidthMode: ColumnWidthMode.fitByColumnName,
                    width: 150,
                    columnName: 'salarys',
                    label: Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Horsepower'))),
                GridColumn(
                    columnName: 'salaryss',
                    label: Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Body'))),
                GridColumn(
                    columnName: 'salarysss',
                    label: Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Safety'))),
              ],
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              controller: _dataGridController,
              onCellTap: (DataGridCellTapDetails details) async {
                if (visibleFA && cellIndex == details.rowColumnIndex.rowIndex) {
                  setState(() {
                    visibleFA = false;
                    cellIndex = 0;
                  });
                } else {
                  setState(() {
                    visibleFA = true;
                    cellIndex = details.rowColumnIndex.rowIndex;
                    //tempName = '${_dataGridController.currentCell}';
                    if (cellIndex != 0) {
                      tempName = carsList[cellIndex - 1].name;
                    }
                  });
                }
              },
            ),
          ),
        ),
      ]),
      floatingActionButton: Visibility(
        visible: visibleFA,
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(Icons.book),
          onPressed: () {
            print(carsList[cellIndex - 1].name);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CommunityScreen(
                      carsList[cellIndex - 1].name,
                    )));
          },
        ),
      ),
    );
  }

  List<CarDataModel> getEmployeeData() {
    return [
      //Employee(10002, 'Kathryn', 'Manager', 30000, 10000, 10000),
      //Employee(10003, 'Lara', 'Developer', 15000, 10000, 10000),
      //Employee(10004, 'Michael', 'Designer', 15000, 10000, 10000),
      //Employee(10005, 'Martin', 'Developer', 15000, 10000, 10000),
      //Employee(10006, 'Newberry', 'Developer', 15000, 10000, 10000),
      //Employee(10007, 'Balnc', 'Developer', 15000, 10000, 10000),
      //Employee(10008, 'Perry', 'Developer', 15000, 10000, 10000),
      //Employee(10009, 'Gable', 'Developer', 15000, 10000, 10000),
      //Employee(10010, 'Grimes', 'Developer', 15000, 10000, 10000)
    ];
  }
}
/*class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.salary, this.salarys, this.salaryss);

  /// Id of an employee.
  final int id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;

  /// Salary of an employee.
  final int salary;

  final int salarys;

  final int salaryss;
}*/

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class CarDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  CarDataSource({required List<CarDataModel> carData}) {
    _carData = carData
        .map<DataGridRow>((data) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'id', value: data.name),
              DataGridCell<num>(columnName: 'name', value: data.price),
              DataGridCell<String>(columnName: 'designation', value: data.year),
              DataGridCell<String>(columnName: 'salary', value: data.engine),
              DataGridCell<String>(columnName: 'salarys', value: data.power),
              DataGridCell<String>(columnName: 'salaryss', value: data.body),
              DataGridCell<String>(columnName: 'salarysss', value: data.safety),
            ]))
        .toList();
  }

  List<DataGridRow> _carData = [];

  @override
  List<DataGridRow> get rows => _carData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataCell) {
      TextStyle? setTextStyle() {
        if (dataCell.columnName == 'id') {
          return const TextStyle(color: Colors.blue);
        } else {
          return null;
        }
      }

      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(dataCell.value.toString(), style: setTextStyle()),
      );
    }).toList());
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
