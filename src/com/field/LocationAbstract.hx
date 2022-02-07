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
    Defines most of the functionality for the standard Location.
**/
class LocationAbstract<F, L, S> extends UsableAbstractWithData<F, L, S, L> implements Usable<F, L> {
    private var _i : Null<Int> = null;
    private var _l : L;
    private var _attributesString : Null<String> = null;

    private static function append(s : StringBuf, n : String, o : Any) : Void {
        s.add(" ");
        s.add(n);
        if (o != null) {
            s.add("-");
            s.add(o);
        }
    }
  
    public override function attribute(sName : String, ?oValue : Any = null) : Any {
        var accessor : AccessorInterface = _field.getDefaultAccessor();
        var set : Bool = (oValue != null);
        if (set) {
            _attributesString = null;
        }
        var r : Any = null;
        switch (accessor.getLocationType(sName)) {
            case 0, 1, 2:
                if (set) {
                    r = oValue;
                    accessor.setLocationAttribute(_i, sName, oValue);
                } else {
                    r = accessor.getLocationAttribute(_i, sName);
                }
            case 3:
                r = _field.getLocationCalculatedAttributes().get(sName)(_l);
            default:
                r = super.attribute(sName, oValue);
        }
        
        return r;
    }

    public function attributes() : String {
        if (_attributesString == null) {
            var accessor : AccessorInterface = _field.getDefaultAccessor();
            var calculatedAttributes = _field.getLocationCalculatedAttributes();

            var s : StringBuf = new StringBuf();

            if (_attributes != null) {
                #if (hax_ver >= 4)
                for (key => value in _attributes) {
                #else
                for (key in _attributes.keys()) {
                    var value : Dynamic = _attributes.get(key);
                #end
                    append(s, key, value);
                }
            }

            if (calculatedAttributes != null) {
                #if (hax_ver >= 4)
                    for (key => value in calculatedAttributes) {
                #else
                for (key in calculatedAttributes.keys()) {
                    var value : Dynamic = calculatedAttributes.get(key);
                #end
                    var f : LocationInterface<Dynamic,Dynamic>->Dynamic = cast value;
                    append(s, key, f(cast this));
                }
            }

            if (accessor.locationAttributesLookupCount() > 0) {
                for (key in accessor.getLocationLookupAttributes()) {
                    var value : Dynamic = accessor.getLocationAttribute(_i, key);
                    append(s, key, value);
                }
            }

            _attributesString = s.toString();
        }

        return _attributesString;
    }

    public function changed() : Bool {
        return _attributesString == null;
    }    

    // TODO
    //function State(lsNew : Null<LocationState>) : LocationState;

    public override function clearFieldData() : Void {
        // TODO - Clear out Accessor data too
        super.clearFieldData();
        _attributesString = null;
    }

    public function id() : String {
        return "1";
    }

    public function toString() : String {
        // TODO
        return "";
    }
    
    public function neighbor(i : Int, j : Int, ?f : Null<L->Any>) : L {
        var l : L = _field.get(getX(null) + i, getY(null) + j);
        if (f == null) {
            return l;
        } else {
            var o : Any = f(l);
            var l2 : LocationInterface<F, L> = cast l;
            l2.doneWith();
            return o;
        }
    }

    public function getI() : Int {
        return _i;
    }

    private function getXI() : Int {
        var accessor : AccessorInterface = _field.getDefaultAccessor();
        if (accessor.getLocationAttributeCount() <= 0) {
            return _i % accessor.getColumns();
        } else {
            return accessor.getX(_i);
        }
    }

    public function getYI() : Int {
        var accessor : AccessorInterface = _field.getDefaultAccessor();
        if (accessor.getLocationAttributeCount() <= 0) {
            return Math.floor(_i / accessor.getColumns());
        } else {
            return accessor.getY(_i);
        }
    }

    public function getX(for1 : FrameOfReference) : Int {
        if (for1 == null) {
            for1 = _field;
        }
        return Math.floor(for1.transformX(getXI(), getYI()));
    }

    public function getY(for1 : FrameOfReference) : Int {
        if (for1 == null) {
            for1 = _field;
        }        
        return Math.floor(for1.transformY(getXI(), getYI()));
    }

    public override function init(newField : F, newX : Int, newY : Int) : L {
        if (_l == null) {
            _l = cast this;
        }
        this.clearFieldData();
        super.init(newField, newX, newY);
        var accessor = _field.getDefaultAccessor();
        if (accessor.getLocationAttributeCount() <= 0) {
            _i = accessor.getColumns() * newY + newX;
        } else {
            _i = accessor.moveColumn(accessor.moveRow(0, newY), newX);
        }
        return cast this;
    }

    public function hasValue() : Bool {
        #if js
            return cast js.Syntax.code("!!({0}.value)", this);
        #else
            return Std.is(this, LocationExtendedInterface);
        #end
    }

    public function isDynamic() : Bool {
        return false;
    }
    
    public function hasActualValue() : Bool {
        #if js
            return cast js.Syntax.code("!!({0}.actualValue)", this);
        #else
            return Std.is(this, LocationExtendedInterface);
        #end
    }
    
    public function hasDataSource() : Bool {
        #if js
            if (cast js.Syntax.code("!!({0}.dataSource)", this)) {
                return cast js.Syntax.code("!!({0}.dataSource())", this);
            } else {
                return false;
            }
        #else
            if (Std.is(this, LocationExtendedInterface)) {
                var le : LocationExtendedInterface = cast this;
                return le.dataSource() != null;
            } else {
                return false;
            }
        #end
    }
}