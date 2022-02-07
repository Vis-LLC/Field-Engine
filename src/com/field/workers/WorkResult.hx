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

package com.field.workers;

@:nativeGen
/**
    Allows the results for a unit of work to be sent back.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class WorkResult {
    /**
        The data that resulted from the function being executed.
    **/
    public var data : Any;

    /**
        The error that occurred when running the function.
    **/
    public var err : Any;

    /**
        The identification id for the job.
    **/
    public var job : Int;

    public inline function new(data : Any, err : Any, job : Int) {
        this.data = data;
        this.err = err;
        this.job = job;
    }
}