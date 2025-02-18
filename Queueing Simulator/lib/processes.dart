import 'package:yaml/yaml.dart';  
import 'util/stats.dart';
/// Base class for all process types.
abstract class Process {
  final String name;  // Name of the process
  final YamlMap config;  // Configuration map for the process

  Process(this.name, this.config);

  // Abstract method to generate events
  List<Event> generateEvents();
}

class SingletonProcess extends Process {
  SingletonProcess(String name, YamlMap config) : super(name, config);

  @override
  List<Event> generateEvents() {
    return [
      Event(name, config['arrival'], config['duration'])
    ];
  }
}

class PeriodicProcess extends Process {
  PeriodicProcess(String name, YamlMap config) : super(name, config);

  @override
  List<Event> generateEvents() {
    final events = <Event>[];
    for (int i = 0; i < config['num-repetitions']; i++) {
      events.add(Event(
        name,
        config['first-arrival'] + i * config['interarrival-time'],
        config['duration']
      ));
    }
    return events;
  }
}

class StochasticProcess extends Process {
  StochasticProcess(String name, YamlMap config) : super(name, config);

  @override
  List<Event> generateEvents() {
    final events = <Event>[];
    final int meanDuration = config['mean-duration'] as int;
final durationDist = ExpDistribution(mean: meanDuration.toDouble());

final int meanInterarrivalTime = config['mean-interarrival-time'] as int;
final interarrivalDist = ExpDistribution(mean: meanInterarrivalTime.toDouble());

    int currentTime = config['first-arrival'];

    while (currentTime < config['end']) {
      events.add(Event(name, currentTime, durationDist.next().ceil()));
      currentTime += interarrivalDist.next().ceil();
    }

    return events;
  }
}



/// An event that occurs once at a fixed time.
class Event {
  final String processName;  // Name of the process that generated the event
  final int arrivalTime;  // Arrival time of the event
  final int duration;  // Duration of the event
  int start = 0;  // Start time of the event
  int waitTime = 0;  // Wait time of the event

  Event(this.processName, this.arrivalTime, this.duration);
}

