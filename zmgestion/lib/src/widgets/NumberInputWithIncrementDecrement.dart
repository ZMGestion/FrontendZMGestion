import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInputWithIncrementDecrement extends StatefulWidget {
  final String labelText;
  final Function(int) onChanged;

  const NumberInputWithIncrementDecrement({
    Key key, 
    this.labelText = "",
    this.onChanged
  }) : super(key: key);

  @override
  _NumberInputWithIncrementDecrementState createState() =>
      _NumberInputWithIncrementDecrementState();
}

class _NumberInputWithIncrementDecrementState
    extends State<NumberInputWithIncrementDecrement> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = "0"; // Setting the initial value for the field.
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              labelText: widget.labelText
            ),
            textAlign: TextAlign.center,
            controller: _controller,
            onChanged: (strValue){  
              if(widget.onChanged != null){
                int currentValue = int.parse(_controller.text);
                widget.onChanged(currentValue);
              }
            },
            keyboardType: TextInputType.numberWithOptions(
              decimal: false,
              signed: true,
            ),
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
          ),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.2,
                    ),
                  ),
                ),
                child: InkWell(
                  child: Icon(
                    Icons.arrow_drop_up,
                    size: 22.0,
                  ),
                  onTap: () {
                    int currentValue = int.parse(_controller.text);
                    setState(() {
                      currentValue++;
                      _controller.text = (currentValue)
                          .toString(); // incrementing value
                    });
                  },
                ),
              ),
              InkWell(
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 22.0,
                ),
                onTap: () {
                  int currentValue = int.parse(_controller.text);
                  setState(() {
                    currentValue--;
                    _controller.text =
                        (currentValue > 0 ? currentValue : 0)
                            .toString(); // decrementing value
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}