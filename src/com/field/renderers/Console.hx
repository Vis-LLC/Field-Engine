/*
    Copyright (C) 2020-2023 Vis LLC - All Rights Reserved

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

package com.field.renderers;

#if !EXCLUDE_RENDERING_CONSOLE
import com.field.NativeArray;

@:expose
@:nativeGen
/**
    A Bridge Abstract for determining how a FieldView should render it's display to a console (text view).
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class Console extends RendererConsoleAbstract {
    public static var _instance : RendererInterface = new Console();

    private function new() {
        super();
    }

    public override function hide(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        // TODO?
        return this;
    }

    public override function show(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        // TODO
        return this;
    }

    public override function left(x : Float, dRectWidth : Float, dTileBuffer : Float, dTileWidth : Float) : LeftStyle {
        return null;
    }

    public override function top(y : Float, dRectHeight : Float, dTileBuffer : Float, dTileHeight : Float) : TopStyle {
        return null;
    }

    public override function moveTo(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileBuffer : Float, dTileWidth : Float, dTileHeight : Float, left : LeftStyle, top : TopStyle, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {

        return this;
    }

    public override function scroll(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileWidth : Float, dTileHeight : Float, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        // TODO
        return this;
    }

    public override function willChange(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        return this;
    }

    public override function getX(e : Element, dRectWidth : Float, dTileWidth : Float, scale : Float) : Float {
        var e2 : Array<Dynamic> = cast e;
        return Math.floor(e2[0] / dTileWidth);
    }

    public override function getY(e : Element, dRectHeight : Float, dTileHeight : Float, scale : Float) : Float {
        var e2 : Array<Dynamic> = cast e;
        return Math.floor(e2[1] / dTileHeight);
    }

    public override function getFieldX(e : Element, dRectWidth : Float, dTileWidth : Float) : Float {
        return getX(e, dRectWidth, dTileWidth, 1);
    }

    public override function getFieldY(e : Element, dRectHeight : Float, dTileHeight : Float) : Float {
        return getY(e, dRectHeight, dTileHeight, 1);
    }

    public override function moveSpriteTo(e1 : Element, e2 : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) {
        // TODO
        return this;
    }
}
#end