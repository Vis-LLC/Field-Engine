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

@:expose
@:nativeGen
class TestData {
    public inline function new() { }

    public var name : Null<String>;
    public var start : Null<Date>;
    public var end : Null<Date>;
    public var duration : Null<Int>;
    public var records : Null<NativeStringMap<Entry>>;
    public var recordsCount : Null<Int>;
    public var pass : Null<Bool>;
    public var result : Null<String>;
}

@:expose
@:nativeGen
class Entry {
    public inline function new(pass : Null<Bool>, result : Null<String>, location : Null<String>, at : Null<Date>, index : Null<Int>) {
        this.pass = pass;
        this.result = result;
        this.location = location;
        this.at = at;
        this.index = index;
    }

    public var pass : Null<Bool>;
    public var result : Null<String>;
    public var location : Null<String>;
    public var at : Null<Date>;
    public var index : Null<Int>;
}