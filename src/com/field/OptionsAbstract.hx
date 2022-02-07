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

import haxe.Exception;

@:nativeGen
/**
    The base type for setting options/parameters for different parts of the library.
**/
class OptionsAbstract<T> {
    /**
        All the values that are wrapped by OptionsAbstract.
    **/
    private var _values : NativeStringMap<Any> = new NativeStringMap<Any>();

    /**
        Whether these options are locked or not.
    **/
    private var _locked : Bool = false;

    private inline function new() { }

    /**
        Copy all the values from another Options instance.
    **/
    public function copyFrom(options : T) : T {
        var o : OptionsAbstract<T> = cast options;
        #if (hax_ver >= 4)
        for (key => value in o._values) {
        #else
        for (key in o._values.keys()) {
            var value : Dynamic = o._values.get(key);
        #end
            set(key, value);
        }

        return cast this;
    }

    /**
        Gets a value.
    **/
    private function get(key : String) : Any {
        return _values.get(key);
    }

    /**
        Set a value, generally the functions provided by the subclass are used instead of this.
    **/
    private function set(key : String, value : Any) : T {
        if (this._locked) {
            #if js
                js.Syntax.code("throw \"Options are locked.\"");
            #else
                throw new Exception("Options are locked.");
            #end
        }
        _values.set(key, value);
        return cast this;
    }

    /**
        Set a value exactly once.
    **/
    private function setOnce(key : String, value : Any) : T {
        if (_values.get(key) == null) {
            return set(key, value);
        } else {
            throw new Exception("Can only set once.");
        }
    }

    /**
        Lock the options instance so it can't be changed.
    **/
    public function lock() : T {
        _locked = true;
        return cast this;
    }

    /**
        Convert to a map, this is generally used internally when retrieving values.
    **/
    public function toMap() : NativeStringMap<Any> {
        var values : NativeStringMap<Any> = new NativeStringMap<Any>();

        #if (hax_ver >= 4)
        for (key => value in _values) {
        #else
        for (key in _values.keys()) {
            var value : Dynamic = _values.get(key);
        #end
            values.set(key, value);
        }

        return values;
    }
}