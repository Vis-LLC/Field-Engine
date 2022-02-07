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
  Allows for the setting of options for the SdcheduledOperations class.
**/
class ScheduleOperationOptions<T> extends OptionsAbstract<T> {
    public inline function new() { super(); }

    /**
        The Field to run the operation on.
    **/
    public function field(field : FieldInterface<Dynamic, Dynamic>) : T {
        return set("field", field);
    }

    /**
        What to execute when each thread finishes the operation.
    **/
    public function whenDone(whenDone : Void->Void) : T {
        return set("whenDone", whenDone);
    }

    /**
        What to execute when the operation has been completed.
    **/
    public function callback(callback : Null<Any->Any->Int->Int->Void>) : T {
        return set("callback", callback);
    }    
}