# Elder Scrolls Online Terminal (esoTERM)

## Slash commands

* Empty: displays the *about* message

```
/esoterm
```

* Help: displays the help message :)

```
/esoterm help
```


* Status: displays the status for each sub-module

```
/esoterm status
```

## Configuration file

Location of the *esoTERM* configuration file is (assuming standard environment):

```
C:\Users\<user>\Documents\Elder Scrolls Online\liveeu\SavedVariables\esoTERM.lua
```

### Configuration parameters (per *character*):

* `window_locked`: whether the *esoTERM* window is moveable/resizeable or not
* `window_width`: width of the *esoTERM* window
* `window_height`: height of the *esoTERM* window
* `window_x`: x position of the *esoTERM* window
* `window_y`: y position of the *esoTERM* window
* `version`: not used

A *"picture"* tells more than thousand words:

```

 +--------------------------------------------------------------+
 | TESO in-game screen :)                                       |
 |                                                              |
 |                                                              |
 |                 D---------+   ---                            |
 |                 |        A|    ^                             |
 |                 +---------+    |                             |
 |                 |         |    |                             |
 |                 |         |    C                             |
 |                 | esoTERM |    |                             |
 |                 |         |    |                             |
 |                 |         |    |                             |
 |                 +---------+   ---                            |
 |                                                              |
 |                 |         |       A - window_locked button   |
 |                 |----B--->|       B - window_width           |
 |                 |         |       C - window_height          |
 |                                   D - window_x, window_y     |
 |                                                              |
 +--------------------------------------------------------------+

```

Do **not** edit these parameters manually, *esoTERM* should handle them.
