/*
    Copyright (C) 2020-2023 Vis LLC - All Rights Reserved

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

package com.field.navigator;

import com.field.SpriteSystemInterface;
import com.field.navigator.NavigatorCoreInterface;

@:expose
@:nativeGen
class NavigatorUnlocked extends NavigatorCoreAbstract {
    private static var _instance : NavigatorCoreInterface = new NavigatorUnlocked();

    private function new() {
        super(0);
    }

    public static function instance() : NavigatorCoreInterface {
        return _instance;
    }

    public override function directionCount() : Int {
        return 0;
    }

    public override function directions() : NativeVector<DirectionInterface> {
        return null;
    }

    public override function diagonal() : NavigatorCoreInterface {
        return null;
    }

    public override function allDirections() : NavigatorCoreInterface {
        return this;
    }

    public override function standard() : NavigatorCoreInterface {
        return this;
    }

    private function navigateI(sprite : SpriteSystemInterface<Dynamic>, direction : DirectionInterface, distance : Int) : Array<Int> {
        // TODO - Add additional grid types
        var scaleX : Float = 1;
        var scaleY : Float = 1;
        var shiftX : Float = 0;
        var shiftY : Float = 0;
        var oddRowShift : Float = 0;
        var oddColumnShift : Float = 0;
        {
            var defaultNavigator : NavigatorCoreInterface = sprite.field().navigator();
            var firstDirection : DirectionInterface = defaultNavigator.directions().get(0);
            shiftX = firstDirection.shiftX();
            shiftY = firstDirection.shiftY();
            scaleX = defaultNavigator.scaleX();
            scaleY = defaultNavigator.scaleY();
            oddRowShift = defaultNavigator.oddRowShift();
            oddColumnShift = defaultNavigator.oddColumnShift();
            firstDirection = null;
            defaultNavigator = null;
        }
        {
            var scaleXY : Float = sprite.field().scaleXY();
            if (scaleXY > 1) {
                scaleX *= 1 / scaleXY;
            } else {
                scaleY *= scaleXY;
            }
        }
        /*
        {
            if (shiftX != 0) {
                scaleY = scaleY * Math.abs(shiftX);
            }
            if (shiftY != 0) {
                scaleX = scaleX * Math.abs(shiftY);
            }
        }
        */
        var s : SpriteInterface<Dynamic, Dynamic> = null;
        if (Std.isOfType(sprite, SpriteInterface)) {
            s = cast sprite;
        }
        var xy : NativeVector<Float> = direction.xy();
        var overrideXY : Null<Bool> = null;
        var ox : Float;
        var oy : Float;
        if (s != null) {
            overrideXY = s.attribute("overrideXY");
            if (overrideXY == null || overrideXY == false) {
                ox = s.getX(null);
                oy = s.getY(null);
                s.attribute("overrideXY", true);
                s.attribute("overrideX", s.getX(null));
                s.attribute("overrideY", s.getY(null));
            } else {
                ox = cast s.attribute("overrideX");
                oy = cast s.attribute("overrideY");
            }
        } else {
            ox = 0;
            oy = 0;
        }
        var x : Float = ox + xy.get(0) * distance / scaleX;
        var y : Float = oy + xy.get(1) * distance / scaleY;
		/*
		if ((Math.round(y) % 2) == 1) {
			x -= oddColumnShift;
		}
		*/        
        var rX : Int = Math.round((x - ox));
        var rY : Int = Math.round((y - oy));
        if (sprite.move(rX, rY)) {
            if (s != null) {
                s.attribute("overrideX", x);
                s.attribute("overrideY", y);
            }
            return [rX, rY];
        } else {
            return null;
        }
    }

    public override function navigate(sprite : SpriteSystemInterface<Dynamic>, direction : DirectionInterface, distance : Int) : Bool {
        return navigateI(sprite, direction, distance) != null;
    }

    public override function directionForDegrees(direction : Float) : DirectionInterface {
        return new NavigatorUnlockedDirection(direction);
    }
}

@:nativeGen
class NavigatorUnlockedDirection implements DirectionInterface {
    public var _direction : Float;

    public function new(direction : Float) {
        _direction = direction;
    }

    public function name() : String {
        return "" + _direction;
    }

    public function clockwise() : DirectionInterface {
        return null;
    }

    public function counterClockwise() : DirectionInterface {
        return null;
    }

    public function opposite() : Null<DirectionInterface> {
        return new NavigatorUnlockedDirection((_direction + 180) % 360);
    }

    public function oppositeAny() : DirectionInterface {
        return opposite();
    }

    public function movable() : Bool {
        return true;
    }

    public function degrees() : Float {
       return _direction; 
    }

    public function radians() : Float {
        return _direction * Math.PI / 180;
    }

    public function clock() : Float {
        return (15 + _direction / 360.0 * -12.0) % 12;
    }

    public function xy() : NativeVector<Float> {
        var v = new NativeVector<Float>(2);
        var r = radians();
        v.set(0, Math.cos(r));
        v.set(1, Math.sin(r));
        return v;
    }

    public function distanceMultiplierX() : Float {
        return 1.0;
    }

    public function distanceMultiplierY() : Float {
        return 1.0;
    }

    public function shiftX() : Float {
        return 0;
    }

    public function shiftY() : Float {
        return 0;
    }
}