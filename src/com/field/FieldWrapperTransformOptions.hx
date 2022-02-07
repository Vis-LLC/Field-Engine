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
@:expose
/**
    Allows for the setting of options for the FieldWrapperTransform class.
**/
class FieldWrapperTransformOptions<L, S> extends OptionsAbstract<FieldWrapperTransformOptions<L, S>> {
    public inline function new() { super(); }

    /**
        Move the X coordinates by the specified amount.
    **/
    public function translateX(translateX : Int) : FieldWrapperTransformOptions<L, S> {
        return set("translateX", translateX);
    }

    /**
        Move the Y coordinates by the specified amount.
    **/
    public function translateY(translateY : Int) : FieldWrapperTransformOptions<L, S> {
        return set("translateY", translateY);
    }

    /**
        Reverse the X coordinates
    **/
    public function reverseX(reverseX : Bool) : FieldWrapperTransformOptions<L, S> {
        return set("reverseX", reverseX);
    }

    /**
        Reverse the Y coordinates
    **/
    public function reverseY(reverseY : Bool) : FieldWrapperTransformOptions<L, S> {
        return set("reverseY", reverseY);
    }

    /**
        Switch the X and Y axis.
    **/
    public function flipXY(flipXY : Bool) : FieldWrapperTransformOptions<L, S> {
        return set("flipXY", flipXY);
    }

    /**
        The Field to wrap.
    **/
    public function field(field : FieldInterface<L, S>) : FieldWrapperTransformOptions<L, S> {
        return set("field", field);
    }

    /**
        Creates a FieldWrapperTransform based on the options.
    **/
    public function execute() : FieldWrapperTransform<L, S> {
        return cast FieldWrapperTransform.create(cast this);
    }  
}
