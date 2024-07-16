// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:record/record.dart';
//
// int recordDuration = 0;
// Timer? _timer;
// final _audioRecord = AudioRecorder();
// StreamSubscription<RecordState>? _recordSub;
// RecordState recordState = RecordState.stop;
// RecordConfig config = RecordConfig();
// String path = 'storage/emulated/downloads';
// String? audioPath;
// String? minutes = "00";
// String? seconds = "00";
// bool isRecorderInitialized = false;
// bool isRecording=false;
//
//
// initRecorder() async {
//   _recordSub = _audioRecord.onStateChanged().listen((recordStateThis) {
//     recordState = recordStateThis;
//   });
//   audioPath = null;
//   isRecorderInitialized = true;
// }
//
// void disposeRecorder() {
//   _timer?.cancel();
//   _recordSub?.cancel();
//   _audioRecord.dispose();
//   isRecorderInitialized = false;
//   print('dispose Success');
// }
//
// void onStop(String path) {
//   print('file saved  path:$path');
//   setState(() {
//     isRecording= false;
//   });
// }
//
// Future<void> _start() async {
//   try {
//     if (await _audioRecord.hasPermission()) {
//       final isSupported = await _audioRecord.isEncoderSupported(
//         AudioEncoder.aacLc,
//       );
//       if (kDebugMode) {
//         print('${AudioEncoder.aacLc.name} supported: $isSupported');
//       }
//       // isRecording = await _audioRecorder.isRecording();
//       await _audioRecord.start(config, path: path);
//       recordDuration = 0;
//       _startTimer();
//     }
//   } catch (e) {
//     if (kDebugMode) {
//       print(e);
//     }
//   }
// }
//
// Future<void> _stop() async {
//   _timer?.cancel();
//   recordDuration = 0;
//   final path = await _audioRecord.stop();
//   if (path != null) {
//     onStop(path);
//   }
// }
//
//
// Future<void> _pause() async {
//   _timer?.cancel();
//   await _audioRecord.pause();
// }
//
// Future<void> _resume() async {
//   _startTimer();
//   await _audioRecord.resume();
// }
//
// void _startTimer() {
//   _timer?.cancel();
//   _timer = Timer.periodic(Duration(seconds: 2), (timer) {
//     setState(() {
//       recordDuration++;
//       minutes = _formatNumber(recordDuration ~/ 60);
//       seconds = _formatNumber(recordDuration % 60);
//     });
//   });
// }
//
// String _formatNumber(int number) {
//   String numberStr = number.toString();
//   if (number < 10) {
//     numberStr = '0$numberStr';
//   }
//
//   return numberStr;
// }
