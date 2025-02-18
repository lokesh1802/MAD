import 'processes.dart';
import 'package:yaml/yaml.dart';

/// Queueing system simulator.
class Simulator {
  final bool verbose;  // Flag for verbose logging
  final List<Process> processes = [];  // List to store processes
  String _report = "";  // String to store the simulation report

  Simulator(YamlMap yamlData, {this.verbose = false}) {
    for (final name in yamlData.keys) {
      final fields = yamlData[name];
      processes.add(_createProcess(name, fields));  // Create and add the appropriate process
    }
  }

  Process _createProcess(String name, YamlMap fields) {
    switch (fields['type']) {
      case 'singleton':
        return SingletonProcess(name, fields);
      case 'periodic':
        return PeriodicProcess(name, fields);
      case 'stochastic':
        return StochasticProcess(name, fields);
      default:
        throw ArgumentError('Unknown process type: ${fields['type']}');
    }
  }

  void run() {
    final events = <Event>[];  // List to store generated events

    int index = 0;

while (index < processes.length) {
  var process = processes[index];
  events.addAll(process.generateEvents()); 
  index++;
}


    // Sort events by arrival time, then by process name
    events.sort((a, b) => a.arrivalTime != b.arrivalTime 
        ? a.arrivalTime.compareTo(b.arrivalTime)
        : a.processName.compareTo(b.processName));

    int currentTime = 0;  // Track the current time
    double totalWaitTime = 0;  // Accumulate total wait time

    if (verbose) {
      print("\n# Simulation trace\n");
    }

    for (var event in events) {
      currentTime = currentTime < event.arrivalTime ? event.arrivalTime : currentTime;
      event.start = currentTime;
      event.waitTime = currentTime - event.arrivalTime;
      totalWaitTime += event.waitTime;
      currentTime += event.duration;

      if (verbose) {
        print(
          't=${event.start}: ${event.processName}, duration ${event.duration} '
          'started (arrived @ ${event.arrivalTime}, waited ${event.waitTime})'
        );
      }
    }

    _storeReport(events, totalWaitTime);  // Store the simulation report
  }

  void _storeReport(List<Event> events, double totalWaitTime) {
    final buffer = StringBuffer();
    final processStats = <String, List<Event>>{};

    for (var event in events) {
      processStats.putIfAbsent(event.processName, () => []).add(event);
    }

    buffer.writeln('--------------------------------------------------------------');
    buffer.writeln('# Per-process statistics\n');
    processStats.forEach((name, events) {
      final totalWait = events.fold<int>(0, (sum, e) => sum + e.waitTime);
      buffer.writeln('$name:');
      buffer.writeln('  Events generated:  ${events.length}');
      buffer.writeln('  Total wait time:   $totalWait');
      buffer.writeln('  Average wait time: ${totalWait / events.length}\n');
    });

    buffer.writeln('--------------------------------------------------------------');
    buffer.writeln('# Summary statistics\n');
    buffer.writeln('Total num events:  ${events.length}');
    buffer.writeln('Total wait time:   $totalWaitTime');
    buffer.writeln('Average wait time: ${totalWaitTime / events.length}');

    _report = buffer.toString();  // Store the report
  }

  void printReport() {
    print(_report);
  }
}
