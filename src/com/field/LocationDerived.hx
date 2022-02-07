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
    This defines a Location that wraps/decorates other Locations.
**/
class LocationDerived extends UsableAbstractWithData<Dynamic, Dynamic, Dynamic, LocationDerived> implements LocationInterface<Dynamic, LocationDerived> implements LocationExtendedInterface {
    private var _location : LocationInterface<Dynamic, Dynamic>;
    private var _attribute : Int;
    private var _name : String;
    private var _changed : Bool = false;

    public function new() { }

    public function attributes() : String {
        return _location.attributes();
    }

    public override function clearFieldData() : Void {
        _location.clearFieldData();
        super.clearFieldData();
    }

    public function id() : String {
        return _location.id();
    }

    public function toString() : String {
        return value();
    }

    public function neighbor(i : Int, j : Int, ?f : Null<LocationDerived->Any>) : LocationDerived {
        var l : LocationDerived = _field.get(getX(null) + i, getY(null) + j);
        if (f == null) {
            return l;
        } else {
            var o : Any = f(l);
            var l2 : LocationInterface<Dynamic, LocationDerived> = cast l;
            l2.doneWith();
            return o;
        }
    }
    
    public function getI() : Int {
        return _location.getI();
    }

    public function getX(for1 : FrameOfReference) : Int {
        if (for1 == null) {
            for1 = _field;
        }
        return Math.floor(for1.transformX(_location.getX(null) + _attribute, getY(null)));
    }

    public function getY(for1 : FrameOfReference) : Int {
        return _location.getY(for1);
    }

    public function changed() : Bool {
        return _changed;
    }

    public override function attribute(sName : String, ?oValue : Any = null) : Any {
        return _location.attribute(sName, oValue);
    }

    public override function data(sName : String, ?oValue : Any = null) : Any {
        return _location.data(sName, oValue);
    }

    public override function myCustomAttributeKeys() : Iterator<String> {
        return _location.myCustomAttributeKeys();
    }
    public override function myCustomDataKeys() : Iterator<String> {
        return _location.myCustomDataKeys();
    }

    public function hasValue() : Bool {
        return true;
    }

    public function hasName() : Bool {
        return _name != null;
    }    
    
    public function hasActualValue() : Bool {
        return true;
    }
    
    public function hasDataSource() : Bool {
        return false;
    }

    public function deriveAsText(attribute : Int) : LocationExtendedInterface {
        return null;
    }

    // TODO Next - Reset Change where?
    public function value(?oNew : Any = null) : Any {
        if (oNew != null) {
            _location.attribute(_name, oNew);
            _changed = true;
            return oNew;
        } else {
            return _location.attribute(_name);
        }
    }

    public function name(?oNew : Any = null) : Any {
        return _name;
    }

    public function actualValue(?oNew : Any = null) : Any {
        return value(oNew);
    }

    public function dataSource(?oNew : Any) : Any {
        return null;
    }
    
    private static var _allocator : LocationDerivedAllocator = new LocationDerivedAllocator();

    public static function getAllocator() : com.field.manager.AllocatorLocation<LocationDerived> {
        return _allocator;
    }

    public function location(?l : Null<LocationInterface<Dynamic, Dynamic>>) : Null<LocationInterface<Dynamic, Dynamic>> {
        if (l == null) {
            return _location;
        } else {
            _location = l;
            return l;
        }
    }

    public function attributeNumber(?attribute : Null<Int>) : Int {
        if (attribute == null) {
            return _attribute;
        } else {
            _attribute = attribute;
            return attribute;
        }
    }

    public function attributeName(?attribute : Null<String>) : String {
        if (attribute == null) {
            return _name;
        } else {
            _name = attribute;
            return attribute;
        }        
    }

    public override function doneWith() : Void {
        if (_inUse <= 1) {
            _location.doneWith();
        }
        super.doneWith();
    }    

    public function isDynamic() : Bool {
        return false;
    }
}

@:nativeGen
/**
    Used to create LocationDeriveds.
    This function is not meant to be used externally, only internally to the FieldEngine library.   
**/
class LocationDerivedAllocator extends com.field.manager.AllocatorLocation<LocationDerived> {
    public function new() { }

    public override function allocate() : LocationDerived {
        return new LocationDerived();
    }
}