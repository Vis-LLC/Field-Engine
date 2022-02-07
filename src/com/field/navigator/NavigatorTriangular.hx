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
class DirectionTriangularUp extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionTriangularUp();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionTriangularLeftDown extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionTriangularLeftDown();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionTriangularRightDown extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionTriangularRightDown();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionTriangularRightUp extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionTriangularRightUp();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionTriangularLeftUp extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionTriangularLeftUp();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionTriangularDown extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionTriangularDown();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

// TODO - Complete Triangular

@:expose
@:nativeGen
class NavigatorTriangular extends NavigatorCoreAbstract {
    private static var _directions : NativeVector<DirectionInterface>;
    private static var _instance : NavigatorCoreInterface = new NavigatorTriangular();

    private function new() {
        super(0);
        _directions = initDirections();
    }

    public static function instance() : NavigatorCoreInterface {
        return _instance;
    }

    public override function directions() : NativeVector<DirectionInterface> {
        return _directions;
    }

    public override function diagonal() : NavigatorCoreInterface {
        return null;
    }

    public override function allDirections() : NavigatorCoreInterface {
        return null;
    }

    public override function standard() : NavigatorCoreInterface {
        return this;
    }

    private static function initDirections() : NativeVector<DirectionInterface> {
        var directions : NativeArray<DirectionAbstract> = new NativeArray<DirectionAbstract>();

        directions.push(cast DirectionTriangularUp.instance());
        directions.push(cast DirectionTriangularLeftDown.instance());
        directions.push(cast DirectionTriangularRightDown.instance());
        directions.push(cast DirectionTriangularRightUp.instance());
        directions.push(cast DirectionTriangularLeftUp.instance());
        directions.push(cast DirectionTriangularDown.instance());        
        
        directions.get(0).init("Up", directions.get(2), directions.get(1), null, directions.get(5), 90, 0, 3, 1, 2, -0.5, 0);
        directions.get(1).init("LeftDown", directions.get(0), directions.get(2), null, directions.get(3), 90, 1, 3, 1, 2, -0.5, 0);
        directions.get(2).init("RightDown", directions.get(1), directions.get(0), null, directions.get(4), 90, 2, 3, 1, 2, -0.5, 0);

        directions.get(3).init("RightUp", directions.get(5), directions.get(4), null, directions.get(2), 45, 0, 3, 1, 2, -0.5, 0);
        directions.get(4).init("LeftUp", directions.get(3), directions.get(5), null, directions.get(1), 45, 1, 3, 1, 2, -0.5, 0);
        directions.get(5).init("Down", directions.get(4), directions.get(3), null, directions.get(0), 45, 2, 3, 1, 2, -0.5, 0);

        return cast directions.toVector();
    }
}
