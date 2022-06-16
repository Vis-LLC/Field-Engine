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

package com.field.renderers;

@:nativeGen
/**
    A Bridge for determining how event information is retrieved from DOM (Document Object Model) events.
**/
class EventInfoDOM {
    private var _event : js.html.Event;

    public function new(event : js.html.Event) {
        _event = event;
    }

    public function preventDefault() : Void {
        _event.preventDefault();
    }

    public function getX() : Int {
        #if js
        if (cast js.Syntax.code("!!({0}.touches)", _event)) {
            return cast js.Syntax.code("{0}.touches[0].clientX", _event);
        } else {
            return cast js.Syntax.code("{0}.clientX", _event);
        }
        #else
        #end
    }

    public function getY() : Int {
        #if js
            if (cast js.Syntax.code("!!({0}.touches)", _event)) {
                return cast js.Syntax.code("{0}.touches[0].clientY", _event);
            } else {
                return cast js.Syntax.code("{0}.clientY", _event);
            }
        #else
        #end
    }

    public function target() : Null<Element> {
        #if js
            return cast js.Syntax.code("{0}.target", _event);
        #else
        #end
    }

    public function keyCode() : Int {
        #if js
            return cast js.Syntax.code("{0}.which", _event);
        #else
        #end
    }

    public function buttons() : Int {
        #if js
            switch (cast js.Syntax.code("{0}.pointerType", _event)) {
                case "mouse":
                    return cast js.Syntax.code("{0}.button", _event);
                default:
                    switch (cast js.Syntax.code("{0}.type", _event)) {
                        case "touchend":
                            return cast js.Syntax.code("{0}.touches.length", _event);
                        default:
                            return cast js.Syntax.code("{0}.buttons", _event);
                    }
            }
        #else
        #end
    }

    public function key() : String {
        #if js
            return cast js.Syntax.code("{0}.key", _event);
        #else
        #end
    }

    public static function wrapObject(e : js.html.Event) : EventInfoDOM {
        return new EventInfoDOM(e);
    }
    
    public static function wrapFunction(f : EventInfoInterface -> Void, r : Dynamic) : js.html.Event -> Void {
        #if js
            return cast js.Syntax.code("function (e) { {1}({0}(e)); return {2}; }", wrapObject, f, r);
        #else
        #end
    }
}