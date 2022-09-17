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

package com.field;

@:expose
@:nativeGen
/**
    Collection of routines that allow for tapping into some of the underlying functionality.
**/
class Advanced {
    private function new() { }

    #if !EXCLUDE_RENDERING
    /**
        Trigger the start of a graphics update, used for grouping operations together.
    **/
    public static function startGraphicsUpdate() : Void {
        com.field.renderers.RendererAbstract.currentMode().start();
    }

    /**
        Trigger the end of a graphics update, used for grouping operations together.
    **/
    public static function endGraphicsUpdate() : Void {
        com.field.renderers.RendererAbstract.currentMode().end();
    }

    /**
        Add something to the graphics update queue, used for grouping operations together.
    **/    
    public static function queueGraphicsUpdate(f : Void->Void) {
        com.field.renderers.RendererAbstract.currentMode().now(f);
    }
    #end
}