import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class DefaultShimmer extends StatefulWidget {

  @override
  _DefaultShimmerState createState() => _DefaultShimmerState();
}

class _DefaultShimmerState extends State<DefaultShimmer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        double fullWidth = constraints.biggest.width;
        return Shimmer.fromColors(
          baseColor: Theme.of(context).backgroundColor.withOpacity(0.3),
          highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
          period: Duration(milliseconds: 1250),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: fullWidth-24,
                      height: SizeConfig.blockSizeVertical*7.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).backgroundColor.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical*2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: fullWidth*0.4-12,
                      height: SizeConfig.blockSizeVertical*7.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).backgroundColor.withOpacity(0.9),
                      ),
                    ),
                    Container(
                      width: fullWidth*0.55-12,
                      height: SizeConfig.blockSizeVertical*7.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).backgroundColor.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical*2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: fullWidth*0.55-12,
                      height: SizeConfig.blockSizeVertical*15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).backgroundColor.withOpacity(0.9),
                      ),
                    ),
                    Container(
                      width: fullWidth*0.4-12,
                      height: SizeConfig.blockSizeVertical*15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).backgroundColor.withOpacity(0.9),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
