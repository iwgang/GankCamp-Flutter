import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/http/gank_api_manager.dart';
import 'package:gankcamp_flutter/model/gank_info.dart';

typedef OnItemClickListener = void Function(int position);

class GankListWidget extends StatefulWidget {
  final String type;

  GankListWidget(this.type);

  @override
  State createState() => _GankListWidgetState();
}

class _GankListWidgetState extends State<GankListWidget>
    with AutomaticKeepAliveClientMixin {
  List<GankInfo> gankInfoList;

  @override
  void initState() {
    super.initState();
    _gankList(1);
  }

  void _gankList(int pageNo) async {
    List<GankInfo> res = await GankApiManager.gankList(widget.type, pageNo, 20);
    if (null != res && res.isNotEmpty) {
      setState(() {
        gankInfoList = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gankInfoList?.length ?? 0,
      itemBuilder: (context, index) => InkWell(
            child: _ItemView(index, gankInfoList[index]),
            onTap: () => print('All listener'),
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
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
