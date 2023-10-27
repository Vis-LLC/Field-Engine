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

import haxe.Http;

@:nativeGen
/**
    An Adapter class that allows all native arrays to be used easily.
**/
abstract NativeArray<V>(
#if js
    Array<V>
/* TODO
#elseif java
    java.util.List<V>
*/
#elseif python
    Any
#elseif cs
    cs.system.collections.ArrayList
#elseif php
    php.NativeIndexedArray<V>
#else
    Array<V>
#end
) {
    inline public function new() {
        this = #if js
            new Array<V>()
        /* TODO
        #elseif java
            new java.util.ArrayList<V>()
        */
        #elseif python
            python.Syntax.code("[]")
        #elseif cs
            new cs.system.collections.ArrayList()
        #elseif php
            new php.NativeIndexedArray<V>()
        #else
            cast new Array<V>()
        #end
        ;
    }

    inline public static function fromIterator<V>(it : Iterator<V>) : NativeArray<V> {
        var v : NativeArray<V> = new NativeArray<V>();
        while (it.hasNext()) {
            v.push(it.next());
        }
        return v;
    }

    inline public function set(k : Int, v : Null<V>) : Void {
        #if js
            js.Syntax.code("{0}[{1}] = {2}", this, k, v);
        /* TODO
        #elseif java
            this.set(k, v);
        */
        #elseif python
            python.Syntax.code("{0}[{1}] = {2}", this, k, v);            
        #elseif cs
            this.set_Item(k, v);
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
            return this.get(k);
        */
        #elseif python
            return cast python.Syntax.code("{0}[{1}]", this, k);            
        #elseif cs
            return this.get_Item(k);
        #elseif php
            return this[k];
        #else
            return this[k];
        #end
    }

    inline public function join(s : String) : String {
        #if js
            return this.join(s);
        /* TODO
        #elseif java
            var sb : StringBuf = new StringBuf();
            var i : Int = 0;
            while (i < this.size()) {
                sb.add(this.get(i));
                if (i < this.size() - 1) {
                    sb.add(s);
                }
                i++;
            }
            return sb.toString();
        */
        #elseif python
            return cast python.Syntax.code("{0}.join({1})", s, this);
        #elseif cs
            return cast cs.system.String.Join(s, cast this.ToArray());
        #elseif php
            // TODO
        #else
            return this.join(s);
        #end
    }

    inline public function remove(v : V) : Void {
        #if js
            this.remove(v);
        /* TODO
        #elseif java
            this.remove(v);
        */
        #elseif python
            python.Syntax.code("{0}.remove({1})", this, v);
        #elseif cs
            this.Remove(v);
        #elseif php
            // TODO
        #else
            this.remove(v);
        #end
    }    

    inline public function length() : Int {
        #if js
            return this.length;
        /* TODO
        #elseif java
            return this.size();
        */
        #elseif python
            return cast python.Syntax.code("len({0})", this);
        #elseif cs
            return this.Count;
        #elseif php
            return php.Syntax.code("count({0})", this);
        #else
            return this.length;
        #end
    }

    inline public function iterator() : Iterator<V> {
        #if js
            return this.iterator();
        /* TODO
        #elseif java
            return this.iterator();
        */
        #elseif python
            var it : python.NativeIterator<V> = cast python.Syntax.code("{0}.__iter__", this);
            return it.toHaxeIterator();
        #elseif cs
            var o1 : cs.NativeArray<V> = new cs.NativeArray(this.Count);
            this.CopyTo(o1, 0);        
            return new NativeVector.NativeVectorIterator(cast o1);
        #elseif php
            return this.iterator();
        #else
            return this.iterator();
        #end
    }

    inline public function push(o : V) : Void {
        #if js
            this.push(o);
        /* TODO
        #elseif java
            this.add(o);
        */
        #elseif python
            python.Syntax.code("{0}.append({1})", this, o);
        #elseif cs
            this.Add(o);
        #elseif php
            this.push(o);
        #else
            this.push(o);
        #end
    }

    inline public function pop() : V {
        #if js
            return this.pop();
        /* TODO
        #elseif java
            return this.remove(this.size() - 1);
        */
        #elseif python
            return cast python.Syntax.code("{0}.pop()", this);
        #elseif cs
            var i : Int = this.Count - 1;
            var o : V = this.get_Item(i);
            this.RemoveAt(i);
            return o;
        #elseif php
            return cast php.Syntax.code("array_pop({0})", this);
        #else
            return this.pop();
        #end
    }

    inline public function shift() : V {
        #if js
            return this.shift();
        /* TODO
        #elseif java
            return this.remove(0);
        */
        #elseif python
            var v : V = cast python.Syntax.code("{0}[0]", this);
            python.Syntax.code("del {0}[0]", this);
            return v;
        #elseif cs
            var o : V = this.get_Item(0);
            this.RemoveAt(0);
            return o;
        #elseif php
            return cast php.Syntax.code("array_shift({0})", this);
        #else
            return this.shift();
        #end
    }

    inline public function toVector() : NativeVector<V> {
        #if js
            return cast js.Syntax.code("{0}.slice()", this);
        /* TODO
        #elseif java
            return cast this.toArray();
        */
        #elseif python
            return cast python.Syntax.code("{0}.copy()", this);
        #elseif cs
            return cast this.ToArray();
        #elseif php
            return cast php.Syntax.code("SplFixedArray.fromArray({0})", this);
        #else
            return cast haxe.ds.Vector.fromArrayCopy(this);
        #end
    }

    inline public function concat(arr : NativeArray<V>) : NativeArray<V> {
        #if js
            return cast this.concat(cast arr);
        /* TODO
        #elseif java
            var o1 : java.util.List<V> = new java.util.ArrayList<V>();
            for (o in this) {
                o1.add(o);
            }
            for (o in arr) {
                o1.add(o);
            }
            return cast o1;
        */
        #elseif python
            return cast python.Syntax.code("{0} + {1}", this, arr);
        #elseif cs
            var o1 : cs.system.collections.IList = new cs.system.collections.ArrayList();
            var i : Int = 0;
            while (i < this.Count) {
                o1.Add(this.get_Item(i));
                i++;
            }
            i = 0;
            var arr2 : cs.system.collections.ArrayList = cast arr;
            while (i < arr2.Count) {
                o1.Add(arr2.get_Item(i));
                i++;
            }
            return cast o1;
        #elseif php
            return cast php.Syntax.code("array_merge({0}, {1})", this, arr);
        #else
            return cast this.concat(cast arr);
        #end
    }

    inline public function preallocate(space : Int) : Void {
        #if js
            this.resize(space);
        /* TODO            
        #elseif java
            while (this.size() < space) {
                this.add(null);
            }
        */
        #elseif python
            while (length() < space) {
                push(null);
            }            
        #elseif cs
            while (this.Count < space) {
                this.Add(null);
            }            
        #elseif php
            while (length() < space) {
                push(null);
            }
        #else
            this.resize(space);
        #end
    }

    inline public function sort(compare : V->V->Int) : Void {
        #if js
            this.sort(compare);
        /* TODO            
        #elseif java
            java.util.Collections.sort(cast this);
        */
        #elseif python
            python.Syntax.code("{0}.sort()", this);
        #elseif cs
            this.Sort();
        #elseif php
            php.Syntax.code("sort({0})", this);
        #else
            this.sort(compare);
        #end
    }

    inline public function indexOf(v : V) : Int {
        #if js
            return this.indexOf(v);
        #elseif java
            return this.indexOf(v);
        #elseif python
            return cast python.Syntax.code("{0}.index({1})", this, v);
        #elseif cs
            return this.IndexOf(v);
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
}
