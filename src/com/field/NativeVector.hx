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
/* TODO
#elseif java
    java.NativeArray<V>
*/
#elseif python
    Any
#elseif cs
    cs.system.Array
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
        /* TODO
        #elseif java
            new java.NativeArray<V>(i)
        */
        #elseif python
            python.Syntax.code("[None] * {0}", i)
        #elseif cs
            new cs.NativeArray(i)
        #elseif php
            cast php.Syntax.code("new SplFixedArray({0})", i)
        #else
            cast new haxe.ds.Vector<V>(i)
        #end
        ;
    }

    inline public static function fromIterator<V>(it : Iterator<V>) : NativeVector<V> {
        return NativeArray.fromIterator(it).toVector();
    }

    inline public function set(k : Int, v : Null<V>) : Void {
        #if js
            js.Syntax.code("{0}[{1}] = {2}", this, k, v);
        /* TODO
        #elseif java
            this[k] = v;
        */
        #elseif python
            python.Syntax.code("{0}[{1}] = {2}", this, k, v);
        #elseif cs
            this.SetValue(v, k);
        #elseif php
            php.Syntax.code("{0}[{1}] = {2}", this, k, v);
        #else
            this[k] = v;
        #end
    }

    inline public function get(k : Int) : Null<V> {
        #if js
            return this[k];
        /* TODO
        #elseif java
            return this[k];
        */
        #elseif python
            return cast python.Syntax.code("{0}[{1}]", this, k);
        #elseif cs
            return cast this.GetValue(k);
        #elseif php
            return cast php.Syntax.code("{0}[{1}]", this, k);
        #else
            return this[k];
        #end
    }

    inline public function length() : Int {
        #if js
            return this.length;
        /* TODO
        #elseif java
            return this.length;
        */
        #elseif python
            return cast python.Syntax.code("len({0})", this);
        #elseif cs
            return this.Length;
        #elseif php
            return cast php.Syntax.code("{0}.getSize()", this);
        #else
            return this.length;
        #end
    }

    inline public function toArray() : NativeArray<V> {
        #if js
            return cast js.Syntax.code("{0}.slice()", this);
        /* TODO
        #elseif java
            return cast java.util.Arrays.asList(this);
        */
        #elseif python
            return cast python.Syntax.code("{0}.copy()", this);
        #elseif cs
            //return cast new cs.system.collections.ArrayList(cast this);
            return cast null;
        #elseif php
            return cast php.Syntax.code("{0}.toArray()", this);
        #else
            return cast this.toArray();
        #end
    }

    inline public function indexOf(v : V) : Int {
        #if js
            return this.indexOf(v);
        /* TODO
        #elseif java
            return java.util.Arrays.binarySearch(this, v);
        */
        #elseif python
            return cast python.Syntax.code("{0}.index({1})", this, v);
        #elseif cs
            return cs.system.Array.IndexOf(cast this, v);
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
        #end
    }    

    inline public function iterator() : Iterator<V> {
        #if js
            return this.iterator();
        /* TODO
        #elseif java
            return new NativeVectorIterator<V>(cast this);
        */
        #elseif python
            var it : python.NativeIterator<V> = cast python.Syntax.code("{0}.__iter__", this);
            return it.toHaxeIterator();
        #elseif cs
            // return this.GetEnumerator();
            return new NativeVectorIterator<V>(cast this);
        #elseif php
            return new NativeVectorIterator<V>(cast this);
        #else
            return new NativeVectorIterator<V>(cast this);
        #end
    }
}

#if(php || hl || cs || java || lua || cpp)
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