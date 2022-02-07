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

package com.field.search;

import com.field.NativeStringMap;
import com.field.workers.WorkerGPGPUMethod;

@:expose
@:nativeGen
/**
  Allows for the setting of options for the FindPath class.
**/
class FindPathsOptions extends OptionsAbstract<FindPathsOptions> {
    public inline function new() { super(); }

    /**
        The limit for many hops a path can be.
    **/
    public function hopLimit(hopLimit : Int) : FindPathsOptions {
        return set("hopLimit", hopLimit);
    }

    /**
        Set a callback for the routine.
    **/
    public function callback(callback : FindPathsResult -> Void) : FindPathsOptions {
        return set("callback", callback);
    }

    /**
        Sets up a cache object for code for FindPaths.
    **/
    public function cache(cache : NativeStringMap<WorkerGPGPUMethod>) : FindPathsOptions {
        return set("cache", cache);
    }

    /**
    **/
    public function field(field : FieldInterface<Any, Any>) : FindPathsOptions {
        return set("field", field);
    }

    /**
        Set up a destination for the FindPaths operation.
    **/
    public function addDestDirect(x : Int, y : Int, attributeToCheck : Int, attributeValue : Int, attributeOperation : Int) : FindPathsOptions {
        var dests : Null<NativeArray<Int>> = get("dests");
        if (dests == null) {
            dests = new NativeArray<Int>();
            set("dests", dests);
        }
        dests.push(x);
        dests.push(y);
        dests.push(attributeToCheck);
        dests.push(attributeValue);
        dests.push(attributeOperation);
        return this;
    }

    /**
        Execute FindPaths with the specified options.
    **/
    public function execute() : Void {
        FindPaths.execute(this);
    }
}