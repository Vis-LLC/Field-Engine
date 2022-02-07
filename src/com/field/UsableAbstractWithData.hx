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
    A base interface that is used to indicate that the object is managed by an Allocator.
**/
class UsableAbstractWithData<F, L, S, T> extends UsableAbstract<F, L, S, T> {
    private var _attributes : Null<NativeStringMap<Any>> = null;
    private var _data : Null<NativeStringMap<Any>> = null;
    private static var _emptyKeys : NativeVector<String> = new NativeVector<String>(0);

    public function attribute(sName : String, ?oValue : Any = null) : Any {
        var set : Bool = (oValue != null);
        var r : Any = null;

        if (_attributes == null) {
            _attributes = new NativeStringMap<Any>();
        }
        if (set) {
            _attributes.set(sName, oValue);
            r = oValue;
        } else {
            r = _attributes.get(sName);
        }
        
        return r;
    }
    
    public function data(sName : String, ?oValue : Any = null) : Any {
        var set : Bool = (oValue != null);

        if (_data == null) {
            _data = new NativeStringMap<Any>();
        }

        var r : Any = null;
        if (set) {
            _data.set(sName, oValue);
            return oValue;
        } else {
            return _data.get(sName);
        }
    }

    public function myCustomAttributeKeys() : Iterator<String> {
        if (_attributes == null) {
            return _emptyKeys.iterator();
        } else {
            return _attributes.keys();
        }
    }

    public function myCustomDataKeys() : Iterator<String> {
        if (_data == null) {
            return _emptyKeys.iterator();
        } else {
            return _data.keys();
        }
    }

    public function clearFieldData() : Void {
        _attributes = null;
        _data = null;
    }
}