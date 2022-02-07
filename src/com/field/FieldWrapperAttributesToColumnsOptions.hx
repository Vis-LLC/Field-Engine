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
    Allows for the setting of options for the FieldWrapperAttributesToColumnsOptions class.
**/
class FieldWrapperAttributesToColumnsOptions<L, S> extends OptionsAbstract<FieldWrapperAttributesToColumnsOptions<L, S>> {
    public inline function new() { super(); }

    private var _columns : Int = 0;

    /**
        The Field to wrap.
    **/
    public function field(field : FieldInterface<L, S>) : FieldWrapperAttributesToColumnsOptions<L, S> {
        return set("field", field);
    }

    /**
        A column to convert to multiple columns based on it's Attributes.
    **/
    public function toColumn(column : String) : FieldWrapperAttributesToColumnsOptions<L, S> {
        return set("column" + _columns++, column);
    }

    /**
        Do the conversion on all columns of the Field.
    **/
    public function doAllColumns() : FieldWrapperAttributesToColumnsOptions<L, S> {
        return set("doAll", true);
    }

    /**
        Creates a FieldWrapperAttributesToColumnsOptions based on the options.
    **/
    public function execute() : FieldWrapperAttributesToColumns<L, S> {
        return cast FieldWrapperAttributesToColumns.create(cast this);
    }    
}
