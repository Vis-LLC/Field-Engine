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

@:expose
@:nativeGen
/**
  Allows for the setting of options for the FindPath class.
**/
class FindPathOptions extends ScheduleOperationOptions<FindPathOptions> {
    public inline function new() { super(); }

    /**
        The map used for caching data between calls to FindPath.
    **/
    public function cache(cache : NativeIntMap<Any>) : FindPathOptions {
        return set("cache", cache);
    }

    /**
        Starting X coordinate for the path.
    **/
    public function startX(startX : Int) : FindPathOptions {
        return set("startX", startX);
    }

    /**
        Starting Y coordinate for the path.
    **/
    public function startY(startY : Int) : FindPathOptions {
        return set("startY", startY);
    }

    /**
        Ending X coordinate for the path.
    **/
    public function endX(endX : Int) : FindPathOptions {
        return set("endX", endX);
    }

    /**
        Ending Y coordinate for the path.
    **/
    public function endY(endY : Int) : FindPathOptions {
        return set("endY", endY);
    }

   /**
        The limit for long the path can be.
    **/
    public function distanceLimit(distanceLimit : Int) : FindPathOptions {
        return set("distanceLimit", distanceLimit);
    }

   /**
        The limit for many hops a path can be.
    **/
    public function hopLimit(hopLimit : Int) : FindPathOptions {
        return set("hopLimit", hopLimit);
    }

    /**
        Set function for determining what locations can be entered.
    **/
    public function canEnter(canEnter : Null<Any->Any->Any->Any->Bool>) : FindPathOptions {
        return set("canEnter", canEnter);
    }    

    public override function toMap() : NativeStringMap<Any> {
        var o : NativeStringMap<Any> = super.toMap();
        var f : FieldInterface<Dynamic, Dynamic> = cast o.get("field");
        var startX : Int = cast o.get("startX");
        var startY : Int = cast o.get("startY");
        var endX : Int = cast o.get("endX");
        var endY : Int = cast o.get("endY");

        o.set("id", f.id() + "-FindPath-" + startY + "," + startY + "-" + endX + "," + endY);

        return o;
    }

    /**
        Schedule an execution FindPath with the specified options.
    **/
    public function schedule() : Void {
        FindPath.schedule(this);
    }

    /**
        Execute FindPath with the specified options.
    **/
    public function execute() : FindPathResult {
        return FindPath.immediate(this);
    }    
}