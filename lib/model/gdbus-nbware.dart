// This file was generated using the following command and may be overwritten.
// dart-dbus generate-remote-object gdbus-nbware.xml

import 'dart:io';
import 'package:dbus/dbus.dart';

/// Signal data for com.smarthome.nbware.graph.onConnectionNotify.
class ComSmarthomeNbwareGraphonConnectionNotify extends DBusSignal {
  int get uid => values[0].asInt32();
  int get connection => values[1].asInt32();

  ComSmarthomeNbwareGraphonConnectionNotify(DBusSignal signal) : super(sender: signal.sender, path: signal.path, interface: signal.interface, name: signal.name, values: signal.values);
}

/// Signal data for com.smarthome.nbware.graph.onRecordingNotify.
class ComSmarthomeNbwareGraphonRecordingNotify extends DBusSignal {
  int get uid => values[0].asInt32();
  int get recording => values[1].asInt32();

  ComSmarthomeNbwareGraphonRecordingNotify(DBusSignal signal) : super(sender: signal.sender, path: signal.path, interface: signal.interface, name: signal.name, values: signal.values);
}

/// Signal data for com.smarthome.nbware.graph.onAIDetectionNotify.
class ComSmarthomeNbwareGraphonAIDetectionNotify extends DBusSignal {
  int get uid => values[0].asInt32();
  int get detection => values[1].asUint32();

  ComSmarthomeNbwareGraphonAIDetectionNotify(DBusSignal signal) : super(sender: signal.sender, path: signal.path, interface: signal.interface, name: signal.name, values: signal.values);
}

class ComSmarthomeNbwareGraph extends DBusRemoteObject {
  /// Stream of com.smarthome.nbware.graph.onConnectionNotify signals.
  late final Stream<ComSmarthomeNbwareGraphonConnectionNotify> onConnectionNotify;

  /// Stream of com.smarthome.nbware.graph.onRecordingNotify signals.
  late final Stream<ComSmarthomeNbwareGraphonRecordingNotify> onRecordingNotify;

  /// Stream of com.smarthome.nbware.graph.onAIDetectionNotify signals.
  late final Stream<ComSmarthomeNbwareGraphonAIDetectionNotify> onAIDetectionNotify;

  ComSmarthomeNbwareGraph(DBusClient client, String destination, DBusObjectPath path) : super(client, name: destination, path: path) {
    onConnectionNotify = DBusRemoteObjectSignalStream(object: this, interface: 'com.smarthome.nbware.graph', name: 'onConnectionNotify', signature: DBusSignature('ii')).asBroadcastStream().map((signal) => ComSmarthomeNbwareGraphonConnectionNotify(signal));

    onRecordingNotify = DBusRemoteObjectSignalStream(object: this, interface: 'com.smarthome.nbware.graph', name: 'onRecordingNotify', signature: DBusSignature('ii')).asBroadcastStream().map((signal) => ComSmarthomeNbwareGraphonRecordingNotify(signal));

    onAIDetectionNotify = DBusRemoteObjectSignalStream(object: this, interface: 'com.smarthome.nbware.graph', name: 'onAIDetectionNotify', signature: DBusSignature('iu')).asBroadcastStream().map((signal) => ComSmarthomeNbwareGraphonAIDetectionNotify(signal));
  }

  /// Invokes com.smarthome.nbware.graph.Rebuild()
  Future<void> callRebuild({bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    await callMethod('com.smarthome.nbware.graph', 'Rebuild', [], replySignature: DBusSignature(''), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  /// Invokes com.smarthome.nbware.graph.GetAllStates()
  Future<List<List<DBusValue>>> callGetAllStates({bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod('com.smarthome.nbware.graph', 'GetAllStates', [], replySignature: DBusSignature('a(iii)'), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asArray().map((child) => child.asStruct()).toList();
  }
}
