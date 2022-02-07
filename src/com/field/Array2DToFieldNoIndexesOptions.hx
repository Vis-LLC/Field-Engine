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
    Options for converting a 2D array to a Field.
**/
class Array2DToFieldNoIndexesOptions extends FieldOptions<Dynamic, Dynamic> {
    /**
        The 2D Array to convert to a Field.
    **/
    public function value(value : NativeVector<NativeVector<Any>>) : FieldOptions<Dynamic, Dynamic> {
        return set("value", value);
    }

    /**
        Create the Field using these options.
    **/
    public function execute() : FieldInterface<Dynamic, Dynamic> {
        return Convert.array2DToFieldNoIndexes(this);
    }
}