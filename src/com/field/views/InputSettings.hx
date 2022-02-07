/*
    Copyright (C) 2020-2021 Vis LLC - All Rights Reserved

    This program is free software : you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <https ://www.gnu.org/licenses/>.
*/

/*
    FieldEngine
    FieldEngine - Source code can be found on SourceForge.net
*/

package com.field.views;

import com.field.views.VirtualGamepadView;

import com.field.renderers.Element;
import com.field.renderers.EventInfoInterface;
import com.field.renderers.RendererAbstract;

@:native
class InputSettings extends com.field.renderers.RendererAccessor implements com.field.renderers.MouseEventReceiver implements com.field.renderers.TouchEventReceiver implements com.field.renderers.KeyEventReceiver implements com.field.renderers.GamepadEventReceiver {
    public inline function new(fieldView : FieldViewInterface, gamepadOnMouse : Bool, gamepadOnTouch : Bool) {
        super();
        _fieldView = fieldView;
        _gamepadOnMouse = gamepadOnMouse;
        _gamepadOnTouch = gamepadOnTouch;
    }

    private var _fieldView : FieldViewInterface;
    private var _gamepadOnMouse : Bool;
    private var _gamepadOnTouch : Bool;

    public var _thresholdX : Float;
    public var _thresholdY : Float;
    public var _unknownKey : Null<Int->Void>;
    public var _gamepad : Null<Int->NativeIntMap<Float>->Void>;
    public var _mouse : Null<String->Element->Void>;
    public var _delayAfterInteraction : Null<Int>;
    public var _reduceDelayIntervals : Null<Int>;
    public var _delay : Int;
    public var _gamepads : Int;
    public var _oldGPState : NativeIntMap<NativeIntMap<Float>>;
    public var _startTouchX : Null<Int>;
    public var _startTouchY : Null<Int>;
    public var _touchActive : Bool;
    public var _touchIsMouse : Bool;
    public var _virtualGamepad : Null<VirtualGamepadView>;
    public var _currentTouchX : Null<Int>;
    public var _currentTouchY : Null<Int>;
    public var _lastKeyDown : Null<Date> = null;
    public var _selectOnPress : Null<String> = null;

    private function pollTouch() {
        if (_startTouchX != null)
        {
            if (_delay <= 0)
            {
                if (!(_touchActive)) {
                    if (_touchIsMouse && _gamepadOnMouse || !(_touchIsMouse) && _gamepadOnTouch) {
                        _virtualGamepad = VirtualGamepadView.get();
                        _virtualGamepad.set(_fieldView.toElement(), _startTouchX, _startTouchY, this);
                    }
                    _touchActive = true;
                }
                
                var dDiffX : Int = _currentTouchX - _startTouchX;
                var dDiffY : Int = _currentTouchY - _startTouchY;
                var x : Int = 0;
                var y : Int = 0;

                if (dDiffX > 25) {
                    x = -1;
                } else if (dDiffY > 25) {
                    y = -1;
                } else if (dDiffX < -25) {
                    x = 1;
                } else if (dDiffY < -25) {
                    y = 1;
                }

                if (_virtualGamepad != null) {
                    _virtualGamepad.press(x, y);
                }

                if (x != 0 || y != 0) {
                    _fieldView.navigateInXY(x, y);
                }

                setTimeout(pollTouch, _reduceDelayIntervals);
            }
        } else {
            if (_touchActive) {
                _touchActive = false;
                if (_virtualGamepad != null) {
                    _virtualGamepad.remove();
                    _virtualGamepad = null;
                }
            }
        }
    }

    public function onclick(e : EventInfoInterface) : Void { }

    public function ondblclick(e : EventInfoInterface) : Void {
        _mouse("dblclick", e.target());
    }

    public function ontouchend(e : EventInfoInterface) : Void {
        e.preventDefault();
        _touchIsMouse = false;
        _startTouchX = null;
        _startTouchY = null;
        _currentTouchX = null;
        _currentTouchY = null;
    }

    public function onmousedown(e : EventInfoInterface) : Void {
        _touchIsMouse = true;
        _startTouchX = e.getX();
        _startTouchY = e.getY();
        _currentTouchX = _startTouchX;
        _currentTouchY = _startTouchY;
        setTimeout(pollTouch, _reduceDelayIntervals);
    }

    public function onmouseup(e : EventInfoInterface) : Void {
        _touchIsMouse = true;
        _startTouchX = null;
        _startTouchY = null;
        _currentTouchX = null;
        _currentTouchY = null;
    }

