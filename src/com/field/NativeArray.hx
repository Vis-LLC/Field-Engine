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
    An Adapter class that allows all native arrays to be used easily.
**/
abstract NativeArray<V>(
#if js
    Array<V>
#elseif java
    java.util.Map<Int, V>
#elseif cs
    cs.system.collections.IDictionary
#else
    Array<V>
#end
) {
    inline public function new() {
        this = #if js
            new Array<V>()
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            cast new Array<V>()
        #end
        ;
    }

    inline public function set(k : Int, v : Null<V>) : Void {
        #if js
            js.Syntax.code("{0}[{1}] = {2}", this, k, v);
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            this[k] = v;
        #end
    }

    inline public function get(k : Int) : Null<V> {
        #if js
            return this[k];
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            return this[k];
        #end
    }

    inline public function length() : Int {
        #if js
            return this.length;
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            return this.length;
        #end
    }

    inline public function iterator() : Iterator<V> {
        #if js
            return this.iterator();
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            return this.iterator();
        #end
    }

    inline public function push(o : V) : Void {
        #if js
            this.push(o);
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            this.push(o);
        #end
    }

    inline public function pop() : V {
        #if js
            return this.pop();
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            return this.pop();
        #end
    }

    inline public function shift() : V {
        #if js
            return this.shift();
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            return this.shift();
        #end
    }

    inline public function toVector() : NativeVector<V> {
        #if js
            return cast js.Syntax.code("{0}.slice()", this);
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            return haxe.ds.Vector.fromArray(this);
        #end
    }

    inline public function concat(arr : NativeArray<V>) : NativeArray<V> {
        #if js
            return cast this.concat(cast arr);
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            return cast this.concat(cast arr);
        #end
    }

    inline public function preallocate(space : Int) : Void {
        #if js
            this.resize(space);
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            this.resize(space);
        #end
    }

    inline public function sort(compare : V->V->Int) : Void {
        #if js
            this.sort(compare);
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            this.sort(compare);
        #end
    }

    inline public function indexOf(v : V) : Int {
        #if js
            return this.indexOf(v);
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #else
            return this.indexOf(v);
        #end
    }
}