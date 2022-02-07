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
class NavigatorStandard implements NavigatorInterface {
    private var _sprite : SpriteSystemInterface;
    private var _navigator : NavigatorCoreInterface;

    public function new(sprite : SpriteSystemInterface, navigator : NavigatorCoreInterface) {
        _sprite = sprite;
        _navigator = navigator;
    }

    public function diagonal() : NavigatorInterface {
        var next : NavigatorCoreInterface = _navigator.diagonal();
        if (next == _navigator) {
            return this;
        } else {
            return new NavigatorStandard(_sprite, next);
        }
    }

    public function allDirections() : NavigatorInterface {
        var next : NavigatorCoreInterface = _navigator.allDirections();
        if (next == _navigator) {
            return this;
        } else {
            return new NavigatorStandard(_sprite, next);
        }
    }

    public function standard() : NavigatorInterface {
        var next : NavigatorCoreInterface = _navigator.standard();
        if (next == _navigator) {
            return this;
        } else {
            return new NavigatorStandard(_sprite, next);
        }
    }

    public function directionCount() : Int {
        return _navigator.directionCount();
    }

    public function directions() : NativeVector<DirectionInterface> {
        return _navigator.directions();
    }
    
    public function navigate(direction : DirectionInterface, distance : Int) : Bool {
        return _navigator.navigate(_sprite, direction, distance);
    }

    public function navigateInDegrees(direction : Float, distance : Int) : Bool {
        return _navigator.navigateInDegrees(_sprite, direction, distance);
    }

    public function navigateInRadians(direction : Float, distance : Int) : Bool {
        return _navigator.navigateInRadians(_sprite, direction, distance);
    }
    
    public function navigateInClock(direction : Float, distance : Int) : Bool {
        return _navigator.navigateInClock(_sprite, direction, distance);
    }
    
    public function navigateInXY(x : Int, y : Int) : Bool {
        return _navigator.navigateInXY(_sprite, x, y);
    }
}
