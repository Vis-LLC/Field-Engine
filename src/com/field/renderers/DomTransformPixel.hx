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
    A Bridge for determining how a FieldView should render it's display using DOM (Document Object Model) transforms, with the information represented in Pixels.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class DomTransformPixel extends RendererDomAbstract {
    public static var _instance : RendererInterface = new DomTransformPixel();

    private function new() {
        super();
    }

    private inline function display(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>, opacity : Float, transition : String) : RendererInterface {
        now(function () {
            styleOpacity(e, opacity);
            styleTransition(e, transition);
        }, tempMode);

        return this;
    }

    public override function hide(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        return display(e, f, tempMode, 0, "none");
    }

    public override function show(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        return display(e, f, tempMode, 1, "");
    }

    public override function left(x : Float, dRectWidth : Float, dTileBuffer : Float, dTileWidth : Float) : LeftStyle {
        return cast (x * dRectWidth) + "px";
    }

    public override function top(y : Float, dRectHeight : Float, dTileBuffer : Float, dTileHeight : Float) : TopStyle {
        return cast (y * dRectHeight) + "px";
    }

    public override function moveTo(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileBuffer : Float, dTileWidth : Float, dTileHeight : Float, left : LeftStyle, top : TopStyle, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        if (left == null) {
            left = this.left(x, dRectWidth, dTileBuffer, dTileWidth);
        }
        if (top == null) {
            top = this.top(y, dRectHeight, dTileBuffer, dTileHeight);
        }

        var s : String = "translate3d(" + left + "," + top + ",0px)";

        now(function () {
            setStyleTransform(e, s);
            callback(f);
        });

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
            x += this.getFieldX(e, dRectWidth, dTileWidth);
            y += this.getFieldY(e, dRectHeight, dTileHeight);

            var s : String = "translate3d(" + -1.0 * x * dRectWidth + "px" + "," + -1.0 * y * dRectHeight + "px" + ",0px)";

            now(function () {
                setStyleTransform(e, s);
                callback(f);
            }, tempMode);

            if (!_alwaysUseCache) {
                setXCache(e, cast s);
                setYCache(e, cast s);
            }

            setEX(e, x);
            setEY(e, y);
        }

        return this;
    }

    public override function willChange(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        now(function () {
            // TODO - if (Field.UseWillChange) {
            setWillchange(e, "transform, opacity, class");
            callback(f);
        }, tempMode);

        return this;
    }

    public override function getX(e : Element, dRectWidth : Float, dTileWidth : Float, scale : Float) : Float {
        var transform : String;
       
        if (_alwaysUseCache) {
            var x : Null<Float> = getEX(e);
            if (x == null) {
                transform = getStyleTransform(e);
                x = parseTransformForX(transform, 2, dRectWidth, null);
            }
            return x;
        } else {
            transform = getStyleTransform(e);
            if (transform == cast getXCache(e)) {
                var x : Null<Float> = getEX(e);
                if (x == null) {
                    return 0;
                } else {
                    return x;
                }
            } else {
                return parseTransformForX(transform, 2, dRectWidth, null);
            }
        }
    }

    public override function getY(e : Element, dRectHeight : Float, dTileHeight : Float, scale : Float) : Float {
        var transform : String;
       
        if (_alwaysUseCache) {
            var y : Null<Float> = getEY(e);
            if (y == null) {
                transform = getStyleTransform(e);
                y = parseTransformForY(transform, 2, dRectHeight, null);
            }
            return y;
        } else {
            transform = getStyleTransform(e);
            if (transform == cast getYCache(e)) {
                var y : Null<Float> = getEY(e);
                if (y == null) {
                    return 0;
                } else {
                    return y;
                }
            } else {
                return parseTransformForY(transform, 2, dRectHeight, null);
            }
        }
    }

    public override function getFieldX(e : Element, dRectWidth : Float, dTileWidth : Float) : Float {
        return -this.getX(e, dRectWidth, dTileWidth, dTileWidth);
    }

    public override function getFieldY(e : Element, dRectHeight : Float, dTileHeight : Float) : Float {
        return -this.getY(e, dRectHeight, dTileHeight, dTileHeight);
    }

    public override function moveSpriteTo(e1 : Element, e2 : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) {
        now(function () {
            setStyleTransform(e1, getStyleTransform(e2));
            callback(f);
        }, tempMode);
        return this;
    }
}

