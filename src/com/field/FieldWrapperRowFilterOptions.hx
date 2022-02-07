
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
    Allows for the setting of options for the FieldWrapperRowFilter class.
**/
class FieldWrapperRowFilterOptions<L, S> extends OptionsAbstract<FieldWrapperRowFilterOptions<L, S>> {
    public inline function new() { super(); }
    
    private var _filters : Int = 0;

    /**
        The Field to wrap.
    **/
    public function field(field : FieldInterface<L, S>) : FieldWrapperRowFilterOptions<L, S> {
        return set("field", field);
    }

    /**
        Allow rows that have non-zero values in the first column.
    **/
    public function allowNonZero() : FieldWrapperRowFilterOptions<L, S> {
        return blockHasValue(0);
    }

    /**
        Allow rows that have the specified value in the first column.
    **/
    public function allowHasValue(value : Dynamic) : FieldWrapperRowFilterOptions<L, S> {
        return allowColumnHasValue(1, value);
    }

    private function filter(column : Int, attr : Null<String>, value : Dynamic, allow : Bool) : FieldWrapperRowFilterOptions<L, S> {
        set("filterOnColumn" + _filters, column);
        set("filterOnColumnValue" + _filters, value);
        set("filterOnColumnAttr" + _filters, attr);
        return set("filterOnColumnAllow" + _filters++, allow);
    }

    /**
        Allow rows that have the specified value in the specified attribute in the specified column.
    **/
    public function allowColumnHas(column : Int, attr : String, value : Dynamic) : FieldWrapperRowFilterOptions<L, S> {
        return filter(column, attr, value, true);
    }

    /**
        Allow rows that have the specified value in the specified column.
    **/
    public function allowColumnHasValue(column : Int, value : Dynamic) : FieldWrapperRowFilterOptions<L, S> {
        return filter(column, null, value, true);
    }

    /**
        Block rows that have the specified value in the specified attribute in the specified column.
    **/
    public function blockColumnHas(column : Int, attr : String, value : Dynamic) : FieldWrapperRowFilterOptions<L, S> {
        return filter(column, attr, value, false);
    }

    /**
        Block rows that have the specified value in the first column.
    **/
    public function blockHasValue(value : Dynamic) : FieldWrapperRowFilterOptions<L, S> {
        return blockColumnHasValue(1, value);
    }

    /**
        Block rows that have the specified value in the specified column.
    **/
    public function blockColumnHasValue(column : Int, value : Dynamic) : FieldWrapperRowFilterOptions<L, S> {
        return filter(column, null, value, false);
    }

    /**
        Allow the wrapped Field to passthrough its Locations as is.
    **/
    public function passThroughLocations(passThroughLocations : Bool) : FieldWrapperRowFilterOptions<L, S> {
        return set("passThroughLocations", passThroughLocations);
    }

    /**
        Creates a FieldWrapperRowFilter based on the options.
    **/
    public function execute() : FieldWrapperRowFilter<L, S> {
        return cast FieldWrapperRowFilter.create(cast this);
    }
}
