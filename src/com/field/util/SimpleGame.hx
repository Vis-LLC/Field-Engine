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
class SimpleGame extends SimpleApp {
    private static var _instances : Array<SimpleGame> = new Array<SimpleGame>();

    private function new() {
        super(false);
        _instances.push(this);
    }

    public function init() : Void { }
    
    public static function beginLoad() : Void {
        SimpleApp.initSystem();
        SimpleApp.loadInstancesOf(SimpleGame);
        if (_instances.length == 1) {
            _instances[0].Load();
        }        
    }
}