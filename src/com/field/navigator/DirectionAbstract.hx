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

@:expose
@:nativeGen
/**
    An abstract implementation of the DirectionInterface.
**/
class DirectionAbstract implements DirectionInterface {
    private var _name : String;
    private var _clockwise : DirectionInterface;
    private var _counterClockwise : DirectionInterface;
    private var _degrees : Float;
    private var _radians : Float;
    private var _xy : NativeVector<Float>;
    private var _clock : Float;
    private var _distanceMultiplierX : Float;
    private var _distanceMultiplierY : Float;
    private var _shiftX : Float;
    private var _shiftY : Float;
    private var _movable : Bool;
    private var _opposite : Null<DirectionInterface>;
    private var _oppositeAny : DirectionInterface;

    private function new() { }

    public function name() : String {
        return _name;
    }

    public function clockwise() : DirectionInterface {
        return _clockwise;
    }

    public function counterClockwise() : DirectionInterface {
        return _counterClockwise;
    }

    public function degrees() : Float {
        return _degrees;
    }

    public function clock() : Float {
        return _clock;
    }

    public function radians() : Float {
        return _radians;
    }

    public function xy() : NativeVector<Float> {
        return _xy;
    }

    public function distanceMultiplierX() : Float {
        return _distanceMultiplierX;
    }

    public function distanceMultiplierY() : Float {
        return _distanceMultiplierY;
    }

    public function shiftX() : Float {
        return _shiftX;
    }    

    public function shiftY() : Float {
        return _shiftY;
    }

    public function opposite() : Null<DirectionInterface> {
        return _opposite;
    }

    public function oppositeAny() : DirectionInterface {
        return _oppositeAny;
    }

    public function movable() : Bool {
        return _movable;
    }

    // TODO - Make package only
    public function init(name : String, clockwise : DirectionInterface, counterClockwise : DirectionInterface, opposite : Null<DirectionInterface>, oppositeAny : DirectionInterface, start : Float, idx : Int, directions : Int, distanceMultiplierX : Float, distanceMultiplierY : Float, shiftX : Float, shiftY : Float) : Void {
        _name = name;
        _clockwise = clockwise;
        _counterClockwise = counterClockwise;
        _opposite = opposite;
        _oppositeAny = oppositeAny;

        _degrees = ((360.0 / directions) * idx + start) % 360.0;
        _radians = _degrees / 180.0 * Math.PI;
        _clock = (15 + _degrees / 360.0 * -12.0) % 12;
        _xy = new NativeVector<Float>(2);
        _xy.set(0, Math.cos(_radians));
        _xy.set(1, Math.sin(_radians));
        _distanceMultiplierX = distanceMultiplierX;
        _distanceMultiplierY = distanceMultiplierY;
        _shiftX = shiftX;
        _shiftY = shiftY;
    }
}
