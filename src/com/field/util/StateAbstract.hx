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

@:expose
@:nativeGen
/**
    Provides basic functionality for implementing the State interface.
**/
class StateAbstract implements State {
    /**
        Do a callback after completing an operation.
    **/
    private function call(callback : Any, success : Bool, data : Any) : Void {
        if (callback != null && callback != "") {
            var result : StateResult = new StateResult();
            result.Success = success;
            result.Data = data;

            if (Std.is(callback, String)) {
                // TODO - Use reflection in various languages
                // Haxe
                // Java
                // C#
                // Other?
                #if js
                    js.Syntax.code("eval({0})({1});", callback, result);
                #else
                #end
            } else {
                #if js
                    js.Syntax.code("{0}({1});", callback, result);
                #else
                #end
            }
        }
    }

    public function getValue(name : String, callback : Any) : Void { }
    public function setValue(name : String, value : Any, callback : Any) : Void { }
    public function get(callback : Any) : Void { }
    public function set(state : String, callback : Any) : Void { }
    public function list(callback : Any) : Void { }
    public function load(name : String, callback : Any) : Void { }
    public function save(name : String, state : String, callback : Any) : Void { }
    public function signout() : Void { }
    public function signin() : Void { }
    public function incrementAchievement(id : String, amount : Int, callback : Any) : Void { }
    public function getAchievementStatus(callback : Any) : Void { }

    /**
        Retrieve the recommended State implementation.
    **/
    public static function getState() : State {
        try {
            var instance : Any = null;
            #if js
                instance = js.Lib.eval("State");
            #end
            if (instance != null) {
                return cast instance;
            } else {
                return StateStub.instance;
            }
        } catch (ex : Any) {
            return StateStub.instance;
        }
    }
}