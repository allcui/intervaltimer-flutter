import 'dart:developer';

import 'package:countdown_timer/model/slider_item.dart';
import 'package:countdown_timer/model/timer_profile.dart';
import 'package:countdown_timer/screen/interval_timer.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({
    this.sliderItem,
    this.width,
    this.callback,
    this.count,
  });

  final SliderItems sliderItem;
  final double width;
  final void Function(SliderItems, int) callback;
  final int count;
  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  static final Map<SliderItems, SliderItem> sliderItems = {
    SliderItems.warmUp: SliderItem(
      item: SliderItems.warmUp,
      textDescription: 'Warm Up Duration(MM:SS):',
      divisions: IntervalTimer.maxWarmUpDurationInSeconds ~/ 15,
      maxValue: IntervalTimer.maxWarmUpDurationInSeconds.toDouble(),
    ),
    SliderItems.work: SliderItem(
      item: SliderItems.work,
      textDescription: 'Work Duration(MM:SS):',
      divisions: IntervalTimer.maxWorkDurationInSeconds ~/ 15,
      maxValue: IntervalTimer.maxWorkDurationInSeconds.toDouble(),
    ),
    SliderItems.rest: SliderItem(
      item: SliderItems.rest,
      textDescription: 'Rest Duration(MM:SS):',
      divisions: IntervalTimer.maxRestDurationInSeconds ~/ 15,
      maxValue: IntervalTimer.maxRestDurationInSeconds.toDouble(),
    ),
    SliderItems.coolDown: SliderItem(
      item: SliderItems.coolDown,
      textDescription: 'Cooldown Duration(MM:SS):',
      divisions: IntervalTimer.maxCoolDownDurationInSeconds ~/ 15,
      maxValue: IntervalTimer.maxCoolDownDurationInSeconds.toDouble(),
    ),
    SliderItems.setCount: SliderItem(
      item: SliderItems.setCount,
      textDescription: 'Sets of Intervals',
      maxValue: IntervalTimer.maxSetCount.toDouble(),
      isDuration: false,
    ),
  };
  
  int _count;

  @override
  void initState() {
    _count = widget.count;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final double width = widget.width;
    final SliderItem sliderItem = sliderItems[widget.sliderItem];
    return Row(
      children: <Widget>[
        Container(
          width: width * 0.4,
          child: Text(sliderItem.textDescription),
        ),
        Container(
          width: width * 0.5,
          child: Slider(
            divisions: sliderItem.divisions,
            value: _count.toDouble(),
            max: sliderItem.maxValue,
            onChanged: (newCount) => _onChanged(newCount),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          width: width * 0.1,
          child: Text((sliderItem.isDuration) ? durationToString(_count) : _count.toString()),
        )
      ],
    );
  }

  void _onChanged(double newCount) {
    {setState(() {_count = newCount.toInt();});}
    widget.callback(widget.sliderItem, newCount.toInt());
  }


  String durationToString(int durationInSeconds){
    final duration = Duration(seconds: durationInSeconds);
    final minutes = duration.inMinutes;
    final seconds = durationInSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }
}
