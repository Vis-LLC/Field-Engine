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

import com.field.manager.Pool;

@:nativeGen
@:expose
/**
    A Decorator that changes a Field so that columns are split based on the Attributes they have.
**/
class FieldWrapperAttributesToColumns<L, S> extends FieldWrapper<L, S> {
    private var _columns : Int = 0;
    private var _attributeToColumn : NativeStringMap<Int> = new NativeStringMap<Int>();
    private var _columnToAttribute : NativeIntMap<String> = new NativeIntMap<String>();

    private var _locationManager : com.field.manager.Manager<LocationDerived, LocationDerived, Dynamic>;
    private var _locationAllocator : com.field.manager.Allocator<LocationDerived>;
    private var _discardedLocations : Pool<LocationDerived>;
    private var _locations : Pool<LocationDerived>;    

    private static function getField(options : FieldWrapperAttributesToColumnsOptions<Dynamic, Dynamic>) : FieldInterface<Dynamic, Dynamic> {
        var fo : NativeStringMap<Any> = options.toMap();
        return cast fo.get("field");
    }

    /**
        Creates a FieldWrapperAttributesToColumns based on the options.
    **/
    public static function create(options : FieldWrapperAttributesToColumnsOptions<Dynamic, Dynamic>) : FieldWrapperAttributesToColumns<Dynamic, Dynamic>  {
        return new FieldWrapperAttributesToColumns<Dynamic, Dynamic>(options);
    }

    /**
        Allows for the setting of options for the FieldWrapperRowFilter class.
    **/
    public static function options() : FieldWrapperAttributesToColumnsOptions<Dynamic, Dynamic> {
        return new FieldWrapperAttributesToColumnsOptions<Dynamic, Dynamic>();
    }

    public override function doneWith(o : Usable<L, S>) : Void {
        _locationManager.doneWith(cast o, _locations, _discardedLocations);
    }

    private function new(options : FieldWrapperAttributesToColumnsOptions<L, S>) {
        super(cast getField(options));
        var fo : NativeStringMap<Any> = options.toMap();
        options = null;
        var i : Int = 0;
        var next : Null<String> = fo.get("column" + i);
        var all : Bool = cast fo.get("doAll");

        while (next != null) {
            _attributeToColumn.set(next, _columns);
            _columnToAttribute.set(_columns, next);
            _columns++;
            i++;
            next = fo.get("column" + i);
        }

        if (all) {
           var accessor : AccessorInterface = _field.getDefaultAccessor();
           var attributes : Iterator<String> = accessor.getLocationLookupAttributes();
           while (attributes.hasNext()) {
               var attribute : String = attributes.next();
               if (_attributeToColumn.get(attribute) == null) {
                   _attributeToColumn.set(attribute, _columns);
                   _columnToAttribute.set(_columns, attribute);
                   _columns++;
               }
           }
        }

        // TODO - _locationManager option
        if (_locationManager == null) {
            _locationManager = new com.field.manager.TransientReuse<LocationDerived, FieldWrapperAttributesToColumns<L,S>, LocationDerived, Dynamic>();
        }
        _locationAllocator = LocationDerived.getAllocator();
        _locations = _locationManager.preallocate(_locationAllocator, cast this, _field.width() * _field.height(), _columns);
        _discardedLocations = _locationManager.allocateDiscard(_locationAllocator);
    }

    public override function width() : Int {
        return _field.width() * _columns;
    }

    public override function get(x : Int, y : Int) : L {
        var attribute : Int = x % _columns;
        x = Math.floor(x / _columns);
        var derived : LocationDerived = _locationManager.startWith(_locationAllocator, cast this, _locations, _discardedLocations, y * _field.width() + x, attribute);
        var location : LocationInterface<L, S> = cast derived.location();
        if (location == null) {
            derived.location(cast _field.get(Math.floor(x / _columns), y));
            derived.attributeNumber(attribute);
            derived.attributeName(_columnToAttribute.get(attribute));
        } else {
            location.doneWith();
        }

        return cast derived;        
    }

    public override function transformX(x : Float, y : Float) : Float {
        return super.transformX(x, y) * _columns;
    }
}



