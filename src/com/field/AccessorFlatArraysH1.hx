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

@:nativeGen
/**
    Finishes defining a complete Concrete Strategy for how to manipulate a Field internally, where the Field is a one dimensional array internally and has any width or number of attributes and a height of 1 externally.
**/
class AccessorFlatArraysH1 extends AccessorFlatArrays {
    private function new(data : Null<AccessorFlatArraysData>) {
        super(data);
    }

    public static function wrap(data : AccessorFlatArraysData) : AccessorInterface {
        return new AccessorFlatArraysH1(data);
    }

    public override function getRows() : Int {
        return 1;
    }

    public override function getX(i : Int) : Int {
        return Math.floor(i / getLocationAttributeCount());
    }

    public override function getY(i : Int) : Int {
        return 0;
    }

    public override function moveRow(i : Int, y : Int) : Int {
        return i;
    }

    public override function moveColumn(i : Int, x : Int) : Int {
        return i + x * getLocationAttributeCount();
    }
}