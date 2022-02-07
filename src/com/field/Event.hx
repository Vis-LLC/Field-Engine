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

@:expose
@:nativeGen
/**
    A possible Event that can have Listeners and be Fired.
**/
class Event {
    private var _listeners : NativeArray<EventInfo<Dynamic, Dynamic, Dynamic>->Void> = new NativeArray<EventInfo<Dynamic, Dynamic, Dynamic>->Void>();
    private var _hasListeners : Bool = false;

    // TODO - Make protected
    public function new() { }

    /**
        Add a Listener for the Event.
    **/
    public function addEventListener(listener : EventInfo<Dynamic, Dynamic, Dynamic>->Void) : Void {
        _listeners.push(listener);
        _hasListeners = true;
    }

    // TODO - Make protected
    /**
        Fire the event, with the specified info.
    **/
    public function fire(ei : EventInfo<Dynamic, Dynamic, Dynamic>) : Void {
        for (f in _listeners) {
            f(ei);
        }
    }

    // TODO - Make protected
    /**
        Indicate that the Event has Listeners.
    **/
    public function markHasListeners() : Void {
        _hasListeners = true;
    }

    /**
        Check to see if the Event has Listeners.
    **/
    public function hasListeners(field : FieldInterface<Dynamic, Dynamic>) : Bool {
        if (_hasListeners) {
            if (_listeners.length() > 0) {
                return true;
            } else {
                var fs : FieldSystemInterface<Dynamic, Dynamic> = cast field;
                return fs.hasListeners(this);
            }    
        } else {
            return false;
        }
    }
}