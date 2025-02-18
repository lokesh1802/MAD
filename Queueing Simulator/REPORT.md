# MP Report

## Team

- Name(s): Lokesh Manchikanti
- AID(s): A20544931

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [x] The simulator builds without error
- [x] The simulator runs on at least one configuration file without crashing
- [x] Verbose output (via the `-v` flag) is implemented
- [x] I used the provided starter code
- The simulator runs correctly (to the best of my knowledge) on the provided configuration file(s):
  - [x] conf/sim1.yaml
  - [x] conf/sim2.yaml
  - [x] conf/sim3.yaml
  - [x] conf/sim4.yaml
  - [x] conf/sim5.yaml

## Summary and Reflection

I implemented the simulator using a Simulation class to manage the flow, with different Process types (singleton, periodic, stochastic) to generate events. YAML was used for configuration, and events are handled through a unified queue. I focused on calculating event wait times and handling random durations for stochastic events. 

while working on processes i faced many difficulites with the output it challenged me working for correct output. later only 3 outputs were correct. I had issue withsim4.yaml and sim5.yaml outputs. There was a type error regarding int as double it took some time i have enjoyed and learned will working on it.
