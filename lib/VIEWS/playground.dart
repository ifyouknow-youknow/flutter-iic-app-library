import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/accordion_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/bargraph_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/blur_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/button_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/calendar_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/checkbox_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/circleprogress_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/customslider_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/dropdown_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/fade_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/iconbutton_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/loading_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/main_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/map_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/padding_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/pager_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/pill_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/progress_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/qrcode_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/roundedcorners_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/segmented_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/slider_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/switch_view.dart';
import 'package:nothing_bagel_app_template/COMPONENTS/text_view.dart';
import 'package:nothing_bagel_app_template/FUNCTIONS/colors.dart';
import 'package:nothing_bagel_app_template/FUNCTIONS/date.dart';
import 'package:nothing_bagel_app_template/FUNCTIONS/media.dart';
import 'package:nothing_bagel_app_template/FUNCTIONS/misc.dart';
import 'package:nothing_bagel_app_template/FUNCTIONS/recorder.dart';
import 'package:nothing_bagel_app_template/FUNCTIONS/server.dart';
import 'package:nothing_bagel_app_template/MODELS/coco.dart';
import 'package:nothing_bagel_app_template/MODELS/constants.dart';
import 'package:nothing_bagel_app_template/MODELS/DATAMASTER/datamaster.dart';
import 'package:nothing_bagel_app_template/MODELS/firebase.dart';
import 'package:nothing_bagel_app_template/MODELS/screen.dart';
import 'package:record/record.dart';

class PlaygroundView extends StatefulWidget {
  final DataMaster dm;
  const PlaygroundView({super.key, required this.dm});

  @override
  State<PlaygroundView> createState() => _PlaygroundViewState();
}

class _PlaygroundViewState extends State<PlaygroundView> {
  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
      const PaddingView(
        child: Center(
          child: TextView(
            text: "The Bagel rules Nothing.",
            size: 23,
            weight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      ButtonView(
          child: const PillView(
            child: TextView(
              text: 'Press Me',
            ),
          ),
          onPress: () {
            setState(() {
              widget.dm.praiseTheBagel();
            });
          }),
      const SizedBox(
        height: 10,
      ),
      CustomSliderView()
    ]);
  }
}
