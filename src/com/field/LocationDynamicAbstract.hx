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

@:expose
@:nativeGen
/**
    Defines most of the functionality for the dynamic Location.
**/
class LocationDynamicAbstract<F, L, S> extends LocationAbstract<F, L, S> implements LocationExtendedInterface {
    private var _hasValue : Bool = false;
    private var _value : Any;
    private var _name : Any;

    public override function attribute(sName : String, ?oValue : Any = null) : Any {
        var set : Bool = (oValue != null);
        if (set) {
            _attributesString = null;
        }
        var r : Any = null;
        if (set) {
            r = oValue;
            var field : FieldDynamicInterface<L, S> = cast _field;
            var iValue : Int = field.locationAttribute(sName, oValue);
            if (_attributes == null) {
                _attributes = new NativeStringMap<Any>();
            }
            _attributes.set(sName, oValue);
            return oValue;
        } else {
            var field : FieldDynamicInterface<L, S> = cast _field;
            var info : AttributeInfoDynamic = field.getLocationAttribute(sName);
            return _attributes.get(info.name);
        }     
    }

    public function attributeDirect(attribute : Int, ?oValue : Any = null) : Any {
        var set : Bool = (oValue != null);
        if (set) {
            _attributesString = null;
        }
        var r : Any = null;
        if (set) {
            r = oValue;
            var field : FieldDynamicInterface<L, S> = cast _field;
            field.locationAttributeDirect(attribute, oValue);
            if (_attributes == null) {
                _attributes = new NativeStringMap<Any>();
            }
            _attributes.set(field.getLocationAttributeDirect(attribute).name, oValue);
        } else {
            var field : FieldDynamicInterface<L, S> = cast _field;
            var info : AttributeInfoDynamic = field.getLocationAttributeDirect(attribute);
            switch (info.name) {
                case "name":
                    return name();
                case "value":
                    return value();
                default:
                    return _attributes.get(info.name);
            }
        }     
        return r;
    }

    public override function isDynamic() : Bool {
        return true;
    }    

    public override function hasValue() : Bool {
        return _hasValue;
    }   

    public function hasName() : Bool {
        return _name != null;
    }       

    public function value(?oNew : Any = null) : Any {
        if (oNew == null) {
            return _value;
        } else {
            _hasValue = true;
            _value = oNew;
            return oNew;
        }
    }

    public function name(?oNew : Any = null) : Any {
        if (oNew == null) {
            return _name;
        } else {
            _name = oNew;
            return oNew;
        }
    }    

    public function actualValue(?oNew : Any = null) : Any {
        return value(oNew);
    }

    public function dataSource(?oNew : Any) : Any {
        return null;
    }    
}