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

import com.field.NativeArray;
import com.field.NativeStringMap;
import com.field.tests.TestData.Entry;

@:expose
@:nativeGen
class TestCollection<TC> {
    private static var _currentTestName : Null<String> = null;
    private static var _currentTest : Null<TestData> = null;
    private static var _currentPassing : Null<Bool> = null;
    private static var _testCollection : Null<NativeArray<Void->Void>> = null;
    private var _tests : Null<NativeStringMap<TestData>>;
    private var _testsCount : Null<Int> = null;
    private var _passed : Null<Bool> = null;

    public function new() { }

    public function init() : TC {
        _currentTestName = null;
        _currentTest = null;
        _currentPassing = null;
        _testCollection = null;
        _tests = null;
        _testsCount = null;
        _passed = null;

        return cast this;
    }

    private static function isPassing() : Bool {
        return _currentPassing;
    }

    private function start(?pos : haxe.PosInfos) : Void {
        if (_tests == null) {
            _tests = new NativeStringMap<TestData>();
        }
        _currentTestName = pos.className + "." + pos.methodName;
        _currentTest = new TestData();
        _currentTest.recordsCount = 0;
        _tests.set(_currentTestName, _currentTest);
        _currentPassing = true;
        _currentTest.start = Date.now();
    }

    private function end() : Void {
        _currentTest.end = Date.now();
        _currentTest.duration = Math.floor(_currentTest.end.getTime() - _currentTest.start.getTime());
    }

    private static function cleanup() : Void {
        _currentTestName = null;
        _currentTest = null;
        _currentPassing = null;
    }

    private static function evaluate(v : Any) : String {
        try {
            var f : Void->Any = cast v;
            v = f();
        } catch (msg : Any) { }
        return cast v;
    }

    private function assert(condition : Bool, ?pass : Any, ?fail : Any, ?name : Null<String>, ?pos : haxe.PosInfos) : Void {
        if (name == null) {
            name = pos.className + "." + pos.methodName + ":" + pos.lineNumber;
        }
        var details : Null<String>;
        if (condition == true) {
            details = evaluate(pass);
        } else {
            details = evaluate(fail);
        }
        _currentPassing = _currentPassing && condition;
        if (_currentTest.records == null) {
            _currentTest.records = new NativeStringMap<Entry>();
        }
        _currentTest.records.set(_currentTest.recordsCount + ";" + name, new Entry(condition, details, name, Date.now(), _currentTest.recordsCount));
        _currentTest.recordsCount++;
    }

    private static function result(condition : Bool, ?pass : Any, ?fail : Any) : Void {
        var details : Null<String>;
        if (condition == true) {
            details = evaluate(pass);
        } else {
            details = evaluate(fail);
        }
        _currentPassing = _currentPassing && condition;
        _currentTest.result = details;
        _currentTest.pass = condition;
    }

    private function run(f : Void->Void, ?pos : haxe.PosInfos) : TC {
        start(pos);
        f();
        end();
        if (_currentTest.pass == null) {
            result(isPassing());
        }
        cleanup();
        keepRunning();
        return cast this;
    }

    private function runAsync(f : (Void->Void)->Void, ?pos : haxe.PosInfos) : TC {
        start(pos);
        f(function () {
            end();
            if (_currentTest.pass == null) {
                result(isPassing());
            }
            cleanup();
            keepRunning();
        });
        return cast this;
    }

    private function test(f : Void->Void) : TC {
        if (_testCollection == null) {
            _testCollection = new NativeArray<Void->Void>();
        }
        _testCollection.push(f);
        return cast this;
    }

    private function keepRunning() : TC {
        if (_testCollection != null && _testCollection.length() > 0) {
            _testCollection.shift()();
        } else {
            _testCollection = null;
            _passed = true;
            _testsCount = 0;
            for (k in _tests.keys()) {
                _testsCount++;
                _passed = _passed && _tests.get(k).pass;
            }
        }
        return cast this;
    }

    public function runAll() : TC {
        return keepRunning();
    }

    private function recordCount() : Int {
        return _currentTest.recordsCount;
    }
}
