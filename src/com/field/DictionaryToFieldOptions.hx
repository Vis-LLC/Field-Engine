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
    Options for converting a dictionary/map to a Field.
**/
class DictionaryToFieldOptions extends FieldOptions<Dynamic, Dynamic> {
    /**
        The dictionary/map to convert to a Field.
    **/    
    public function value(value : NativeStringMap<Any>) : FieldOptions<Dynamic, Dynamic> {
        return set("value", value);
    }

    /**
        The keys to use from thje Dictionary/Map.
    **/
    public function names(names : NativeVector<String>) : FieldOptions<Dynamic, Dynamic> {
        return set("names", names);
    }

    /**
        Create the Field using these options.
    **/
    public function execute() : FieldInterface<Dynamic, Dynamic> {
        return Convert.dictionaryToField(this);
    }
}