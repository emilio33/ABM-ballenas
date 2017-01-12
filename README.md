# ABM-ballenas

WHAT IS IT?
This is an exploratory model of the stability of a socio-ecological system that comprises (gray) whales and whale watching boats. The system is represented by a costal lagoon (a winter habitat of gray whales). The process represented in this model takes place during the whale watching season (a 90 day period every year).
The system is unstable if it tends to result in the diseappearence of whales. In contrast, the system is considered stable if it tends to maintain a certain number of whales and boats, despite variations in the abundance of whales.

HOW IT WORKS
The boats have a disturbance effect on the quality of the whales’ habitat. The boats’ cumulative disturbance on the habitat translates into a death of whales and a decrease of the habitat quality.
There are two main variations to this model. The first variation increases by a certain number the amount of boats that carry out whale watching activities each season. The second variation explores the effect over time of a constant number of boats.
Boats move and degrade the quality of the habitat during the season. However, given that the number of whales can only diminish or be constant, there is room for the habitat to recovery at a rate that depends on the abundance of whales.
Every new season (each tick represents a whale watching season) there is an update of the state of the habitat and the number of whales and boats.

HOW TO USE IT
Determine the initial number of boats in the lagoon by setting the switch initialflags to that value.
Determine the initial number of whales in the lagoon by setting the switch initialwhales to that value.
Determine the disturbance effect of boats on the habitat by setting the switch boat-disturbance to that value.
Determine the increase in the number of boats per season by setting the switch new-permits to that value.
Press the SETUP button.
Press the Go button to begin the simulation and run it continuously.
Press the GO button to begin the simulation and run it only for one tick.
Look at the graphs to watch the fluctuations over time.
Look at the monitors to see the current state of the abundance of whales, habitat quality, and number of boats.
Order of events:
A. (setup procedure) It sets up the agents and turns patches blue to represent the lagoon
B. (go procedure) It checks if there are whales left in the lagoon, if so, then:
1) updates the number of whales in the lagoon (whale-death procedure)
2) updates the number of boats (addboats procedure)
3) all the whales (fish in the code) move
4) all the boats move
5) patches recover a certain amount of their quality
6) ticks (i.e. marks the end of the season)
