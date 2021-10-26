
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class CustomStepper extends StatefulWidget {
  CustomStepper(
      {@required this.value,
      @required this.maxValue,
      @required this.onChanged});

  int value;
  final int maxValue;
  ValueChanged<dynamic> onChanged;

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      width: 128,
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onLongPress: (){
              setState(() {
                  widget.value=1;
                });
                widget.onChanged(1);
            },
            child: IconButton(
              icon: Icon(Icons.remove, size: 22),
              onPressed: () async {
                if (widget.value > 1) {
                  setState(() {
                    widget.value--;
                  });
                  widget.onChanged(widget.value);
                }
              },
            ),
          ),
          Container(
            width: 32,
            child: Text(
              '${widget.value}',
              style: TextStyle(
                fontSize: 22 * 0.8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onLongPress: (){
              setState(() {
                  widget.value=widget.maxValue;
                });
                widget.onChanged(widget.maxValue);
            },
            child: IconButton(
              icon: Icon(Icons.add, size: 22),
              onPressed: () async {
                if(widget.value<widget.maxValue){
                  setState(() {
                  widget.value++;
                });
                widget.onChanged(widget.value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
