import 'package:connected/app/common/global_widget.dart';
import 'package:flutter/material.dart';

class HomePageLS extends StatelessWidget {
  const HomePageLS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Flexible(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(10),
                color: Colors.red,
              )),
          Flexible(
              flex: 5,
              child: Container(
                color: Colors.amberAccent,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Align(
                    alignment: Alignment.center,
                    child: CustomGrid(
                      children: [
                        AspectRatio(aspectRatio: 1, child: Text("1")),
                        AspectRatio(aspectRatio: 1, child: Text("1")),
                        AspectRatio(aspectRatio: 1, child: Text("1")),
                        AspectRatio(aspectRatio: 1, child: Text("1")),
                      ],
                    )),
              )),
          Flexible(
              flex: 3,
              child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Container(
                    color: Colors.red,
                  ))),
        ],
      ),
    );
  }
}
