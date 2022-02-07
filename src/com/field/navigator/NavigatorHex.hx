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
class DirectionHexRightUp extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexRightUp();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexCenterUp extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexCenterUp();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexLeftUp extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexLeftUp();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexLeftDown extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexLeftDown();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexCenterDown extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexCenterDown();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexRightDown extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexRightDown();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexDiagonalRightUpCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexDiagonalRightUpCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexDiagonalRightCenterCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexDiagonalRightCenterCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexDiagonalRightDownCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexDiagonalRightDownCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexDiagonalLeftDownCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexDiagonalLeftDownCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexDiagonalLeftCenterCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexDiagonalLeftCenterCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexDiagonalLeftUpCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexDiagonalLeftUpCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

/////////////

@:expose
@:nativeGen
class DirectionHexAllRightUp extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexAllRightUp();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexAllCenterUp extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexAllCenterUp();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexAllLeftUp extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexAllLeftUp();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexAllLeftDown extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexAllLeftDown();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexAllCenterDown extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexAllCenterDown();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexAllRightDown extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexAllRightDown();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexAllRightUpCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexAllRightUpCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexAllRightCenterCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexAllRightCenterCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexAllRightDownCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexAllRightDownCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexAllLeftDownCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexAllLeftDownCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexAllLeftCenterCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexAllLeftCenterCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class DirectionHexAllLeftUpCorner extends DirectionAbstract {
    private static var _instance : DirectionInterface = new DirectionHexAllLeftUpCorner();

    private function new() {
        super();
    }

    public static function instance() : DirectionInterface {
        return _instance;
    }
}

@:expose
@:nativeGen
class NavigatorHex extends NavigatorCoreAbstract {
    private static var _directions : NativeVector<DirectionInterface>;
    private static var _instance : NavigatorCoreInterface = new NavigatorHex();

    private function new() {
        super(30);
        _directions = initDirections();
    }

    public static function instance() : NavigatorCoreInterface {
        return _instance;
    }

    public override function directions() : NativeVector<DirectionInterface> {
        return _directions;
    }

    public override function diagonal() : NavigatorCoreInterface {
        return NavigatorHexDiagonal.instance();
    }

    public override function allDirections() : NavigatorCoreInterface {
        return NavigatorHexAllDirections.instance();
    }

    public override function standard() : NavigatorCoreInterface {
        return this;
    }

    private static function initDirections() : NativeVector<DirectionInterface> {
        var directions : NativeArray<DirectionAbstract> = new NativeArray<DirectionAbstract>();

        directions.push(cast DirectionHexRightUp.instance());
        directions.push(cast DirectionHexCenterUp.instance());
        directions.push(cast DirectionHexLeftUp.instance());
        directions.push(cast DirectionHexLeftDown.instance());
        directions.push(cast DirectionHexCenterDown.instance());
        directions.push(cast DirectionHexRightDown.instance());

        directions.get(0).init("RightUp", directions.get(5), directions.get(1), directions.get(3), directions.get(3), 30, 0, 6, 1, 2, -0.5, 0);
        directions.get(1).init("CenterUp", directions.get(0), directions.get(2), directions.get(4), directions.get(4), 30, 1, 6, 1, 2, -0.5, 0);
        directions.get(2).init("LeftUp", directions.get(1), directions.get(3), directions.get(5), directions.get(5), 30, 2, 6, 1, 2, -0.5, 0);
        directions.get(3).init("LeftDown", directions.get(2), directions.get(4), directions.get(0), directions.get(0), 30, 3, 6, 1, 2, -0.5, 0);
        directions.get(4).init("CenterDown", directions.get(3), directions.get(5), directions.get(1), directions.get(1), 30, 4, 6, 1, 2, -0.5, 0);
        directions.get(5).init("RightDown", directions.get(4), directions.get(0), directions.get(2), directions.get(2), 30, 5, 6, 1, 2, -0.5, 0);

        return cast directions.toVector();
    }
}

@:expose
@:nativeGen
class NavigatorHexDiagonal extends NavigatorCoreAbstract {
    private static var _directions : NativeVector<DirectionInterface>;
    private static var _instance : NavigatorCoreInterface = new NavigatorHexDiagonal();

    private function new() {
        super(30);
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
        return NavigatorHexAllDirections.instance();
    }

    public override function standard() : NavigatorCoreInterface {
        return NavigatorHex.instance();
    }

