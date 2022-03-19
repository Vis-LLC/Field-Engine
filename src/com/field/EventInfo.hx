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

import com.field.renderers.Element;

@:expose
@:nativeGen
/**
    The information sent with the firing of an Event.
**/
class EventInfo<F,L,S> {
    private var _field : F;
    private var _sprite : Null<S>;
    private var _location : Null<L>;
    private var _element : Null<Element>;
    private var _fieldElement : Null<Element>;
    private var _event : Event;
    private var _x : Null<Int>;
    private var _y : Null<Int>;
    private var _button : Null<Int>;

    private function new(field : F, location : Null<LocationInterface<Dynamic, Dynamic>>, sprite : Null<SpriteInterface<Dynamic, Dynamic>>, element : Null<Element>, fieldElement : Null<Element>, event : Event, x : Null<Int>, y : Null<Int>, button : Null<Int>) {
        _field = field;
        _sprite = cast sprite;
        _location = cast location;
        _element = element;
        _fieldElement = fieldElement;
        _event = event;
        _x = x;
        _y = y;
        _button = button;
    }

    /**
        Create an EventInfo object for an Event that is connected to a Sprite.
    **/
    public static function spriteEvent(sprite : SpriteInterface<Dynamic, Dynamic>, element : Element, fieldElement : Element, event : Event, button : Null<Int>) {
        return new EventInfo(sprite.field(), null, sprite, element, fieldElement, event, sprite.getX(null), sprite.getY(null), button);
    }

    /**
        Create an EventInfo object for an Event that is connected to a Location.
    **/
    public static function locationEvent(location : LocationInterface<Dynamic, Dynamic>, element : Element, fieldElement : Element, event : Event, button : Null<Int>) {
        return new EventInfo(location.field(), location, null, element, fieldElement, event, location.getX(null), location.getY(null), button);
    }

    /**
        The Field that the Event is associated with.
    **/
    public function field() : F {
        return _field;
    }

    /**
        The Sprite that the Event is associated with.
    **/
    public function sprite() : Null<S> {
        return  _sprite;
    }

    /**
        The Location that the Event is associated with.
    **/
    public function location() : Null<L> {
        return _location;
    }

    /**
        The Element that the Event is associated with.
    **/
    public function element() : Element {
        return _element;
    }    

    /**
        The Element associated with the Field the Event is associated with.
    **/
    public function fieldElement() : Element {
        return _fieldElement;
    }

    /**
        The Event that the EventInfo object is associated with.
    **/
    public function event() : Event {
        return _event;
    }

    /**
        The X coordinate associated with the Event.
    **/
    public function x() : Null<Int> {
        return _x;
    }

    /**
        The Y coordinate associated with the Event.
    **/
    public function y() : Null<Int> {
        return _y;
    }    

    /**
        The Button associated with the Event.
    **/
    public function button() : Null<Int> {
        return _button;
    }    

    /**
        Convert the EventInfo object to a String.
    **/
    public function toString() : String {
        return "field = " + _field;
    }
}