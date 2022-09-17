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

#if !EXCLUDE_RENDERING
@:expose
@:nativeGen
/**
    A Bridge Interface for determining how a FieldView should render it's display.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
interface RendererInterface {
    function hide(e : Element, f : Null<Void -> Void>, temp : Null<RendererMode>) : RendererInterface;
    function show(e : Element, f : Null<Void -> Void>, temp : Null<RendererMode>) : RendererInterface;
    function left(x : Float, dRectWidth : Float, dTileBuffer : Float, dTileWidth : Float) : LeftStyle;
    function top(y : Float, dRectHeight : Float, dTileBuffer : Float, dTileHeight : Float) : TopStyle;
    function moveTo(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileBuffer : Float, dTileWidth : Float, dTileHeight : Float, left : LeftStyle, top : TopStyle, f : Null<Void -> Void>, temp : Null<RendererMode>) : RendererInterface;
    function scroll(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileWidth : Float, dTileHeight : Float, f : Null<Void -> Void>, temp : Null<RendererMode>) : RendererInterface;
    function willChange(e : Element, f : Null<Void -> Void>, temp : Null<RendererMode>) : RendererInterface;
    function getX(e : Element, dRectWidth : Float, dTileWidth : Float, scale : Float) : Float;
    function getY(e : Element, dRectHeight : Float, dTileHeight : Float, scale : Float) : Float;
    function getFieldX(e : Element, dRectWidth : Float, dTileWidth : Float) : Float;
    function getFieldY(e : Element, dRectHeight : Float, dTileHeight : Float) : Float;
    function moveSpriteTo(e1 : Element, e2 : Element, f : Null<Void -> Void>, temp : Null<RendererMode>) : RendererInterface;
    function appendChild(parent : Element, child : Element) : Void;
    function setOnWheel(e : Element, r : MouseEventReceiver) : Void;
    function setOnClick(e : Element, r : MouseEventReceiver) : Void;
    function setOnDblClick(e : Element, r : MouseEventReceiver) : Void;
    function setOnMouseDown(e: Element, r : MouseEventReceiver) : Void;
    function setOnMouseOver(e: Element, r : MouseEventReceiver) : Void;
    function setOnMouseUp(e: Element, r : MouseEventReceiver) : Void;
    function setOnTouchStart(e : Element, r : TouchEventReceiver) : Void;
    function setOnTouchCancel(e : Element, r : TouchEventReceiver) : Void;
    function setOnTouchMove(e : Element, r : TouchEventReceiver) : Void;
    function setOnTouchEnd(e : Element, r : TouchEventReceiver) : Void;
    function setOnKeyDown(e : Element, r : KeyEventReceiver) : Void;
    function setOnGamepadConnected(e : Element, r : GamepadEventReceiver) : Void;
    function setOnGamepadDisconnected(e : Element, r : GamepadEventReceiver) : Void;
    function getStyleString(s : Style) : String;
    function combineStyles(s1 : Style, s2 : Style) : Style;
    function setStyle(e : Element, s : Style) : Void;
    function getStylePart(s : Style, sPart : String) : Style;
    function getStyle(e : Element) : Style;
    function setTabIndex(e : Element, index : Int) : Void;
    function getStyleFor(s : String) : Style;
    function getParent(e : Element) : Element;
    function getOffsetHeight(e : Element) : Int;
    function getOffsetWidth(e : Element) : Int;
    function getChildrenCount(e : Element) : Int;
    function getChildAt(e : Element, i : Int) : Element;
    function forEachChild(e : Element, f : Int->Element->Void) : Void;
    function getChildrenAsVector(e : Element) : NativeVector<Element>;
    function setStyleRotate(e : Element, v : Float) : Void;
    function getActiveElement() : Element;
    function hasStyle(style : Style, part : Style) : Bool;
    function containsElement(e1 : Element, e2 : Element) : Bool;
    function focusOnElement(e : Element) : Void;
    function getElementsWithStyle(e : Element, s : Style) : NativeVector<Element>;
    function forceWidth(e : Element, s : String) : Void;
    function forceHeight(e : Element, s : String) : Void;
    function getActualPixelWidth(e : Element) : Int;
    function getActualPixelHeight(e : Element) : Int;
    function setElementX(e : Element, i : Int) : Void;
    function setElementY(e : Element, i : Int) : Void;
    function removeStyle(e : Element, s : Style) : Void;
    function addStyle(e : Element, s : Style) : Void;
    function clearStyleInfo(e : Element) : Void;
    function click(e : Element) : Void;
    function drawLine(parent : Element, x1 : Int, y1 : Int, x2 : Int, y2 : Int) : Element;
    function setCaption(e : Element, caption : String) : Void;
    function setColor(e : Element, color : String) : Void;
    function clearLines(parent : Element) : Void;
    function createFragment(parent : Element) : Element;
    function mergeFragment(parent : Element, fragment : Element) : Void;
    function createStaticRectGrid(parent : Element, rows : Int, columns : Int) : NativeVector<NativeVector<Element>>;
    function setText(e : Element, s : String) : Void;
    function createElement(?s : Null<String>) : Element;
    function setStyleLeft(e : Element, v : LeftStyle) : Void;
    function setStyleTop(e : Element, v : TopStyle) : Void;
    function setStyleBottom(e : Element, v : TopStyle) : Void;
}
#end