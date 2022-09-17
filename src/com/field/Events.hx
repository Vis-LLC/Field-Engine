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
@:expose
@:nativeGen
/**
    The complete set of Events that can have Listeners attached to them.
**/
class Events {
    private static var _locationHover : Event = new Event();
    private static var _locationSelect : Event = new Event();
    private static var _spriteHover : Event = new Event();
    private static var _spriteSelect : Event = new Event();

    /**
        An Event for capturing the mouse cursor hovering over a Location.
    **/
    public static function locationHover() : Event {
        return _locationHover;
    }

    /**
        An Event for capturing a select of a Location.
    **/
    public static function locationSelect() : Event {
        return _locationSelect;
    }

    /**
        An Event for capturing the mouse cursor hovering over a Sprite.
    **/
    public static function spriteHover() : Event {
        return _spriteHover;
    }

    /**
        An Event for capturing a select of a Sprite.
    **/
    public static function spriteSelect() : Event {
        return _spriteSelect;
    }
}
#end