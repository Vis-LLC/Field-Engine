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

package com.field.renderers;

@:expose
@:nativeGen
/**
    A Bridge for determining how a FieldView should render it's display using DOM (Document Object Model) layouts, with the information represented in Percentages.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class DomLayout extends RendererDomAbstract {
    public static var _instance : RendererInterface = new DomLayout();

    private function new() {
        super();
    }

    private inline function display(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>, display : String, transition : String) : RendererInterface {
        now(function () {
            styleDisplay(e, display);
            styleTransition(e, transition);
        }, tempMode);

        return this;
    }

    public override function hide(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        return display(e, f, tempMode, "none", "none");
    }

    public override function show(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        return display(e, f, tempMode, "", "");
    }

    public override function left(x : Float, dRectWidth : Float, dTileBuffer : Float, dTileWidth : Float) : LeftStyle {
        return cast (x - dTileBuffer) / dTileWidth * 100.0 + "%";
    }

    public override function top(y : Float, dRectHeight : Float, dTileBuffer : Float, dTileHeight : Float) : TopStyle {
        return cast (y - dTileBuffer) / dTileHeight * 100.0 + "%";
    }

    public override function moveTo(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileBuffer : Float, dTileWidth : Float, dTileHeight : Float, left : LeftStyle, top : TopStyle, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        if (left == null) {
            left = this.left(x, dRectWidth, dTileBuffer, dTileWidth);
        }
        if (top == null) {
            top = this.top(y, dRectHeight, dTileBuffer, dTileHeight);
        }
        now(function () {
            setStyleLeft(e, left);
            setStyleTop(e, top);
            callback(f);
        }, tempMode);

        if (!_alwaysUseCache) {
            setXCache(e, left);
            setYCache(e, top);
        }

        setEX(e, x);
        setEY(e, y);

        return this;
    }

    public override function scroll(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileWidth : Float, dTileHeight : Float, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        if (x != 0 || y != 0) {
            x += getX(e, dRectWidth, dTileWidth, null);
            y += getY(e, dRectHeight, dTileHeight, null);
            var left : LeftStyle = cast ((x / dTileWidth) * 100.0 + "%");
            var top : TopStyle = cast ((x / dTileHeight) * 100.0 + "%");

            now(function () {
                setStyleLeft(e, left);
                setStyleTop(e, top);
                callback(f);
            }, tempMode);

            if (!_alwaysUseCache) {
                setXCache(e, left);
                setYCache(e, top);
            }

            setEX(e, x);
            setEY(e, y);
        }

        return this;
    }

    public override function willChange(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        now(function () {
            // TODO - if (Field.UseWillChange) {
            setWillchange(e, "display, left, top, class");
            callback(f);
        }, tempMode);

        return this;
    }

    private static function convert(s : String, dTileSize : Float) : Float {
        return Math.floor(Std.parseFloat(s.substring(0, s.length - 1)) / 100.0 * dTileSize);
    }

    public override function getX(e : Element, dRectWidth : Float, dTileWidth : Float, scale : Float) : Float {
        var left : LeftStyle;
       
        if (_alwaysUseCache) {
            var x : Null<Float> = getEX(e);
            if (x == null) {
                left = getStyleLeft(e);
                x = convert(cast left, dTileWidth);
            }
            return x;
        } else {
            left = getStyleLeft(e);
            if (left == getXCache(e)) {
                return getEX(e);
            } else if ((cast left) == "") {
                return 0;
            } else {
                return convert(cast left, dTileWidth);
            }
        }
    }

    public override function getY(e : Element, dRectHeight : Float, dTileHeight : Float, scale : Float) : Float {
        var top : TopStyle;
       
        if (_alwaysUseCache) {
            var x : Null<Float> = getEY(e);
            if (x == null) {
                top = getStyleTop(e);
                x = convert(cast top, dTileHeight);
            }
            return x;
        } else {
            top = getStyleTop(e);
            if (top == getYCache(e)) {
                return getEY(e);
            } else if ((cast top )== "") {
                return 0;
            } else {
                return convert(cast top, dTileHeight);
            }
        }
    }

    public override function getFieldX(e : Element, dRectWidth : Float, dTileWidth : Float) : Float {
        return getX(e, dRectWidth, dTileWidth, null);
    }

    public override function getFieldY(e : Element, dRectHeight : Float, dTileHeight : Float) : Float {
        return getY(e, dRectHeight, dTileHeight, null);
    }

    public override function moveSpriteTo(e1 : Element, e2 : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) {
        now(function () {
            setStyleLeft(e1, getStyleLeft(e2));
            setStyleTop(e1, getStyleTop(e2));
            callback(f);
        }, tempMode);
        return this;
    }
}
