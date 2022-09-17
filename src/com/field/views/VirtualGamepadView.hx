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

#if !EXCLUDE_RENDERING
import com.field.renderers.Element;
import com.field.renderers.Style;

@:expose
@:nativeGen
/**
    Displays a virtual Gamepad for use by touch screens.
**/
class VirtualGamepadView extends AbstractView {
    private static var sGamepad : String = "<!-- source for gradient: https://projects.verou.me/css3patterns/#carbon -->
    <style>
        div.gamepad {
            border: solid;
            border-radius: 50%;
            margin: 0px;
            width: 25vmin;
            height: 25vmin;
            background: gray;
            opacity: 50%;
            background:
                linear-gradient(27deg, #151515 5px, transparent 5px) 0 5px,
                linear-gradient(207deg, #151515 5px, transparent 5px) 10px 0px,
                linear-gradient(27deg, #222 5px, transparent 5px) 0px 10px,
                linear-gradient(207deg, #222 5px, transparent 5px) 10px 5px,
                linear-gradient(90deg, #1b1b1b 10px, transparent 10px),
                linear-gradient(#1d1d1d 25%, #1a1a1a 25%, #1a1a1a 50%, transparent 50%, transparent 75%, #242424 75%, #242424);
            background-color: #131313;
            background-size: 20px 20px;
            margin-left:-50%;
            margin-top:-50%;
        }
    
        div.gamepad td.button {
            background-color: lightgray;
        }
    
        div.gamepad td.button.up {
            border-top: solid;
            border-left: solid;
            border-right: solid;
        }
    
        div.gamepad.pressed_up td.button.up,
        div.gamepad.pressed_left td.button.left,
        div.gamepad.pressed_right td.button.right,
        div.gamepad.pressed_down td.button.down {
            background-color: black !important;
        }
    
        div.gamepad td.button.left {
            border-top: solid;
            border-left: solid;
            border-bottom: solid;
        }
    
        div.gamepad td.button.right {
            border-top: solid;
            border-right: solid;
            border-bottom: solid
        }
    
        div.gamepad td.button.down {
            border-bottom: solid;
            border-left: solid;
            border-right: solid;
        }
    
        div.gamepad table {
            border-collapse: collapse;
            margin: 0px;
            width: 100%;
            height: 100%;
        }
    
        div.gamepad table tr,
        div.gamepad td {
            border-top: none;
            border-bottom: none;
            border-left: none;
            border-right: none;
            margin: 0px;
        }
    
        div.gamepad>table>tbody>tr>td {
            width: 5%;
            height: 5%;
        }
    </style>
    <div class='gamepad'>
        <table>
            <tr>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td style='height:90%;width:90%;'>
                    <table>
                        <tr>
                            <td></td>
                            <td class='button up'></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td class='button left'></td>
                            <td class='button'></td>
                            <td class='button right'></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td class='button down'></td>
                            <td></td>
                        </tr>
                    </table>
                </td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td></td>
            </tr>
    </div>";

    private static var GAMEPAD_STYLE : Style = cast "gamepad";
    private static var PRESSED_LEFT : Style = cast "pressed_left";
    private static var PRESSED_RIGHT : Style = cast "pressed_right";
    private static var PRESSED_UP : Style = cast "pressed_up";
    private static var PRESSED_DOWN : Style = cast "pressed_down";
    
    private static var _instance : Null<VirtualGamepadView> = null;

    private var _childrenAsVector : NativeVector<Element> = null;

    private function new() {
        super();
        _element = getElement();
        #if js
            js.Syntax.code("{0}.style.position = 'absolute'; {0}.style.zIndex = 100000; {0}.innerHTML = {1}", _element, sGamepad);
        #else
            // TODO
        #end
    }

    /**
        Move virtual gamepad to an element as a child and the specified xy coordinates.
    **/
    public function set(e : Element, x : Int, y : Int, inputSettings : InputSettings) : Void {
        #if js
            e = cast js.Syntax.code("document.body");
        #else
            // TODO
        #end
        if (getParent(e) != e) {
            appendChild(e, _element);
        }
        #if js
            js.Syntax.code("{0}.style.left = {1} + 'px'; {0}.style.top = {2} + 'px'", _element, x, y);
        #else
            // TODO
        #end
        setOnClick(_element, inputSettings);
        setOnDblClick(_element, inputSettings);
        setOnTouchStart(_element, inputSettings);
        setOnTouchCancel(_element, inputSettings);
        setOnTouchMove(_element, inputSettings);
        setOnTouchEnd(_element, inputSettings);
        setOnMouseDown(_element, inputSettings);
        setOnMouseUp(_element, inputSettings);
        setOnMouseOver(_element, inputSettings);
        setOnKeyDown(_element, inputSettings);
        setOnGamepadConnected(_element, inputSettings);
        setOnGamepadDisconnected(_element, inputSettings);        
    }

    /**
        Get an instance of the virtual gamepad.
    **/
    public static function get() : VirtualGamepadView {
        if (_instance == null) {
            _instance = new VirtualGamepadView();
        }
        return _instance;
    }

    /**
        Press a button on the virtual gamepad using xy coordinates.
    **/
    public function press(x : Float, y : Float) : Void {
        if (_childrenAsVector == null) {
            _childrenAsVector = getChildrenAsVector(_element);
        }
        var inner : Element = null;
        var i : Int = 0;

        while (i < _childrenAsVector.length()) {
            var e : Element = _childrenAsVector.get(i);
            var sType : Null<String> = #if js
                js.Syntax.code("{0}.tagName", _element);
            #else
                // TODO
            #end
            if (sType != null) {
                switch (sType.toUpperCase()) {
                    case "DIV":
                        inner = e;
                }
            }
            i++;
        }

        var sStyle : Style = GAMEPAD_STYLE;
        if (x > 0) {
            sStyle = combineStyles(sStyle, PRESSED_LEFT);
        } else if (x < 0) {
            sStyle = combineStyles(sStyle, PRESSED_RIGHT);
        }

        if (y > 0) {
            sStyle = combineStyles(sStyle, PRESSED_UP);
        } else if (y < 0) {
            sStyle = combineStyles(sStyle, PRESSED_DOWN);
        }

        setStyle(inner, sStyle);
    }

    /**
        Remove from the virtual gamepad from the display.
    **/
    public function remove() : Void {
        #if js
            js.Syntax.code("{0}.parentNode.removeChild({0})", _element);
        #else
            // TODO
        #end
    }
}
#end