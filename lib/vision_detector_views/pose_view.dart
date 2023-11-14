import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'body_view/assembly.dart';
import 'pose_transform.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'dart:io';

class pose_view extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<pose_view> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  @override
  void initState() {
    global.pose_tranform();
    super.initState();
  }

  @override
  void dispose() async {
    if(global.Det.endDetector){
    }
    _canProcess = false;
    _poseDetector.close();
    global.Det.timerbool = false; //關閉timer
    super.dispose();
  }
  @override

  final inputImage = InputImage.fromFilePath("assets/images/pose.jpeg");

  Widget build(BuildContext context) {
    processImage(inputImage);
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          height: 120.0,
          width: 120.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'pose.jpg'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      if (!global.Det.changeUI) ...[
          Positioned(
              //倒數計時
              top: 180,
              child: Container(
                height: 120,
                width: 100,
                child: AutoSizeText(
                  "${global.Det.mathText}",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    backgroundColor: Colors.transparent,
                    fontSize: 100,
                    color: Colors.amber,
                    inherit: false,
                  ),
                ),
              )),
          Positioned(
            //開始前提醒視窗
            bottom: 100.0,
            child: Container(
              width: 1000,
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                color: Color.fromARGB(132, 255, 255, 255),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: AutoSizeText(
                global.Det.mindText,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: TextStyle(
                  backgroundColor: Colors.transparent,
                  fontSize: 25,
                  color: Colors.black,
                  height: 1.2,
                  inherit: false,
                ),
              ),
            ),
          ).animate().slide(duration: 500.ms),
          if (global.Det.buttom_false)
            Positioned(
                //復健按鈕
                bottom: 15.0,
                child: Container(
                  height: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      padding: EdgeInsets.all(15),
                      backgroundColor: Color.fromARGB(250, 255, 190, 52),
                    ),
                    child: AutoSizeText("Start!",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                        )),
                    onPressed: () {
                      global.Det.startd();
                    },
                  ),
                )).animate().slide(duration: 500.ms),
        ] else if (!global.Det.endDetector) ...[
          Positioned(
            //計數器UI
            bottom: 10,
            right: -10,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: new BoxDecoration(
                color: Color.fromARGB(250, 65, 64, 64),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20),
                  right: Radius.circular(0),
                ),
              ),
              width: 100,
              height: 90,
              child: AutoSizeText(
                "次數\n${global.Det.posecounter}/${global.Det.poseTarget}",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(250, 255, 212, 39),
                  height: 1.2,
                  inherit: false,
                ),
              ),
            ),
          ),
          if (global.Det.timerui)
            Positioned(
              //計時器UI
              bottom: 10,
              left: -10,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: new BoxDecoration(
                  color: Color.fromARGB(250, 65, 64, 64),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(0),
                    right: Radius.circular(20),
                  ),
                ),
                width: 100,
                height: 90,
                child: AutoSizeText(
                  "秒數\n${global.Det.posetimecounter}/${global.Det.posetimeTarget}",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(250, 255, 212, 39),
                    height: 1.2,
                    inherit: false,
                  ),
                ),
              ),
            ),
          if ((global.posenumber >= 18 && global.posenumber <= 21) ||
              (global.posenumber >= 42 && global.posenumber <= 45)) ...[
            Positioned(
              //提醒視窗
              left: 0,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: new BoxDecoration(
                  color: Color.fromARGB(250, 65, 64, 64),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(30),
                    right: Radius.circular(30),
                  ),
                ),
                width: 90,
                height: 300,
                child: AutoSizeText(
                  "${global.Det.orderText}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                    height: 1.2,
                    inherit: false,
                  ),
                ),
              ),
            ).animate().slide(duration: 500.ms),
          ] else ...[
            Positioned(
              //提醒視窗
              bottom: 100,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: new BoxDecoration(
                  color: Color.fromARGB(250, 65, 64, 64),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(30),
                    right: Radius.circular(30),
                  ),
                ),
                width: 220,
                height: 100,
                child: AutoSizeText(
                  "${global.Det.orderText}",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    height: 1.3,
                    inherit: false,
                  ),
                ),
              ),
            ).animate().slide(duration: 500.ms),
          ]
        ],
        if (global.Det.endDetector)
          Positioned(
            //退出視窗
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(40),
                  decoration: new BoxDecoration(
                    color: Color.fromARGB(200, 65, 64, 64),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  width: 300,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        "恭喜完成!!",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          inherit: false,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          padding: EdgeInsets.all(15),
                          backgroundColor: Color.fromARGB(250, 255, 190, 52),
                        ),
                        child: AutoSizeText(
                          "返回",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ).animate().slide(duration: 500.ms),
      ],
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
          poses, inputImage.metadata!.size, inputImage.metadata!.rotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Poses found: ${poses.length}\n\n';
      // TODO: set _customPaint to draw landmarks on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
