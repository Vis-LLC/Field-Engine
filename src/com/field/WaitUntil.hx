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
    Executes a given function when all operations that are being waited on are completed.
**/
class WaitUntil {
    private var _wait : Int = 0;
    private var _done : Int = 0;
    private var _run : Void->Void;

    /**
        Creates a new instance that will run the specified function on completetion.
    **/
    public function new(run : Void->Void) {
        _run = run;
    }

    /**
        Indicate that an operation is being waited on.
    **/
    public function mustWait() : Void {
        _wait++;
    }

    /**
        An operation that is being waited on has been completed.
    **/
    public function done() : Void {
        _done++;
        if (_done == _wait) {
            _run();
        }
    }
}