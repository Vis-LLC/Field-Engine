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

package com.field.navigator;

import com.field.Coordinate;
import com.field.NativeArray;

@:expose
@:nativeGen
/**
    An abstract implementation of the NavigatorCoreInterface.
**/
class NavigatorCoreAbstract implements NavigatorCoreInterface {
    private var _start : Float;
    private var _directionsForAccessor : Null<NativeVector<Coordinate>> = null;

    private function new(start : Float) {
        _start = start;
    }

    public function directionCount() : Int {
        return directions().length();
    }

    public function directions() : NativeVector<DirectionInterface> {
        return null;
    }

    public function diagonal() : NavigatorCoreInterface {
        return null;
    }

    public function allDirections() : NavigatorCoreInterface {
        return null;
    }

    public function standard() : NavigatorCoreInterface {
        return null;
    }

    public function directionsForAccessor() : NativeVector<Coordinate> {
        if (_directionsForAccessor == null) {
            var directions : NativeVector<DirectionInterface> = this.directions();
            var directionsForAccessor : NativeArray<Coordinate> = new NativeArray<Coordinate>();
            for (direction in directions) {
                var xy : NativeVector<Float> = direction.xy();
                directionsForAccessor.push(
                    new Coordinate(
                        Math.round((xy.get(0) + direction.shiftX()) * direction.distanceMultiplierX()),
                        Math.round((xy.get(1) + direction.shiftY()) * direction.distanceMultiplierY())
                    )
                );
            }
            _directionsForAccessor = directionsForAccessor.toVector();
        }
        return _directionsForAccessor;
    }

    private function roundX(oddRow : Bool, x : Float) {
        if (oddRow) {
            if (x < 0) {
                return Math.floor(x);
            } else {
                return Math.ceil(x);
            }
        } else {
            if (x < 0) {
                return Math.ceil(x);
            } else {
                return Math.floor(x);
            }
        }
    }

    public function navigate(sprite : SpriteSystemInterface, direction : DirectionInterface, distance : Int) : Bool {
        var xy : NativeVector<Float> = direction.xy();
        var s : SpriteInterface<Dynamic, Dynamic> = cast sprite;
        var oddRow = Math.abs(Math.floor(s.getY(null)) % 2) == 1;
        var x : Int = roundX(oddRow, (xy.get(0) + direction.shiftX()) * direction.distanceMultiplierX());
        return sprite.move(x, Math.round((xy.get(1) + direction.shiftY()) * direction.distanceMultiplierY()));
    }

    private function getCounterClockwise(direction : Float) : DirectionInterface {
        return directions().get(Math.ceil((direction - _start) / 360 * directions().length()));
    }

    private function getClockwise(direction : Float) : DirectionInterface {
        return directions().get(Math.floor((direction - _start) / 360 * directions().length()));
    }    

    public function directionForDegrees(direction : Float) : DirectionInterface {
        direction = (360.0 + (direction % 360.0)) % 360.0;
        var counterClockwise : DirectionInterface = getCounterClockwise(direction);
        if (counterClockwise.degrees() == direction) {
            return counterClockwise;
        } else {
            var clockwise : DirectionInterface = getClockwise(direction);
            if (Math.abs(counterClockwise.degrees() - direction) >= Math.abs(clockwise.degrees() - direction)) {
                return counterClockwise;
            } else {
                return clockwise;
            }
        }
    }

    public function navigateInDegrees(sprite : SpriteSystemInterface, direction : Float, distance : Int) : Bool {
        return navigate(sprite, directionForDegrees(direction), distance);
    }

    public function navigateInRadians(sprite : SpriteSystemInterface, direction : Float, distance : Int) : Bool {
        return navigateInDegrees(sprite, direction / Math.PI * 180.0, distance);
    }

    public function navigateInXY(sprite : SpriteSystemInterface, x : Int, y : Int) : Bool {
        return navigateInRadians(sprite, Math.atan2(y, x), Math.round(Math.sqrt(x * x + y * y)));
    }

    public function navigateInClock(sprite : SpriteSystemInterface, direction : Float, distance : Int) : Bool {
        return navigateInDegrees(sprite, direction / -12.0 * 360.0 + 90.0, distance);
    }
}