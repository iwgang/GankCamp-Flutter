import 'package:flutter/material.dart';

typedef OnSelectRecDateListener = void Function(String date);

class SelectRecDateWidget extends StatelessWidget {
  final OnSelectRecDateListener listener;
  final List<String> _recDateList;

  SelectRecDateWidget(this._recDateList, this.listener);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _recDateList?.length ?? 0,
      itemBuilder: (context, index) => InkWell(
            child: _ItemView(_recDateList[index]),
            onTap: () {
              listener(_recDateList[index]);
              Navigator.of(context).pop();
            },
          ),
    );
  }
}

class _ItemView extends StatelessWidget {
  final String recDate;

  _ItemView(this.recDate);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.0,
            color: Color(0xffe5e5e5),
          ),
        ),
      ),
      child: Center(
        child: Text(
          recDate,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }
}
