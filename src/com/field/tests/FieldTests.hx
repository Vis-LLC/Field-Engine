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

package com.field.tests;

import com.field.LocationStandard;
import com.field.NativeStringMap;
import com.field.NativeStringMap;

@:expose
@:nativeGen
class FieldTests extends TestCollection<FieldTests> {
    private var _field : Null<FieldInterface<Dynamic, Dynamic>> = null;
    private var _sub1 : Null<FieldInterface<Dynamic, Dynamic>> = null;
    private var _sub2 : Null<FieldInterface<Dynamic, Dynamic>> = null;
    private var _sub3 : Null<FieldInterface<Dynamic, Dynamic>> = null;
    private var _terrainTypes : Null<NativeArray<String>>;
    private var _locationPredefinedAttributes : Null<NativeStringMap<NativeArray<String>>>;
    private static var _terrain : String = "terrain";
    private static var _grass : String = "grass";
    private static var _water : String = "water";

    public function new() {
        super();
     }

    public override function init() : FieldTests {
        _terrainTypes = new NativeArray<String>();
        _terrainTypes.push(_grass);
        _terrainTypes.push(_water);
        _locationPredefinedAttributes = new NativeStringMap<NativeArray<String>>();
        _locationPredefinedAttributes.set(_terrain, _terrainTypes);
        _field = null;
        _sub1 = null;
        _sub2 = null;
        _sub3 = null;
        return super.init();
    }

    public function teardown() : FieldTests {
        _terrainTypes = null;
        _locationPredefinedAttributes = null;
        _field = null;
        _sub1 = null;
        _sub2 = null;
        _sub3 = null;

        return this;
    }

    public override function runAll() : FieldTests {
        init();
        test(initializeFieldMain);
        test(initializeSubField1);
        test(initializeSubField2);
        test(initializeSubField3);
        test(fillFieldMain);
        test(fillFieldSubField1);
        return super.runAll();
    }

    public function initializeFieldMain() : FieldTests {
        return run(function () {
            _field = FieldStandard.create(
                FieldStandard.options()
                .width(100)
                .height(100)
                .locationPredefinedAttributes(_locationPredefinedAttributes)
            );
            assert(_field.width() == 100, "Correct", "Incorrect", "Main Field Width Check");
            assert(_field.height() == 100, "Correct", "Incorrect", "Main Field Height Check");
        });
    }

    public function initializeSubField1() : FieldTests {
        return run(function () {
            _sub1 = FieldStandard.create(
                FieldStandard.options()
                .width(10)
                .height(5)
                .locationPredefinedAttributes(_locationPredefinedAttributes)
            );
            assert(_sub1.width() == 10, "Correct", "Incorrect", "Sub1 Field Width Check");
            assert(_sub1.height() == 5, "Correct", "Incorrect", "Sub1 Field Height Check");
        });
    }

    public function initializeSubField2() : FieldTests {
        return run(function () {
            _sub2 = FieldStandard.create(
                FieldStandard.options()
                .width(20)
                .height(15)
                .locationPredefinedAttributes(_locationPredefinedAttributes)
            );
            assert(_sub2.width() == 20, "Correct", "Incorrect", "Sub2 Field Width Check");
            assert(_sub2.height() == 15, "Correct", "Incorrect", "Sub2 Field Height Check");
        });
    }

    public function initializeSubField3() : FieldTests {
        return run(function () {
            _sub3 = FieldStandard.create(
                FieldStandard.options()
                .width(30)
                .height(50)
                .locationPredefinedAttributes(_locationPredefinedAttributes)
            );
            assert(_sub3.width() == 30, "Correct", "Incorrect", "Sub3 Field Width Check");
            assert(_sub3.height() == 50, "Correct", "Incorrect", "Sub3 Field Height Check");
        });
    }

    public function fillFieldMain() : FieldTests {
        return runAsync(function (done) {
            _field.attributeFill(_terrain, _water, function (data, error, slice, sliceCount) {
                var x = 0;
                var y = 0;
                while (y < _field.height()) {
                    x = 0;
                    while (x < _field.width()) {
                        var l : LocationStandard = _field.get(x, y);
                        var terrain : String = l.attribute(_terrain);
                        assert(terrain == _water, "Correct-" + terrain, "Incorrect-" + terrain, "Main Field Fill Check");
                        l.doneWith();
                        x++;
                    }
                    y++;
                }
                assert(recordCount() == (_field.height() * _field.width()), "Correct", "Incorrect", "Main Field Fill Size Check");
                done();
            });
        });
    }

    public function fillFieldSubField1() : FieldTests {
        return runAsync(function (done) {
            _sub1.attributeFill(_terrain, _grass, function (data, error, slice, sliceCount) {
                var x = 0;
                var y = 0;
                while (y < _sub1.height()) {
                    x = 0;
                    while (x < _sub1.width()) {
                        var l : LocationStandard = _sub1.get(x, y);
                        var terrain : String = l.attribute(_terrain);
                        assert(terrain == _grass, "Correct-" + terrain, "Incorrect-" + terrain, "Sub1 Field Fill Check");
                        l.doneWith();
                        x++;
                    }
                    y++;
                }
                assert(recordCount() == (_sub1.height() * _sub1.width()), "Correct", "Incorrect", "Sub1 Field Fill Size Check");
                done();
            });
        });
    }
}
