Globals [HQ-total]   ;; the whole quality of the lagoon (as a habitat for the whales) is affected by the boats and it affects the number of whales in the lagoon

breed [boats boat]
breed [ fish ]

patches-own [ habitat-Q ]   ;; each patch contributes to the HQ-total (the whole quality of the lagoon as a habitat for the whales)


;############## setup procedure ################################

to setup
  ca
  ask patches [
    set habitat-Q 100
    set pcolor blue ]   ;; it sets the color of each patch to its quality as a habitat using a gradient of blues  < set pcolor scale-color blue habitat-Q 100 0

  create-boats initialflags                      ;; it uses the input from the slider called "initialflags" to create the initial number of boats
  ask boats [                                    ;; (there's a minimum of 1 boat because, otherwise, it doesn't makes sense to do this model at all)
    set shape "boat"
    set size 3
    set color green
    setxy random-xcor random-ycor]

  create-fish initialwhales                      ;; it uses the input from the slider called "initialwhales" to create the initial number of whales
  ask fish [                                     ;; (there's a minimum of 10 whales because, otherwise, it wouldn't make sense to have a boat for whale watching activities)
    set shape "fish"
    set size 1
    set color gray
    setxy random-xcor random-ycor
    ]
  reset-ticks
end

;######################## go procedure ###########################

to go
  if not any? fish  [stop]   ;; it checks whether or not there are whales in the lagoon, if there aren't whales left the model stops

 whale-death                 ;; there are whales that doesn't come back to the lagoon (which is equivalent to die in this model) due to the effect of boats on the habitat's quality
 addboats                    ;; whether or not the number of whale watching boats is going to increase every season (see procedure below)

   ask fish [
     move-fish]

   ask boats [
     repeat 78 [        ;; this command makes that each boats repeats their procedure 78 times per tick. Each tick represents a whale-watching season, each season lasts 3 monts (i.e. 90 days) and
       move              ;; I assume that the boats do not go out one day each week (i.e. 12 days per season), so 90 -12 = 78 days of whale watching activities per season
       degrade
       ]
      ]

   ask patches [     ;; boats affect the quality of the patches they go through, however, there are days that the boats don't go out, thus I allow patches to
     recover ]       ;; "recover" a certain amount of their quality.

tick
end

;######### moves procedures ################################

 to move-fish
  rt random 50
  lt random 50
  fd 1                           ;; the world represents a lagoon, thus there are physical limits (horizontal and vertical limits)
  if not can-move? 1 [ rt 180 ]  ;;  therefore this command prevents the whales to get stuck on the edges
 end

 to move
  rt random 50
  lt random 50
  fd 1
  if not can-move? 1 [ rt 180 ]  ;; this command prevents the boats to get stuck on the edges
 end

