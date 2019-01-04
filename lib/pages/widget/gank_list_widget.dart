import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/model/building.dart';

typedef OnItemClickListener = void Function(int position);

class GankListWidget extends StatefulWidget {
  final String type;

  GankListWidget(this.type);

  @override
  State createState() {
    var buildings = <Building>[];
    for (var i = 0; i < 100; i++) {
      buildings.add(Building(
          i % 2 == 0 ? BuildingType.restaurant : BuildingType.theater,
          '$type _ 我是标题_$i',
          '我是地址阿 >> $i'));
    }
    return _GankListWidgetState(
        buildings: buildings,
        listener: (position) => print('ItemView click >> $position'),
        type: type);
  }
}

class _GankListWidgetState extends State<GankListWidget> {
  final List<Building> buildings;
  final OnItemClickListener listener;
  final String type;

  _GankListWidgetState({@required this.buildings, this.listener, this.type});

  @override
  Widget build(BuildContext context) {
    print('build $context');
    return ListView.builder(
      key: PageStorageKey<String>(type),
      itemCount: buildings.length,
      itemBuilder: (context, index) => InkWell(
            child: _ItemView(index, buildings[index]),
            onTap: () =>
                null != listener ? listener(index) : print('Null listener'),
          ),
    );
  }
}

class _ItemView extends StatelessWidget {
  final int pos;
  final Building building;

  _ItemView(this.pos, this.building);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(15),
          child: Icon(
              building.type == BuildingType.restaurant
                  ? Icons.restaurant
                  : Icons.theaters,
              color: Colors.blue),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(building.title),
              Text(building.address),
            ],
          ),
        )
      ],
    );
  }
}