    public function onmouseover(e : EventInfoInterface) : Void {
        _touchIsMouse = true;
        if (_startTouchX != null) {
            if (e.buttons() == 0) {
                onmouseup(e);
            } else {
                _currentTouchX = e.getX();
                _currentTouchY = e.getY();
            }
        }    
    }

    public function ontouchstart(e : EventInfoInterface) : Void {
        e.preventDefault();
        _touchIsMouse = false;
        _startTouchX = e.getX();
        _startTouchY = e.getY();
        _currentTouchX = _startTouchX;
        _currentTouchY = _startTouchY;
        setTimeout(pollTouch, _reduceDelayIntervals);
    }

    public function ontouchcancel(e : EventInfoInterface) : Void {
        e.preventDefault();
        _touchIsMouse = false;
        _startTouchX = null;
        _startTouchY = null;
        _currentTouchX = null;
        _currentTouchY = null;
    }

    public function ontouchmove(e : EventInfoInterface) : Void {
        e.preventDefault();
        _touchIsMouse = false;
        _currentTouchX = e.getX();
        _currentTouchY = e.getY();  
    }

    public function onkeydown(e : EventInfoInterface) : Void {
        if (_delay > 0){
            return;
        }

        var dCurrentKeyDown : Date = Date.now();
        if ((_lastKeyDown == null) || (dCurrentKeyDown.getTime() - _lastKeyDown.getTime()) > 25) {
                _lastKeyDown = dCurrentKeyDown;
                var x : Int = 0;
                var y : Int = 0;

                switch (e.keyCode())
                {
                    // Left arrow
                    case 37:
                        x = 1;
                        y = 0;
                    // Up arrow
                    case 38:
                        x = 0;
                        y = 1;
                    // Right arrow
                    case 39:
                        x = -1;
                        y = 0;
                    // Down arrow
                    case 40:
                        x = 0;
                        y = -1;
                    // A
                    case 65:
                        x = 1;
                        y = 0;
                    // D
                    case 68:
                        x = -1;
                        y = 0;
                    // S
                    case 83:
                        x = 0;
                        y = -1;
                    // W
                    case 87:
                        x = 0;
                        y = 1;
                    // 2
                    case 98:
                        x = 0;
                        y = 1;
                    // 4
                    case 100:
                        x = 1;
                        y = 0;
                    // 6
                    case 102:
                        x = -1;
                        y = 0;
                    // 8
                    case 104:
                        x = 0;
                        y = -1;
                    default:
                        if (_selectOnPress != null && e.key() == _selectOnPress) {
                            var e : Null<Element> = RendererAbstract.currentRenderer().getActiveElement();
                            if (e != null && RendererAbstract.currentRenderer().hasStyle(RendererAbstract.currentRenderer().getStyle(e), LocationView.FIELD_LOCATION_STYLE) && RendererAbstract.currentRenderer().containsElement(_fieldView.toElement(), e)) {
                                RendererAbstract.currentRenderer().click(e);
                            }
                        } else {
                            _unknownKey(e.keyCode());
                        }
                }

                if (x != 0 || y != 0) {
                    _fieldView.navigateInXY(x, y);
                }
            }
    }

    private function reportButtons(i : Int, o : Null<NativeIntMap<Float>>) : Void {
        if (o != null) {
            o = new NativeIntMap<Float>();
        }
        var unchanged : NativeArray<Int> = new NativeArray<Int>();
        var changed : NativeArray<Int> = new NativeArray<Int>();
        var myOldState : NativeIntMap<Float> = _oldGPState.get(i);

        var keys : Iterator<Int>;
        if (o != null) {
            keys = o.keys();
            for (j in keys) {
                if (myOldState.get(j) == o.get(j)) {
                    unchanged.push(j);
                } else {
                    changed.push(j);
                }
            }
        }

        if (myOldState != null) {
            keys = myOldState.keys();
            for (j in keys) {
                if (myOldState.get(j) != o.get(j)) {
                    changed.push(j);
                }
            }
        }
        
        var j : Int = 0;
        while (j < changed.length()) {
            var k : Int = changed.get(j);
            var v : Null<Float> = o.get(k);
            if (v == null) {
                myOldState.remove(k);
            } else {
                myOldState.set(k, v);
            }
            j++;
        }

        if (changed.length() > 0) {
            _gamepad(i, o);
        }
    }