    private static function initDirections() : NativeVector<DirectionInterface> {
        var directions : NativeArray<DirectionAbstract> = new NativeArray<DirectionAbstract>();

        directions.push(cast DirectionHexDiagonalRightCenterCorner.instance());
        directions.push(cast DirectionHexDiagonalRightUpCorner.instance());
        directions.push(cast DirectionHexDiagonalLeftUpCorner.instance());
        directions.push(cast DirectionHexDiagonalLeftCenterCorner.instance());
        directions.push(cast DirectionHexDiagonalLeftDownCorner.instance());
        directions.push(cast DirectionHexDiagonalRightDownCorner.instance());

        directions.get(0).init("RightCenterCorner", directions.get(5), directions.get(1), directions.get(3), directions.get(3), 0, 0, 6, 1, 2, -0.5, 0);
        directions.get(1).init("RightUpCorner", directions.get(0), directions.get(2), directions.get(4), directions.get(4), 0, 1, 6, 1, 2, -0.5, 0);
        directions.get(2).init("LeftUpCorner", directions.get(1), directions.get(3), directions.get(5), directions.get(5), 0, 2, 6, 1, 2, -0.5, 0);
        directions.get(3).init("LeftCenterCorner", directions.get(2), directions.get(4), directions.get(0), directions.get(0), 0, 3, 6, 1, 2, -0.5, 0);
        directions.get(4).init("LeftDownCorner", directions.get(3), directions.get(5), directions.get(1), directions.get(1), 0, 4, 6, 1, 2, -0.5, 0);
        directions.get(5).init("RightDownCorner", directions.get(4), directions.get(0), directions.get(2), directions.get(2), 0, 5, 6, 1, 2, -0.5, 0);

        return cast directions.toVector();
    }
}

@:expose
@:nativeGen
class NavigatorHexAllDirections extends NavigatorCoreAbstract {
    private static var _directions : NativeVector<DirectionInterface>;
    private static var _instance : NavigatorCoreInterface = new NavigatorHexAllDirections();

    private function new() {
        super(30);
        _directions = initDirections();
    }

    public static function instance() : NavigatorCoreInterface {
        return _instance;
    }

    public override function directions() : NativeVector<DirectionInterface> {
        return _directions;
    }

    public override function diagonal() : NavigatorCoreInterface {
        return NavigatorHexDiagonal.instance();
    }

    public override function allDirections() : NavigatorCoreInterface {
        return this;
    }

    public override function standard() : NavigatorCoreInterface {
        return NavigatorHex.instance();
    }

    private static function initDirections() : NativeVector<DirectionInterface> {
        var directions : NativeArray<DirectionAbstract> = new NativeArray<DirectionAbstract>();

        directions.push(cast DirectionHexAllRightCenterCorner.instance());
        directions.push(cast DirectionHexAllRightUp.instance());
        directions.push(cast DirectionHexAllRightUpCorner.instance());
        directions.push(cast DirectionHexAllCenterUp.instance());
        directions.push(cast DirectionHexAllLeftUpCorner.instance());
        directions.push(cast DirectionHexAllLeftUp.instance());
        directions.push(cast DirectionHexAllLeftCenterCorner.instance());
        directions.push(cast DirectionHexAllLeftDown.instance());
        directions.push(cast DirectionHexAllLeftDownCorner.instance());
        directions.push(cast DirectionHexAllCenterDown.instance());
        directions.push(cast DirectionHexAllRightDownCorner.instance());
        directions.push(cast DirectionHexAllRightDown.instance());

        directions.get( 0).init("RightCenterCorner", directions.get(11), directions.get(1), directions.get(6), directions.get(6), 0, 0, 12, 1, 2, -0.5, 0);
        directions.get( 1).init("RightUp", directions.get(0), directions.get(2), directions.get(7), directions.get(7), 0, 1, 12, 1, 2, -0.5, 0);
        directions.get( 2).init("RightUpCorner", directions.get(1), directions.get(3), directions.get(8), directions.get(8), 0, 2, 12, 1, 2, -0.5, 0);
        directions.get( 3).init("CenterUp", directions.get(2), directions.get(4), directions.get(9), directions.get(9), 0, 3, 12, 1, 2, -0.5, 0);
        directions.get( 4).init("LeftUpCorner", directions.get(3), directions.get(5), directions.get(10), directions.get(10), 0, 4, 12, 1, 2, -0.5, 0);
        directions.get( 5).init("LeftUp", directions.get(4), directions.get(6), directions.get(11), directions.get(11), 0, 5, 12, 1, 2, -0.5, 0);
        directions.get( 6).init("LeftCenterCorner", directions.get(5), directions.get(7), directions.get(0), directions.get(0), 0, 6, 12, 1, 2, -0.5, 0);
        directions.get( 7).init("LeftDown", directions.get(6), directions.get(8), directions.get(1), directions.get(1), 0, 7, 12, 1, 2, -0.5, 0);
        directions.get( 8).init("LeftDownCorner", directions.get(7), directions.get(9), directions.get(2), directions.get(2), 0, 8, 12, 1, 2, -0.5, 0);
        directions.get( 9).init("CenterDown", directions.get(8), directions.get(10), directions.get(3), directions.get(3), 0, 9, 12, 1, 2, -0.5, 0);
        directions.get(10).init("RightDownCorner", directions.get(9), directions.get(11), directions.get(4), directions.get(4), 0, 10, 12, 1, 2, -0.5, 0);
        directions.get(11).init("RightDown", directions.get(10), directions.get(0), directions.get(5), directions.get(5), 0, 11, 12, 1, 2, -0.5, 0);

        return cast directions.toVector();
    }
}