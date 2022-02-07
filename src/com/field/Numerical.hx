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
    Internal type that defines the parameters for numbers used by Attributes for Locations or Sprites on a Field.
**/
class Numerical {
    public inline function new(?max : Float = 0, ?digitsAfterDecimal : Int = 0) {
        this.max = max;
        this.digitsAfterDecimal = digitsAfterDecimal;
    }

    /**
        Defines the precision of a number.  Default is null.
    **/
    public var digitsAfterDecimal : Int;

    /**
        Defines the max value of a number.  Default is null.
    **/
    public var max : Float;
}