;##### degrade procedure  #########################################

 to degrade
   ask patch-here [                                                            ;; it makes boats to affect the habitat, to do so, each boat affects the variable of the patch called "habitat-Q"
    set habitat-Q precision (habitat-Q - (boat-disturbance * habitat-Q)) 2     ;; the aggregate of the quality of each patch makes for the quality of the whole habitat,
  ]                                                       ;;  The boats affect, each one, those patches they go trhough (they move 78 times per tick) and the quantity
 end                                                      ;; is a proportion that the observer sets up with the slide "boat-disturbance" (note that there's significant uncertainty about this value)

;#### whael-death procedure  ############################################

 to whale-death                                                  ;; this procedure is a proxy of the lethal effect of boats, which is an accumulative effect (i.e. the boats doesn't have an
   set HQ-total precision (mean [habitat-Q] of patches / 100) 2  ;; inmediate effect on whales) the quality of the total habitat is equal to the mean of the quality of the patches' habitat.
   ifelse HQ-total <= 0.1 [ ask fish [die]]
   [let whales count fish / 2                        ;; only half of the population is affected
   ask n-of (random whales) fish [                   ;; from this half population only a random number (and also choosing the whales affected randomly) can die
     if HQ-total < random-float 1 [                  ;; the higher the disturbance the more whales will "die"
     die ]
   ]]
 end

;###### recover procedure #####################################################

 to recover
   if ticks mod 1 = 0 and HQ-total < 1 [                                           ;; every tick (a whale-watching seasons) those patches with whales recover (so that recovery is dependent on
   ask patches with [ any? fish-here and habitat-Q < 99] [                         ;; the number of whales) their initial quality but only if the total quality (i.e. the quality of the whole
      set habitat-Q   precision (habitat-Q + (boat-disturbance * habitat-Q)) 2] ]  ;; habitat is not at its maximum quality). The recovery is set proportional to the disturbance effect of each boat
 end

;#### addboats procedure ##################################################

 to addboats
   let Totalboats count boats
   ifelse Totalboats >= count fish   ;; if there are the same or more boats than whales it won't be viable for a new boat to go out, so this commands prevents adding more boats
   [ set Totalboats Totalboats + 0]
   [ask one-of boats [               ;; otherwise, only one boat is going to "reproduce" (which equals to the government granting new additional permits to carry out the whale watching activity)
    if ticks mod 1 = 0 [             ;; every tick we add a certain number of boats
     hatch-boats new-permits ]       ;; the number of additional boats is set up with the slider "new-permits" that allows to add from a maximum of 5boast per season to none.
   ]]
 end








;ERI 2016
@#$#@#$#@
GRAPHICS-WINDOW
440
14
938
533
30
30
8.0
1
10
1
1
1
0
0
0
1
-30
30
-30
30
0
0
1
Whale watching seasons
30.0

SLIDER
15
22
187
55
initialflags
initialflags
1
50
22
1
1
NIL
HORIZONTAL

SLIDER
15
64
187
97
initialwhales
initialwhales
10
2100
1050
1
1
NIL
HORIZONTAL

BUTTON
175
182
246
221
GO
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
17
182
83
221
SETUP
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
95
182
164
221
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
17
473
80
518
Whales
count fish
0
1
11

MONITOR
229
474
292
519
Boats
count boats
0
1
11

PLOT
952
15
1350
213
Habitat quality
Time (seasons)
Habitat quality
1.0
100.0
0.0
1.0
false
false
"" ""
PENS
"Habitat quality" 1.0 0 -16777216 true "" "plot HQ-total"

PLOT
952
253
1348
470
Whales
Time (seasons)
Whale abundance
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Whales" 1.0 0 -16777216 true "" "plot count fish"
"Quarter of population" 1.0 2 -10141563 true "" "plot (initialwhales / 4) * 3"
"Half of population" 1.0 2 -5298144 true "" "plot (initialwhales / 2)"

TEXTBOX
207
64
374
148
The world is 61 patches wide x 61 patches long. The coastal lagoon modelled has 3700 ha, so this world has 3721 patches. Thus, each patch equals 1 ha of the lagoon.
11
0.0
1

MONITOR
106
474
200
519
Habitat quality
HQ-total
3
1
11

SLIDER
15
108
187
141
boat-disturbance
boat-disturbance
0
0.1
0.01
0.01
1
NIL
HORIZONTAL

SLIDER
206
23
378
56
new-permits
new-permits
0
5
1
1
1
NIL
HORIZONTAL

PLOT
15
255
428
459
Whales, habitat & boats
Time (seasons)
Normalized values
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Whale abundance" 1.0 2 -7500403 true "" "plot (count fish) / initialwhales"
"Habitat quality" 1.0 2 -955883 true "" "plot HQ-total"
"Boats" 1.0 2 -14439633 true "" "plot 1 - (initialflags / (count boats) )"

@#$#@#$#@
## WHAT IS IT?

This is an exploratory model of the stability of a socio-ecological system that comprises (gray) whales and whale watching boats. The system is represented by a costal lagoon (a winter habitat of gray whales). The process represented in this model takes place during the  whale watching season (a 90 day period every year).

The system is unstable if it tends to result in the diseappearence of whales. In contrast, the system is considered stable if it tends to maintain a certain number of whales and boats, despite variations in the abundance of whales.

## HOW IT WORKS

The boats have a disturbance effect on the quality of the whales’ habitat. The boats’ cumulative disturbance on the habitat translates into a death of whales and a decrease of the habitat quality.

There are two main variations to this model. The first variation increases by a certain number the amount of boats that carry out whale watching activities each season. The second variation explores the effect over time of a constant number of boats.

Boats move and `degrade` the quality of the habitat during the season. However, given that the number of whales can only diminish or be constant, there is room for the habitat to recovery at a rate that depends on the abundance of whales.

Every new season (each tick represents a whale watching season) there is an update of the state of the habitat and the number of whales and boats.


## HOW TO USE IT

1. Determine the initial number of boats in the lagoon by setting the switch `initialflags` to that value.

2. Determine the initial number of whales in the lagoon by setting the switch `initialwhales` to that value.

3. Determine the disturbance effect of boats on the habitat by setting the switch `boat-disturbance` to that value.

4. Determine the increase in the number of boats per season by setting the switch `new-permits` to that value.

5. Press the `SETUP` button.

6. Press the `Go` button to begin the simulation and run it continuously.

7. Press the `GO` button to begin the simulation and run it only for one tick.

8. Look at the graphs to watch the fluctuations over time.

9. Look at the monitors to see the current state of the abundance of whales, habitat quality, and number of boats.

Order of events:

A. (setup procedure) It sets up the agents and turns patches blue to represent the lagoon

B. (go procedure) It checks if there are whales left in the lagoon, if so, then:

	1) updates the number of whales in the lagoon (whale-death procedure)
	2) updates the number of boats (addboats procedure)
	3) all the whales (fish in the code) move
	4) all the boats move
	5) patches recover a certain amount of their quality
	6) ticks (i.e. marks the end of the season)


## THINGS TO NOTICE

Central to the model is the observation of how boats affect the abundance of whales in the lagoon.

When the number of boats is set to a constant value (i.e. there are no new permits for whale watching), watch the fluctuation in the number of whales. Notice how the boat-disturbance affects the whale population. For a given disturbance and number of boats, is there a critical size of the initial whale population? Does the system reach stability?

How much does the quantity of new permits affect the abundance of whales? In what way are the number of boats and the number of whales related? and the habitat quality and the whale abundance?


## THINGS TO TRY

How sensitive is the stability of the model to the initial values of whales and boats?

Can you find any parameters that generate a stable socio-ecological system?

Try changing the `addboats` procedure to increase the number of boats over longer periods of time (such as every two or five seasons). Does that change the patterns observed?

## EXTENDING THE MODEL

Currently whales and boats move randomly around the lagoon. Can you modify the model so the whales will flock? Also, what happens if boats move to target bigger flocks?

## NETLOGO FEATURES

Note the use of breeds to model two different kinds of "turtles": boats and fish (whales). Note the use of a property of the patches (`habitat-Q`) that realtes to the global variable (`HQ-total`) of the whole habitat quality.
Notice the use of `precision` to round the numbers to only two decimals; and the use of `mod` to establish the periodicity of the recovery and the adding of new boats.

## RELATED MODELS

* Wolf Sheep Predation

* Ants
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

boat
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
