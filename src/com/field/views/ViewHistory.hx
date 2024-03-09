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

package com.field.views;

#if !EXCLUDE_RENDERING
import com.field.Logger;
import com.field.renderers.Element;
import com.field.renderers.EventInfoInterface;
import com.field.renderers.RendererMode;
import com.field.renderers.Style;

@:expose
@:nativeGen
/**
    Tracks history of a view for smooth scroll.
**/
class ViewHistory {
    public var previousUpdate : Null<Int>;
    public var previousX : Null<Float>;
    public var previousY : Null<Float>;
    public var currentUpdate : Null<Int>;
    public var currentX : Null<Float>;
    public var currentY : Null<Float>;

    private static var _pauseTime : Int = 0;
    private static var _pauseDuration : Int = 0;

    public function new() { }

    public function update(x : Float, y : Float) : Null<Bool> {
        var r : Null<Bool>;
        var now : Int = cast haxe.Timer.stamp() * 1000;
        if (currentUpdate != null && previousUpdate != null) {
            // TODO - Make 30 adjustable
            r = Math.floor((now - currentUpdate) / 30) == Math.floor((currentUpdate - previousUpdate) / 30)
            && (x - currentX) == (currentX - previousX)
            && (y - currentY) == (currentY - previousY);
        } else {
            r = currentUpdate != null ? true : null;
        }
        previousUpdate = currentUpdate;
        if (previousUpdate < _pauseTime) {
            previousUpdate += _pauseDuration;
        }
        previousX = currentX;
        previousY = currentY;
        currentUpdate = now;
        currentX = x;
        currentY = y;
        return r;
    }

    public function clear() : Void {
        previousUpdate = null;
        previousX = null;
        previousY = null;
        currentUpdate = null;
        currentX = null;
        currentY = null;
    }

    public static function addPauseDuration(pauseTime : Int, pauseDuration : Int) : Void {
        _pauseTime = pauseTime;
        _pauseDuration = pauseDuration;
    }
}
#end