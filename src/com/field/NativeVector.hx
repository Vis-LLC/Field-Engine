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
    An Adapter class that allows all native vectors to be used easily.
**/
abstract NativeVector<V>(
#if js
    Array<V>
#elseif java
    java.util.Map<Int, V>
#elseif cs
    cs.system.collections.IDictionary
#elseif php
    Dynamic
#else
    haxe.ds.Vector<V>
#end
) {
    inline public function new(i : Int) {
        this = #if js
            new Array<V>();
            this.resize(i)
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #elseif php
            cast php.Syntax.code("new SplFixedArray({0})", i)
        #else
            cast new haxe.ds.Vector<V>(i)
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
        #elseif php
            php.Syntax.code("{0}[{1}] = {2}", this, k, v);
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
        #elseif php
            return cast php.Syntax.code("{0}[{1}]", this, k);
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
        #elseif php
            return cast php.Syntax.code("{0}.getSize()", this);
        #else
            return this.length;
        #end
    }

    inline public function toArray() : NativeArray<V> {
        #if js
            return cast js.Syntax.code("{0}.slice()", this);
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #elseif php
            return cast php.Syntax.code("{0}.toArray()", this);
        #else
            return haxe.ds.Vector.toArray(this);
        #end
    }

    inline public function indexOf(v : V) : Int {
        #if js
            return this.indexOf(v);
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #elseif php
            var i : Int = 0;
            while (i < length()) {
                if (get(i) == v) {
                    break;
                }
                i++;
            }
            if (i >= length()) {
                i = -1;
            }
            return i;
        #else
            return this.indexOf(v);
        #end
    }    

    inline public function iterator() : Iterator<V> {
        #if js
            return this.iterator();
        #elseif java
            // TODO
        #elseif cs
            // TODO
        #elseif php
            return new NativeVectorIterator<V>(this);
        #else
            return this.iterator();
        #end
    }
}

#if php
@:expose
@:nativeGen
class NativeVectorIterator<V> {
    private var _i : Int = 0;
    private var _v : NativeVector<V>;

    public function new(v : NativeVector<V>) {
        _v = v;
    }

    public function next() : V {
        if (hasNext()) {
            return _v.get(_i++);
        } else {
            return null;
        }
    }

    public function hasNext() : Bool {
        return _i < _v.length();
    }
}
#end