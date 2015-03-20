# Elder Scrolls Online Terminal (esoTERM)

## Slash commands

* Empty: displays the *about* message

```
/esoterm
```

* help: displays the help message :)

```
/esoterm help
```


* status: displays the status for each module

```
/esoterm status
```

* activate: activate the given module, `module_name` can be case-insensitive

```
/esoterm activate <module_name>
```

* deactivate: deactivate the given module, `module_name` can be case-insensitive

```
/esoterm deactivate <module_name>
```

## Configuration file

Do **not** edit these parameters manually, *esoTERM* should handle them.

## Configuration file location

Location of the *esoTERM* configuration file is (assuming standard environment):

```
C:\Users\<user>\Documents\Elder Scrolls Online\liveeu\SavedVariables\esoTERM.lua
```

### Configuration file parameters (per *character*):

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
 |                 |         |    v                             |
 |                 +---------+   ---                            |
 |                                                              |
 |                 |         |       A - window_locked button   |
 |                 |<---B--->|       B - window_width           |
 |                 |         |       C - window_height          |
 |                                   D - window_x, window_y     |
 |                                                              |
 +--------------------------------------------------------------+

```
