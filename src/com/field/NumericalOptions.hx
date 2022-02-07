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
    Defines the parameters for numbers used by Attributes for Locations or Sprites on a Field.
**/
class NumericalOptions extends OptionsAbstract<NumericalOptions> {
    public inline function new() { super(); }

    /**
        Defines the precision of a number.  Default is null.
    **/
    public function digitsAfterDecimal(o : Int) : NumericalOptions {
        return set("digitsAfterDecimal", o);
    }

    /**
        Defines the max value of a number.  Default is null.
    **/
    public function max(o : Float) : NumericalOptions {
        return set("max", o);
    }

    /**
        Converts to the internally used Numerical type.
    **/
    public function toNumerical() : Numerical {
        var m : NativeStringMap<Any> = toMap();
        var n : Numerical = new Numerical(cast m.get("max"), cast m.get("digitsAfterDecimal"));
        return n;
    }
}