    private function pollGamepads() : Void {
        var clearOldState : NativeArray<Int> = new NativeArray<Int>();
        if (_gamepads <= 0) {
            for (i in _oldGPState.keys()) {
                clearOldState.push(i);
            }
        } else {
            if (_delay <= 0) {
                var gamepads : NativeVector<GamepadInfo> = #if js
                    cast js.Syntax.code("navigator.getGamepads ? navigator.getGamepads() : (navigator.webkitGetGamepads ? navigator.webkitGetGamepads : [])");
                #else
                    // TODO
                #end
                for (i in _oldGPState.keys()) {
                    if (i > gamepads.length()) {
                        clearOldState.push(i);
                    }
                }
                var i : Int = 0;
                while (i < gamepads.length()) {
                    if (_oldGPState.get(i) == null) {
                        _oldGPState.set(i, new NativeIntMap<Float>());
                    }
                    var gp : Null<GamepadInfo> = gamepads.get(i);
                    if (gp != null) {
                        var buttons : NativeVector<GamepadButtonInfo> = gp.buttons;
                        var o : Null<NativeIntMap<Float>> = null;

                        var j : Int = 0;
                        while (j < buttons.length()) {
                            if (buttons.get(j).value != 0) {
                                if (o == null) {
                                    o = new NativeIntMap<Float>();
                                }
                                o.set(j, buttons.get(j).value);
                            }
                            j++;
                        }

                        switch (gp.axes.length()) {
                            case 0: 
                                if (o != null) {
                                    var directionButtons : Int = buttons.length() - 4;
                                    var iUp : Int = directionButtons + 1;
                                    var iDown : Int = directionButtons + 0;
                                    var iLeft : Int = directionButtons + 3;
                                    var iRight : Int = directionButtons + 2;
                                    var x : Int = 0;
                                    var y : Int = 0;

                                    if (o.get(iUp) != 0 && o.get(iUp) != null) {
                                        o.remove(iUp);
                                        y -= 1;
                                    } else if (o.get(iDown) != 0 && o.get(iDown) != null) {
                                        o.remove(iDown);
                                        y += 1;
                                    }

                                    if (o.get(iLeft) != 0 && o.get(iLeft) != null) {
                                        o.remove(iLeft);
                                        x -= 1;
                                    } else if (o.get(iRight) != 0 && o.get(iRight) != null) {
                                        o.remove(iRight);
                                        x += 1;
                                    }

                                    if (x != 0 || y != 0) {
                                        _fieldView.navigateInXY(x, y);
                                    }

                                    var iCount : Int = 0;
                                    var keys : Iterator<Int> = o.keys();
                                    for (j in keys) {
                                        iCount++;
                                        break;
                                    }

                                    if (iCount <= 0) {
                                        o = null;
                                    }

                                    reportButtons(i, o);
                                }
                            case 10: // gp.id - case "PCEngine PAD (Vendor: 0f0d Product: 0138)":
                                var value : Float = Math.floor(gp.axes.get(9) * 10) / 10;
                                if (value > 1.1) {
                                    // Go nowhere
                                } else if (value > 0.75) {
                                    // Upper Left
                                } else if (value > 0.5) {
                                    // Left
                                    _fieldView.navigateInXY(1, 0);
                                } else if (value > 0.3) {
                                    // Down Left
                                } else if (value > 0) {
                                    // Down
                                    _fieldView.navigateInXY(0, -1);
                                } else if (value > -0.3) {
                                    // Down Right
                                } else if (value > -0.6) {
                                    // Right
                                    _fieldView.navigateInXY(-1, 0);
                                } else if (value > -0.9) {
                                    // Up right
                                } else if (value > -1.1) {
                                    // Up
                                    _fieldView.navigateInXY(0, 1);
                                }

                                reportButtons(i, o);
                            default:
                                var x : Float = gp.axes.get(0);
                                var y : Float = gp.axes.get(1);

                                if (x >= 0.10) {
                                    x = -1;
                                } else if (x <= -0.10) {
                                    x = 1;
                                } else {
                                    x = 0;
                                }

                                if (y >= 0.10) {
                                    y = -1;
                                } else if (y <= -0.10) {
                                    y = 1;
                                } else {
                                    y = 0;
                                }

                                if (x != 0 || y != 0) {
                                    _fieldView.navigateInXY(Math.round(x), Math.round(y));
                                }

                                reportButtons(i, o);
                        }
                    }
                    i++;
                }
            }
            setTimeout(pollGamepads, _reduceDelayIntervals);
        }

        for (i in clearOldState) {
            _oldGPState.remove(i);
        }
    }

    public function ongamepadconnected(e : EventInfoInterface) : Void {
        _gamepads++;
        if (_gamepads == 1)
        {
            pollGamepads();
        }
    }

    public function ongamepaddisconnected(e : EventInfoInterface) : Void {
        _gamepads--;
    }    
}
