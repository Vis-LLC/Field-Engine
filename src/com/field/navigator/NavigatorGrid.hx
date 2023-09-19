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
class DirectionGridDown extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridDown();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridRight extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridRight();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridUp extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridUp();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridLeft extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridLeft();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridDiagonalRightDownCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridDiagonalRightDownCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridDiagonalRightUpCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridDiagonalRightUpCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridDiagonalLeftUpCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridDiagonalLeftUpCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridDiagonalLeftDownCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridDiagonalLeftDownCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridAllDown extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridAllDown();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridAllRight extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridAllRight();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridAllUp extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridAllUp();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridAllLeft extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridAllLeft();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridAllRightDownCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridAllRightDownCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridAllRightUpCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridAllRightUpCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridAllLeftUpCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridAllLeftUpCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionGridAllLeftDownCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionGridAllLeftDownCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class NavigatorGrid extends NavigatorCoreAbstract {
    private static var _directions : NativeVector<DirectionInterface>;
    private static var _instance : NavigatorCoreInterface = new NavigatorGrid();

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
        return NavigatorGridDiagonal.instance();
    }

    public override function allDirections() : NavigatorCoreInterface {
        return NavigatorGridAllDirections.instance();
    }

    public override function standard() : NavigatorCoreInterface {
        return this;
    }

    private static function initDirections() : NativeVector<DirectionInterface> {
        var directions : NativeArray<DirectionAbstract> = new NativeArray<DirectionAbstract>();

        directions.push(cast DirectionGridRight.instance());
        directions.push(cast DirectionGridDown.instance());
        directions.push(cast DirectionGridLeft.instance());
        directions.push(cast DirectionGridUp.instance());

        directions.get(0).init("Right", directions.get(3), directions.get(1), directions.get(2), directions.get(2), 0, 0, 4, 1, 1, 0, 0);
        directions.get(1).init("Down", directions.get(2), directions.get(0), directions.get(3), directions.get(3), 0, 1, 4, 1, 1, 0, 0);
        directions.get(2).init("Left", directions.get(1), directions.get(3), directions.get(0), directions.get(0), 0, 2, 4, 1, 1, 0, 0);
        directions.get(3).init("Up", directions.get(0), directions.get(2), directions.get(1), directions.get(1), 0, 3, 4, 1, 1, 0, 0);

        return cast directions.toVector();
    }
}

@:expose
@:nativeGen
class NavigatorGridDiagonal extends NavigatorCoreAbstract {
    private static var _directions : NativeVector<DirectionInterface>;
    private static var _instance : NavigatorCoreInterface = new NavigatorGridDiagonal();

    private function new() {
        super(45);
        _directions = initDirections();
    }

    public static function instance() : NavigatorCoreInterface {
        return _instance;
    }

    public override function directions() : NativeVector<DirectionInterface> {
        return _directions;
    }

    public override function diagonal() : NavigatorCoreInterface {
        return this;
    }

    public override function allDirections() : NavigatorCoreInterface {
        return NavigatorGridAllDirections.instance();
    }

    public override function standard() : NavigatorCoreInterface {
        return NavigatorGrid.instance();
    }

    private static function initDirections() : NativeVector<DirectionInterface> {
        var directions : NativeArray<DirectionAbstract> = new NativeArray<DirectionAbstract>();

        directions.push(cast DirectionGridDiagonalRightDownCorner.instance());
        directions.push(cast DirectionGridDiagonalLeftDownCorner.instance());
        directions.push(cast DirectionGridDiagonalLeftUpCorner.instance());
        directions.push(cast DirectionGridDiagonalRightUpCorner.instance());

        directions.get(0).init("RightDownCorner", directions.get(3), directions.get(1), directions.get(2), directions.get(2), 45, 0, 4, 1, 1, 0, 0);
        directions.get(1).init("LeftDownCorner", directions.get(2), directions.get(0), directions.get(3), directions.get(3), 45, 1, 4, 1, 1, 0, 0);
        directions.get(2).init("LeftUpCorner", directions.get(1), directions.get(3), directions.get(0), directions.get(0), 45, 2, 4, 1, 1, 0, 0);
        directions.get(3).init("RightUpCorner", directions.get(0), directions.get(2), directions.get(1), directions.get(1), 45, 3, 4, 1, 1, 0, 0);

        return cast directions.toVector();
    }
}

@:expose
@:nativeGen
class NavigatorGridAllDirections extends NavigatorCoreAbstract {
    private static var _directions : NativeVector<DirectionInterface>;
    private static var _instance : NavigatorCoreInterface = new NavigatorGridAllDirections();

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
        return NavigatorGridDiagonal.instance();
    }

    public override function allDirections() : NavigatorCoreInterface {
        return this;
    }

    public override function standard() : NavigatorCoreInterface {
        return NavigatorGrid.instance();
    }

    private static function initDirections() : NativeVector<DirectionInterface> {
        var directions : NativeArray<DirectionAbstract> = new NativeArray<DirectionAbstract>();

        directions.push(cast DirectionGridAllRight.instance());
        directions.push(cast DirectionGridAllRightDownCorner.instance());
        directions.push(cast DirectionGridAllDown.instance());
        directions.push(cast DirectionGridAllLeftDownCorner.instance());
        directions.push(cast DirectionGridAllLeft.instance());
        directions.push(cast DirectionGridAllLeftUpCorner.instance());
        directions.push(cast DirectionGridAllUp.instance());
        directions.push(cast DirectionGridAllRightUpCorner.instance());

        directions.get(0).init("Right", directions.get(7), directions.get(1), directions.get(4), directions.get(4), 0, 0, 8, 1, 1, 0, 0);
        directions.get(1).init("RightDownCorner", directions.get(0), directions.get(2), directions.get(5), directions.get(5), 0, 1, 8, 1, 1, 0, 0);
        directions.get(2).init("Down", directions.get(1), directions.get(3), directions.get(6), directions.get(6), 0, 2, 8, 1, 1, 0, 0);
        directions.get(3).init("LeftDownCorner", directions.get(2), directions.get(4), directions.get(7), directions.get(7), 0, 3, 8, 1, 1, 0, 0);
        directions.get(4).init("Left", directions.get(3), directions.get(5), directions.get(0), directions.get(0), 0, 4, 8, 1, 1, 0, 0);
        directions.get(5).init("LeftUpCorner", directions.get(4), directions.get(6), directions.get(1), directions.get(1), 0, 5, 8, 1, 1, 0, 0);
        directions.get(6).init("Up", directions.get(5), directions.get(7), directions.get(2), directions.get(2), 0, 6, 8, 1, 1, 0, 0);
        directions.get(7).init("RightUpCorner", directions.get(6), directions.get(0), directions.get(3), directions.get(3), 0, 7, 8, 1, 1, 0, 0);

        return cast directions.toVector();
    }
}
