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

import com.field.navigator.NavigatorInterface;
import com.field.navigator.NavigatorInterface;
import com.field.navigator.NavigatorStandard;

import haxe.Exception;

@:expose
@:nativeGen
/**
    Defines most of the functionality for the standard Sprite.
**/
class SpriteAbstract<F, L, S> extends UsableAbstractWithData<F, L, S, S> implements SpriteInterface<F, S> implements SpriteSystemInterface<F> {
    private var _s : S;
    private var _i : Null<Int> = null;
    private var _attributesString : Null<String> = null;
    private var _navigator : Null<NavigatorInterface> = null;
    private var _unlockedNavigator : Null<NavigatorInterface> = null;

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
        switch (accessor.getSpriteType(sName)) {
            case 0, 1, 2:
                if (set) {
                    accessor.setSpriteAttribute(accessor.moveSprite(0, _i), sName, oValue);
                    r = oValue;
                } else {
                    r = accessor.getSpriteAttribute(accessor.moveSprite(0, _i), sName);
                }
            case 3:
                r = _field.getSpriteCalculatedAttributes().get(sName)(_s);
            default:
                r = super.attribute(sName, oValue);
        }
        
        return r;
    }

    public function attributes() : String {
        if (_attributesString == null) {
            var accessor : AccessorInterface = _field.getDefaultAccessor();
            var calculatedAttributes = _field.getSpriteCalculatedAttributes();
            var j : Int = accessor.moveSprite(0, _i);
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
                    var f : SpriteInterface<Dynamic,Dynamic>->Dynamic = cast value;
                    append(s, key, f(this));
                }
            }

            if (accessor.spriteAttributesLookupCount() > 0) {
                for (key in accessor.getSpriteLookupAttributes()) {
                    var value : Dynamic = accessor.getSpriteAttribute(j, key);
                    append(s, key, value);
                }                
            }

            _attributesString = s.toString();
        }

        return _attributesString;
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

    public function getI() : Int {
        return _i;
    }

    public function getX(for1 : FrameOfReference) : Int {
        var l : LocationInterface<F, L> = cast _field.findLocationForSpriteIndex(_i);
        var x = l.getX(for1);
        l.doneWith();
        return x;
    }

    public function getY(for1 : FrameOfReference) : Int {
        var l : LocationInterface<F, L> = cast _field.findLocationForSpriteIndex(_i);
        var x = l.getY(for1);
        l.doneWith();
        return x;
    }

    public function hide() : Void {
        set(-1, 0);
    }

    public function isHidden() : Bool {
        return getX(null) == -1;
    }

    public function move(x : Int, y : Int) : Bool {
        x = Math.floor(x);
        y = Math.floor(y);
        var l : LocationInterface<F, L> = cast _field.findLocationForSpriteIndex(_i);
        var cx = l.getX(null);
        var cy = l.getY(null);
        l.doneWith();
        var newX = cx + x;
        var newY = cy + y;
        l = cast _field.get(newX, newY);

        if (l != null && canEnter(l, null, null, null))
        {
            this.set(l.getX(null), l.getY(null));
            l.doneWith();
            return true;
        }
        else 
        {
            l.doneWith();
            return false;
        }
    }

    public function set(x : Null<Int>, y : Null<Int>) : Void {
        if (x == null && y == null) {
            x = -1;
            y = 0;
            if (attribute("overrideXY") == true) {
                attribute("overrideXY", false);
                attribute("overrideX", -1);
                attribute("overrideY", 0);                
            }
        }
        var accessor : AccessorInterface = _field.getDefaultAccessor();
        var current : Null<Int> = accessor.getSpriteInteger(accessor.moveSprite(0, _i), "location");
        var j : Int = x + y * accessor.getColumns();

        accessor.setSpriteInteger(accessor.moveSprite(0, _i), "location", j + 1);

        var spritesAtLocation = _field.getSpritesAtLocation();
        if (current != 0)
        {
            var currentLocation;
            if (current == null) {
                currentLocation = null;
            } else {
                current--;
                currentLocation = spritesAtLocation.get(current);
            }
            if (currentLocation == null) {
                // Intentionally Left Blank
            } /*else if (currentLocation.length <= 1) {
                // TODO
                // delete spritesAtLocation[current];
            } */ else {
                if (currentLocation.get(_i) != null) {
                    currentLocation.remove(_i);
                }
            }
        }
        {
            var newLocation : NativeIntMap<Int> = spritesAtLocation.get(j);
            if (newLocation == null) {
                newLocation = new NativeIntMap<Int>();
                spritesAtLocation.set(j, newLocation);
            }
            newLocation.set(_i, _i);
        }
    }

    public function changed() : Bool {
        return _attributesString == null;
    }

    public override function init(newField : F, newX : Int, newY : Int) : S {
        if (_s == null) {
            _s = cast this;
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

    private static inline function isAccessor(accessor : Any) : Bool {
        #if js
            return cast js.Syntax.code("!({0}.getDefaultAccessor)", accessor);
        #else
            return Std.is(accessor, AccessorInterface);
        #end
    }

    private static inline function isLocation(l : Any) : Bool {
        #if js
            return cast js.Syntax.code("!!({0}.attribute)", l);
        #else
            return Std.is(l, HasAttributes);
        #end
    }

    private static inline function isCoordinate(c : Any) : Bool {
        #if js
            return cast js.Syntax.code("{0}.x != null", c);
        #else
            return Std.is(c, Coordinate);
        #end
    }

    private static inline function getXFromCoord(c : Any) : Int {
        #if js
            return cast js.Syntax.code("{0}.x", c);
        #else
            var c2 : Coordinate = cast c;
            return c2.x;
        #end
    }

    private static inline function getYFromCoord(c : Any) : Int {
        #if js
            return cast js.Syntax.code("{0}.y", c);
        #else
            var c2 : Coordinate = cast c;
            return c2.y;
        #end
    }

    public static function getAttribute(accessor : Any, x : Any, y : Any, name : String) : Any {
        if (accessor != null) {
            if (x != null) {
                var actualAccessor : AccessorInterface;

                if (isAccessor(accessor)) {
                    actualAccessor = cast accessor;
                } else {
                    var hasAccessor : HasAccessor = cast accessor;
                    actualAccessor = hasAccessor.getDefaultAccessor();
                }
                if (y != null) {
                    var i : Int = actualAccessor.moveColumn(actualAccessor.moveRow(0, cast y), cast x);
                    return actualAccessor.getLocationAttribute(i, name);
                } else if (isCoordinate(x)) {
                    var i : Int = actualAccessor.moveColumn(actualAccessor.moveRow(0, getYFromCoord(x)), getXFromCoord(x));
                    return actualAccessor.getLocationAttribute(i, name);
                } else {
                    #if js
                        js.Syntax.code("throw \"Invalid input\"");
                        return null;
                    #else
                        throw new Exception("Invalid input");
                    #end
                }
            } else if (isLocation(accessor)) {
                var actualLocation : HasAttributes = cast accessor;
                return actualLocation.attribute(name);
            } else {
                #if js
                    js.Syntax.code("throw \"Invalid input\"");
                    return null;
                #else
                    throw new Exception("Invalid input");
                #end
            }
        } else if (x != null && isLocation(x)) {
            var actualLocation : HasAttributes = cast x;
            return actualLocation.attribute(name);
        } else {
            #if js
                js.Syntax.code("throw \"Invalid input\"");
                return null;
            #else
                throw new Exception("Invalid input");
            #end
        }
    }

    public function canEnter(accessor : Any, ?x : Any = null, ?y : Any = null, ?name : Any = null) : Bool {
        return false;
    }

    public function copyAttributesFrom(o : Any) : Void {
        _attributesString = null;
        var accessor : AccessorInterface = _field.getDefaultAccessor();

        var m : NativeStringMap<Any> = cast o;
        for (k in m.keys()) {
            switch (accessor.getSpriteType(k)) {
                case 0, 1, 2:
                    switch (k) {
                        case "location":
                            {
                                var v : NativeArray<Dynamic> = m.get(k);
                                set(cast v.get(0), cast v.get(1));
                            }
                        default:
                            attribute(k, m.get(k));
                    }
            }
        }
    }

    public function navigator() : NavigatorInterface {
        if (_navigator == null) {
            var s : FieldSystemInterface<L, S> = cast field();
            _navigator = new NavigatorStandard(this, s.navigator());
        }
        return _navigator;
    }

    public function unlockedNavigator() : NavigatorInterface {
        if (_unlockedNavigator == null) {
            var s : FieldSystemInterface<L, S> = cast field();
            _unlockedNavigator = new NavigatorStandard(this, s.unlockedNavigator());
        }
        return _unlockedNavigator;
    }

    public function hasValue() : Bool {
        #if js
            return cast js.Syntax.code("!!({0}.value)", this);
        #else
            return Std.is(this, SpriteExtendedInterface);
        #end
    }

    public function isDynamic() : Bool {
        return false;
    }
    
    public function hasActualValue() : Bool {
        #if js
            return cast js.Syntax.code("!!({0}.actualValue)", this);
        #else
            return Std.is(this, SpriteExtendedInterface);
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
            if (Std.is(this, SpriteExtendedInterface)) {
                var le : SpriteExtendedInterface = cast this;
                return le.dataSource() != null;
            } else {
                return false;
            }
        #end
    } 
    
    public function getField() : F {
        return cast _field;
    }
}
/*
TODO

            type: function ()
            {
            },
    },
    */