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

package com.field.util;

import haxe.xml.Access;

@:expose
@:nativeGen
/**
    A basic implementation of the State interface.
**/
class StateStub extends StateAbstract {
    private var _data : Null<StateStubData> = null;
    public static var instance = new StateStub();

    inline private function new() {
        super();
    }

    private function checkFirstLoad() : Void {
        if (_data == null) {
            loadFromLocal();
            if (_data == null) {
                _data = new StateStubData();
            }
        }
    }

    private function checkValues() : Void {
        checkFirstLoad();
        if (_data._values == null) {
            _data._values = new NativeStringMap<String>();
        }
    }

    private function checkData() : Void {
        checkFirstLoad();
        if (_data._data == null) {
            _data._data = new NativeStringMap<String>();
        }
    }    

    public override function getValue(name : String, callback : Any) : Void {
        checkValues();
        call(callback, true, _data._values.get(name));
    }

    public override function setValue(name : String, value : Any, callback : Any) : Void {
        checkValues();
        _data._values.set(name, value);
        saveToLocal();
        call(callback, true, null);
    }

    public override function get(callback : Any) : Void {
        checkFirstLoad();
        if (_data._state == null) {
            call(callback, true, "");
        } else {
            call(callback, true, _data._state);
        }
    }

    public override function set(state : String, callback : Any) : Void {
        _data._state = state;
        saveToLocal();
        call(callback, true, null);
    }

    public override function list(callback : Any) : Void {
        checkData();
        var result : NativeStringMap<StateListEntry> = new NativeStringMap<StateListEntry>();
        #if (hax_ver >= 4)
        for (key => value in _data) {
        #else
        for (key in _data._data.keys()) {
        #end
            var entry : StateListEntry = new StateListEntry();
            entry.Name = key;
            //entry.Modified =
            result.set(key, entry);
        }
    }

    public override function load(name : String, callback : Any) : Void {
        checkData();
        call(callback, true, _data._data.get(name));
    }

    public override function save(name : String, state : String, callback : Any) : Void {
        checkData();        
        _data._data.set(name, state);
        saveToLocal();
        call(callback, true, null);
    }

    public override function signout() : Void {

    }

    public override function signin() : Void {

    }

    public override function incrementAchievement(id : String, amount : Int, callback : Any) : Void {
        checkFirstLoad();
        if (_data._achievements == null) {
            _data._achievements = new NativeStringMap<Int>();
            _data._achievementsList = new NativeArray<StateAchievementEntry>();
        }
        if (id != null) {
            var index : Null<Int> = _data._achievements.get(id);
            var value : Int;
            if (index == null) {
                var achievement = new StateAchievementEntry();
                index = _data._achievementsList.length();
                _data._achievementsList.push(achievement);
                achievement.id = id;
                achievement.name = id;
                achievement.description = id;
                achievement.progress = 0;
                value = 0;
            } else {
                value = _data._achievementsList.get(index).progress;
            }
            value++;
            _data._achievementsList.get(index).progress = value;
            saveToLocal();
        }
        if (callback != null) {
            call(callback, true, _data._achievementsList);
        }
    }

    public override function getAchievementStatus(callback : Any) : Void {
        incrementAchievement(null, 0, callback);
    }

    private static var _stateStart : String = "state=";

    private function saveToLocal() : Void {
        saveToLocalI(haxe.Json.stringify(_data));
    }

    private function loadFromLocal() : Void {
        _data = cast haxe.Json.parse(loadFromLocalI());
    }

    private function saveToLocalI(data : String) : Void {
        #if JS_BROWSER
            js.Syntax.code("document.cookie = \"state=\" + encodeURIComponent({0}) + \";expires=\" + (new Date(8640000000000000).toUTCString()) + \";path=\" + document.location.pathname", data);
        #end
    }

    private function loadFromLocalI() : String {
        #if JS_BROWSER
            var cookie : NativeVector<String> = cast js.Syntax.code("document.cookie.split(\";\")");
            var i : Int = 0;
            var state : Null<String> = null;
            while (i < cookie.length()) {
                if (cookie.get(i).indexOf(_stateStart) == 0) {
                    state = cookie.get(i).substr(_stateStart.length);
                }
                i++;
            }
            return js.Syntax.code("decodeURIComponent({0})", state);
        #else
            return "";
        #end
    }
}

@:nativeGen
/**
    A basic implementation of data for the State interface.
**/
class StateStubData {
    inline public function new() { }

    public var _data : Null<NativeStringMap<String>> = null;
    public var _values : Null<NativeStringMap<String>> = null;
    public var _state : Null<String> = null;
    public var _achievements : Null<NativeStringMap<Int>> = null;
    public var _achievementsList : Null<NativeArray<StateAchievementEntry>> = null;
}

@:nativeGen
/**
    A basic implementation of achievements for the State interface.
**/
class StateAchievementEntry {
    inline public function new() { }

    public var id : String;
    public var name : String;
    public var hidden : Bool;
    public var unlocked : Bool;
    public var steps : Int;
    public var progress : Int;
    public var description : String;
}