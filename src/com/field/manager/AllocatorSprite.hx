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

package com.field.manager;

/**
    Defines a Factory class for allocating Sprites of a Field in memory.
    These functions are not meant to used externally, only internally to the FieldEngine library.    
**/
@:nativeGen
class AllocatorSprite<T> implements Allocator<T> {
    public function allocate() : T {
        return null;
    }

    public function recommendedArray(x : Int, y : Int, fill : Bool) : Pool<T> {
        if (x < 0) {
            return new PoolArray<T>(this);
        } else {
            return new PoolVector<T>(this, x);
        }
    }

    public function recommendedMap(x : Int, y : Int, fill : Bool) : Pool<T> {
        return new PoolMap<T>(this);
    }

    public function nullPool() : Pool<T> {
        return new PoolNull<T>();
    }

    public function simpleArray(x : Int, y : Int, fill : Bool) : Pool<T> {
        if (x < 0) {
            return new PoolArray<T>(this);
        } else {
            return new PoolVector<T>(this, x);
        }
    }

    public function getX(o : T) : Int {
        #if js
            return (cast o).getI();
        #else
            return cast(o, SpriteInterface<Dynamic, Dynamic>).getI();
        #end
    }

    public function getY(o : T) : Int {
        return -1;
    }
}