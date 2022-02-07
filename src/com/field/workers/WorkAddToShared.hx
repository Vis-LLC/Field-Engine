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

#if js
    @:nativeGen
    /**
        Adds data/functions to the cache on all the JavaScript Web Workers.
        These functions are not meant to used externally, only internally to the FieldEngine library.
    **/
    class WorkAddToShared {
        /**
            Key to access the shared data.
        **/
        public var k : Any;

        /**
            Data to store.
        **/
        public var v : Any;

        public inline function new(k : Any, v : Any) {
            this.k = k;
            this.v = v;
        }
    }
#end