import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class ExampleAlarmRingScreen extends StatefulWidget {
  const ExampleAlarmRingScreen({required this.alarmSettings, super.key});

  final AlarmSettings alarmSettings;

  @override
  State<ExampleAlarmRingScreen> createState() => _ExampleAlarmRingScreenState();
}

class _ExampleAlarmRingScreenState extends State<ExampleAlarmRingScreen> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final isRinging = await Alarm.isRinging(widget.alarmSettings.id);
      if (isRinging) {
        alarmPrint('Alarm ${widget.alarmSettings.id} is still ringing...');
        return;
      }

      alarmPrint('Alarm ${widget.alarmSettings.id} stopped ringing.');
      timer.cancel();
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'You alarm (${widget.alarmSettings.id}) is ringing...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text('🔔', style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //NOTE: 停止したら削除されるのでここを停止しても削除されないように変える。 （Alarm.stop が削除の意味）
                RawMaterialButton(
                  onPressed: () async => {
                    Alarm.stop(widget.alarmSettings.id),
                    Alarm.set(
                        alarmSettings: widget.alarmSettings.copyWith(
                      dateTime: DateTime.now().add(const Duration(days: 1)),
                    )),
                  },
                  child: Text(
                    'Stop',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () async => Alarm.set(
                    alarmSettings: widget.alarmSettings.copyWith(
                      dateTime: DateTime.now().add(const Duration(minutes: 1)),
                    ),
                  ),
                  fillColor: const Color.fromARGB(255, 255, 0, 0),
                  child: Text(
                    '1min',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () async => Alarm.set(
                    alarmSettings: widget.alarmSettings.copyWith(
                      dateTime: DateTime.now().add(const Duration(minutes: 3)),
                    ),
                  ),
                  fillColor: const Color.fromARGB(255, 254, 241, 0),
                  child: Text(
                    '2min',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
