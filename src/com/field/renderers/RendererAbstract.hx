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

import com.field.NativeVector;

@:expose
@:nativeGen
/**
    A Bridge Abstract for determining how a FieldView should render it's display.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class RendererAbstract implements RendererInterface {
    private static var _defaultMode : RendererMode = BatchUpdate._instance;
    private static var _mode : RendererMode = _defaultMode;
    private static var _renderer : RendererInterface = null;

    private static var _discardDiv : Null<NativeArray<Any>>;
    private static var _getDiV = null;
    private static var _alwaysUseCache = true;
    private static var _useAllTransform = false;

    public static function currentRenderer() : RendererInterface {
        return _renderer;
    }

    public static function setRenderer(renderer : RendererInterface) : Void {
        _renderer = renderer;
    }

    public static function currentMode() : RendererMode {
        return _mode;
    }

    private inline function now(f : Void -> Void, ?tempMode : Null<RendererMode> = null) : Void {
        if (tempMode == null) {
            tempMode = currentMode();
        }

        tempMode.now(f);
    }

    private inline function callback(f : Void -> Void) : Void {
        if (f != null) {
            f();
        }
    }

    public function hide(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        return null;
    }

    public function show(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        return null;
    }
   
    public function left(x : Float, dRectWidth : Float, dTileBuffer : Float, dTileWidth : Float) : LeftStyle {
        return null;
    }

    public function top(y : Float, dRectHeight : Float, dTileBuffer : Float, dTileHeight : Float) : TopStyle {
        return null;
    }
 
    public function moveTo(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileBuffer : Float, dTileWidth : Float, dTileHeight : Float, left : LeftStyle, top : TopStyle, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        return null;
    }

    public function scroll(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileWidth : Float, dTileHeight : Float, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        return null;
    }

    public function willChange(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        return null;
    }

    public function getX(e : Element, dRectWidth : Float, dTileWidth : Float, scale : Float) : Float {
        return null;
    }

    public function getY(e : Element, dRectHeight : Float, dTileHeight : Float, scale : Float) : Float {
        return null;
    }

    public function getFieldX(e : Element, dRectWidth : Float, dTileWidth : Float) : Float {
        return null;
    }

    public function getFieldY(e : Element, dRectHeight : Float, dTileHeight : Float) : Float {
        return null;
    }

    public function moveSpriteTo(e1 : Element, e2 : Element, f : Null<Void -> Void>, temp : Null<RendererMode>) : RendererInterface {
        return null;
    }

    public function appendChild(parent : Element, child : Element) : Void { }

    public function setOnClick(e : Element, r : MouseEventReceiver) : Void { }
    public function setOnDblClick(e : Element, r : MouseEventReceiver) : Void { }
    public function setOnTouchStart(e : Element, r : TouchEventReceiver) : Void { }
    public function setOnTouchCancel(e : Element, r : TouchEventReceiver) : Void { }
    public function setOnTouchMove(e : Element, r : TouchEventReceiver) : Void { }
    public function setOnTouchEnd(e : Element, r : TouchEventReceiver) : Void { }
    public function setOnMouseDown(e: Element, r : MouseEventReceiver) : Void { }
    public function setOnMouseOver(e: Element, r : MouseEventReceiver) : Void { }
    public function setOnMouseUp(e: Element, r : MouseEventReceiver) : Void { }
    public function setOnKeyDown(e : Element, r : KeyEventReceiver) : Void { }
    public function setOnGamepadConnected(e : Element, r : GamepadEventReceiver) : Void { }
    public function setOnGamepadDisconnected(e : Element, r : GamepadEventReceiver) : Void { }


    public function getStyleString(s : Style) : String {
        return null;
    }

    public function combineStyles(s1 : Style, s2 : Style) : Style {
        return null;
    }

    public function setStyle(e : Element, s : Style) : Void { }

    public function getStylePart(s : Style, sPart : String) : Style {
        return null;
    }

    public function getStyle(e : Element) : Style {
        return null;
    }

    public function setTabIndex(e : Element, index : Int) : Void { }

    public function getStyleFor(s : String) : Style {
        return null;
    }

    public function getParent(e : Element) : Element {
        return null;
    }

    public function getOffsetHeight(e : Element) : Int {
        return -1;
    }

    public function getOffsetWidth(e : Element) : Int {
        return -1;
    }

    public function getChildrenCount(e : Element) : Int {
        return -1;
    }

    public function getChildAt(e : Element, i : Int) : Element {
        return null;
    }

    public function forEachChild(e : Element, f : Int->Element->Void) : Void {
        var children : NativeVector<Element> = getChildrenAsVector(e);
        var i : Int = 0;
        while (i < children.length()) {
            f(i, children.get(i));
            i++;
        }
    }

    public function getChildrenAsVector(e : Element) : NativeVector<Element> {
        var children : NativeVector<Element> = new NativeVector<Element>(getChildrenCount(e));
        var i : Int = 0;
        while (i < children.length()) {
            children.set(i, getChildAt(e, i));
            i++;
        }
        return children;
    }

    public function setStyleRotate(e : Element, v : Float) : Void { }

    public function getActiveElement() : Element {
        return null;
    }

    public function hasStyle(style : Style, part : Style) : Bool {
        return getStyleString(style).indexOf(getStyleString(part)) >= 0;
    }

    public function containsElement(e1 : Element, e2 : Element) : Bool {
        return false;
    }

    public function focusOnElement(e : Element) : Void { }

    public function getElementsWithStyle(e : Element, s : Style) : NativeVector<Element> {
        return null;
    }

    public function forceWidth(e : Element, s : String) : Void { }

    public function forceHeight(e : Element, s : String) : Void { }

    public function getActualPixelWidth(e : Element) : Int {
        return -1;
    }

    public function getActualPixelHeight(e : Element) : Int{
        return -1;
    }

    public function setElementX(e : Element, i : Int) : Void { }

    public function setElementY(e : Element, i : Int) : Void { }

    public function removeStyle(e : Element, s : Style) : Void { }
    public function addStyle(e : Element, s : Style) : Void { }
    public function clearStyleInfo(e : Element) : Void { }
    public function click(e : Element) : Void { }
    public function drawLine(parent : Element, x1 : Int, y1 : Int, x2 : Int, y2 : Int) : Element {
        return null;
    }
    public function clearLines(parent : Element) : Void { }
    public function setCaption(e : Element, caption : String) : Void { }
}
