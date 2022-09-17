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
    An Adapter class that allows all native maps with object keys to be used easily.
**/
abstract NativeObjectMap<V>(
#if js
    js.lib.Object
#elseif java
    java.util.Map<Object, V>
#elseif cs
    cs.system.collections.IDictionary
#elseif php
    php.NativeArray
#else
    haxe.Constraints.IMap<Object,V>
#end
) {
    inline public function new() {
        this = #if js
            new js.lib.Object()
        #elseif java
            new java.util.Hashtable<Object, V>()
        #elseif cs
            new cs.system.collections.Hashtable()
        #elseif php
            new php.NativeArray()
        #else
            cast new haxe.ds.ObjectMap<V>()
        #end
        ;
    }

    inline public function set(k : Any, v : Null<V>) : Void {
        #if js
            js.Syntax.code("{0}[{1}] = {2}", this, k, v);
        #elseif java
            this.put(k, v);
        #elseif cs
            this.set_Item(k, v);
        #elseif php
            this[k] = v;
        #else
            this.set(k, v);
        #end
    }

    inline public function get(k : Any) : Null<V> {
        #if js
            return cast js.Syntax.code("{0}[{1}]", this, k);
        #elseif java
            return this.get(k);
        #elseif cs
            return cast this.get_Item(k);
        #elseif php
            return this[k];
        #else
            return this.get(k);
        #end
    }

    inline public function keys() : Iterator<Any> {
        #if js
            return cast js.lib.Object.keys(this).iterator();
        #elseif java
            return this.keySet().iterator();
        #elseif cs
            return cast this.get_Keys().GetEnumerator();
        #elseif php
            var na : php.NativeArray = cast php.Syntax.code("array_keys({0})", this);
            return na.iterator();
        #else
            return cast this.keys();
        #end
    }

    inline public function remove(k : Any) : Void {
        #if js
            js.Syntax.code("delete {0}[{1}]", this, k);
        #elseif java
            this.remove(k);
        #elseif cs
            this.Remove(k);
        #elseif php
            php.Syntax.code("unset({0}[{1}])", this, k);
        #else
            this.remove(k);
        #end
    }
}