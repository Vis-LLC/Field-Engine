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

package com.field;

#if !EXCLUDE_RENDERING

@:nativeGen
/**
    Handles internal event firing and logging for FieldEngine.
**/
class Logger {
    private static var logFor : NativeIntMap<Bool> = new NativeIntMap<Bool>();
    public static var locationView : Int = 10;
    public static var spriteView : Int = 20;
    public static var fieldView : Int = 30;

    public static var locationAdded : Int = 1;
    public static var locationSelect : Int = 2;
    public static var locationHover : Int = 3;

    private static var _mapping : NativeIntMap<Event> = doMapping();

    private static function doMapping() : NativeIntMap<Event> {
        var mapping : NativeIntMap<Event> = new NativeIntMap<Event>();

        mapping.set(Logger.spriteView + Logger.locationHover, Events.spriteHover());
        mapping.set(Logger.spriteView + Logger.locationSelect, Events.spriteSelect());
        mapping.set(Logger.locationView + Logger.locationHover, Events.locationHover());
        mapping.set(Logger.locationView + Logger.locationSelect, Events.locationSelect());

        return mapping;
    }

    //, id : String, message : Any, parent : Any
    /**
        Dispatch, and possibly log, an event for a given Field.
    **/
    public static function dispatch(f : Void->EventInfo<Dynamic, Dynamic, Dynamic>, field : FieldInterface<Dynamic, Dynamic>, t : Int) {
        var event : Null<Event> = _mapping.get(t);
        var eventInfo : Null<EventInfo<Dynamic, Dynamic, Dynamic>> = null;
        if (logFor.get(t)) {
            if (eventInfo == null) {
                eventInfo = f();
            }
            log(eventInfo.toString(), t);
        }
        if (event != null) {
            if (event.hasListeners(field)) {
                if (eventInfo == null) {
                    eventInfo = f();
                }
                event.fire(eventInfo);
            }
        }
    }

    /**
        Possibly log a message for some operation.
    **/
    public static function log(entry : Any, t : Int) {
        if (logFor.get(t)) {
            var isFunction : Bool =
            #if js
                cast js.Syntax.code("(typeof {0} === 'function')", entry);
            #elseif java
                // TODO
                false;
            #elseif python
                cast python.Syntax.code("hasattr({0}, '__call__')", entry);
            #elseif cs
                // TODO
                false;
            #elseif lua
                // TODO
                false;
                //cast lua.Syntax.code("type({0}) == 'function'", entry);
            #elseif php
                cast php.Syntax.code("is_callable({0})", entry);
            #elseif hl
                cast Reflect.isFunction(entry);
            #elseif cpp
                false;
            #else
                // TODO
            #end

            var v : Any;
            if (isFunction) {
                var f : Void->String = cast entry;
                v = f();
            } else {
                v = entry;
            }

            var sb : StringBuf = new StringBuf();
            sb.add(cast v);
            #if js
                js.Syntax.code("console.log({0})", sb.toString());
            #elseif php
                php.Syntax.code("error_log({0})", sb.toString());
            #else
                // TODO
            #end
        }
    }
}
#end