import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestRefresh extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TestRefreshState();
}

class TestRefreshState extends State<TestRefresh> {
  bool isPerformingRequest = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("show Feed Data"),
      ),
      //...
      body: boxAdapterWidget(context),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  List<Data> _dataList = [];

  Widget boxAdapterWidget(context) {
    if (_dataList.length == 0) {
      _refresh();
      return Center(child: CircularProgressIndicator());
    }

    return Container(
        child: RefreshIndicator(
      child: ListView.builder(
        itemCount: _dataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: new Text("Number $index"),
            subtitle: AuctionListItemWidget(
              data: _dataList[index],
            ),
          );
        },
        physics: BouncingScrollPhysics(),
      ),
      onRefresh: () {
        return _refresh();
      },
    ));
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      List<Data> dataList = [];

      for (int i = 0; i < 50; i++) {
        dataList.add(Data.fromParam(index: i, num: 500));
      }

      if (!mounted) return;
      setState(() {
        _dataList = dataList;
        _startTimer();
      });
    });

    return;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  Timer _timer;

  _startTimer() {
    //https://www.jianshu.com/p/f7a9b8c84d26
    if (_timer != null && _timer.isActive) return;

    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      for (int i = 0; i < _dataList.length; i++) {
        if (i == 0) debugPrint("_dataList[i].num  = ${_dataList[i].num}");
        _dataList[i].num--;
      }
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }
}

class Data {
  int index;
  int num;

  Data.fromParam({this.index, this.num});
}

class AuctionListItemWidget extends StatefulWidget {
  final Data data;

  AuctionListItemWidget({Key key, this.data});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new AuctionListItemState(data);
  }
}

class AuctionListItemState extends State<AuctionListItemWidget> {
  final Data data;

  AuctionListItemState(this.data);

  String countDownDes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countDownDes = "timer: ${data.num}";
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return new Text(
      countDownDes,
      style: TextStyle(color: Colors.lightBlue),
    );
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  Timer _timer;

  _startTimer() {
    if (_timer != null && _timer.isActive) return;

    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        countDownDes = "timer: ${data.num}";
      });
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }
}
