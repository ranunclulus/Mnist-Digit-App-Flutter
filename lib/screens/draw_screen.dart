import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mnistdigitrecognizer/screens/drawing_painter.dart';
import 'package:tflite/tflite.dart';
import '../models/prediction.dart';
import '../services/recognizer.dart';
import '../utils/constants.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({Key? key}) : super(key: key);

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final _points = <Offset?>[];
  final _recognizer = Recognizer();
  var _prediction = <Prediction>[];
  bool initialize = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digit Recognizer'),
      ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'MNIST database of handwritten digits',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'The digits have been size-normalized and centered in a fixed-size images (28 x 28)',
                        )
                      ],
                    ),
                  ),
                ),
                _mnistPreviewImage(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: Constants.canvasSize + Constants.borderSize * 2,
              height: Constants.canvasSize + Constants.borderSize * 2,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: Constants.borderSize,
                ),
              ),
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  Offset _localPosition = details.localPosition;
                  if (_localPosition.dx >= 0 &&
                      _localPosition.dx <= Constants.canvasSize &&
                      _localPosition.dy >= 0 &&
                      _localPosition.dy <= Constants.canvasSize) {
                    setState(() {
                      _points.add(_localPosition);
                    });
                  }
                },
                onPanEnd: (DragEndDetails details) {
                  _points.add(null);
                  _recognize();
                },
                child: CustomPaint(
                  painter: DrawingPainter(_points),
                ),
              ),
            ),
            //PredictionWidget(
              //predictions: _prediction,
            //)
          ],
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.clear),
        onPressed: () {
          _points.clear();
        }
      )
    );
  }

  dispose() {
    Tflite.close();
  }

  Widget _mnistPreviewImage() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.black,
      child: FutureBuilder(
        future: _previewImage(),
        builder: (BuildContext _, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.fill,
            );
          } else {
            return Center(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }

  Future<Uint8List> _previewImage() async {
    return await _recognizer.previewImage(_points);
  }

  void _initModel() async {
    var res = await _recognizer.loadModel();
  }

  void _recognize() async {
    List<dynamic> pred = await _recognizer.recognize(_points);
    setState(() {
      _prediction = pred.map((json) => Prediction.fromJson(json)).toList();
    });
  }
}



