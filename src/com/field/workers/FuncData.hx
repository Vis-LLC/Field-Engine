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
    Allows functions to be converted and sent to WebWorkers in JavaScript.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class FuncData {
    /**
        The awrguments for the function.
    **/
    public var args : String;

    /**
        The body for the function.
    **/
    public var body : String;

    public inline function new(args : String, body : String) {
        this.args = args;
        this.body = body;
    }
}
