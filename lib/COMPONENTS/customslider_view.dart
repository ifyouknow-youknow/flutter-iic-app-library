import 'package:flutter/material.dart';

class CustomSliderView extends StatefulWidget {
  @override
  _CustomSliderViewState createState() => _CustomSliderViewState();
}

class _CustomSliderViewState extends State<CustomSliderView> {
  double _currentValue = 33;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.grey[400]!],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      '${_currentValue.toInt()} min',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 70,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 20,
                          elevation: 5,
                        ),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 25),
                        activeTrackColor: Colors.transparent,
                        inactiveTrackColor: Colors.transparent,
                        thumbColor: Colors.white,
                        overlayColor: Colors.grey.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: _currentValue,
                        min: 0,
                        max: 60,
                        onChanged: (value) {
                          setState(() {
                            _currentValue = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
