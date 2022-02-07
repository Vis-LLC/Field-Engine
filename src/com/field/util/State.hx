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
    Allows saving and loading of state and related functions.  Since where this actually saves varies a bit, all functions take a callback.
    Callbacks can a function or a string specifying a function.
**/
interface State {
    /**
        Get an individual saved value.
    **/
    function getValue(name : String, callback : Any) : Void;

    /**
        Save an individual value.
    **/
    function setValue(name : String, value : Any, callback : Any) : Void;

    /**
        Get the entire current state.
    **/
    function get(callback : Any) : Void;

    /**
        Set the entire current state.
    **/
    function set(state : String, callback : Any) : Void;

    /**
        List saved states.
    **/
    function list(callback : Any) : Void;

    /**
        Load a saved state.
    **/
    function load(name : String, callback : Any) : Void;

    /**
        Save a state.
    **/
    function save(name : String, state : String, callback : Any) : Void;

    /**
        Signout
    **/
    function signout() : Void;

    /**
        Signin
    **/
    function signin() : Void;

    /**
        Increment Achievement
    **/
    function incrementAchievement(id : String, amount : Int, callback : Any) : Void;

    /**
        Get Achievement Status
    **/
    function getAchievementStatus(callback : Any) : Void;
}