import 'package:flutter/material.dart';

class TableTitle extends StatelessWidget {
  final String title;

  const TableTitle({
    Key key, 
    this.title = ""
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Stack(
        children: [
          Container(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight.withOpacity(0.05),
                    fontSize: 80,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1,1)
                      )
                    ]
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}