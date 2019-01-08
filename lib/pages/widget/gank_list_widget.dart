import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/http/gank_api_util.dart' as gankApi;
import 'package:gankcamp_flutter/model/gank_info.dart';

typedef OnItemClickListener = void Function(int position);

class GankListWidget extends StatefulWidget {
  final String type;

  GankListWidget(this.type);

  @override
  State createState() => _GankListWidgetState(
      listener: (position) => print('ItemView click >> $position'), type: type);
}

class _GankListWidgetState extends State<GankListWidget> {
  final String type;
  final OnItemClickListener listener;
  final gankInfoList = <GankInfo>[];

  _GankListWidgetState({@required this.type, this.listener}) {
    print('构造... type = $type');
    _gankList(1);
  }

  @override
  void initState() {
    super.initState();
    print('initState... type = $type');
  }

  void _gankList(int pageNo) async {
    List<GankInfo> res = await gankApi.gankList(type, pageNo, 20);
    if (null != res && res.isNotEmpty) {
      setState(() {
        gankInfoList.clear();
        gankInfoList.addAll(res);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: PageStorageKey<String>(type),
      itemCount: gankInfoList.length,
      itemBuilder: (context, index) => InkWell(
            child: _ItemView(index, gankInfoList[index]),
            onTap: () =>
                null != listener ? listener(index) : print('Null listener'),
          ),
    );
  }
}

class _ItemView extends StatelessWidget {
  final int pos;
  final GankInfo gankInfo;

  _ItemView(this.pos, this.gankInfo);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(25),
          child: Icon(Icons.restaurant, color: Colors.blue),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(gankInfo.desc),
              Text(gankInfo.who),
            ],
          ),
        )
      ],
    );
  }
}
