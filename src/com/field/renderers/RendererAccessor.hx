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

@:native
/**
    Provides a convenient point to access the current Renderer.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class RendererAccessor {
    private static var _defaultRenderer : RendererInterface = DomTransformPixel._instance;
    private static var _initialized : Bool = false;

    private function new() {
        if (!_initialized) {
            RendererAbstract.setRenderer(_defaultRenderer);
            _initialized = true;
        }
    }

    private inline function hasChildren(o : Element) : Bool {
        #if js
            return js.Syntax.code("{0}.children.length > 0", o);
        #else
            // TODO
        #end
    }

    private inline function getTextContent(o : Element) : String {
        #if js
            return cast js.Syntax.code("{0}.textContent", o);
        #else
            // TODO
        #end
    }

    private inline function setTextContent(o : Element, v : String) : Void {
        #if js
            js.Syntax.code("{0}.textContent = {1}", o, v);
        #else
            // TODO
        #end
    }

    private inline function removeChildren(o : Element) : Void {
        #if js
            js.Syntax.code("while ({0}.firstChild) {0}.removeChild({0}.lastChild)", o);
        #else
            // TODO
        #end
    }

    private function attributes(e : Element) : NativeArray<String> {
        #if js
            return js.Syntax.code("{0}.className.replace('.', '').split(' ')", e);
        #else
            // TODO
        #end
    }

    private function removeAttribute(e : Element, s : String) : Void{
        now(function () {
            #if js
                js.Syntax.code("{0}.className = {0}.className.replace({1}, '').replace('  ', ' ').trim()", e, s);
            #else
                // TODO
            #end
        });
    }

    private function addAttribute(e : Element, s : String) : Void {
        now(function () {
            #if js
                js.Syntax.code("
                    if ({0}.className.indexOf({1}) < 0) {
                        {0}.className = ({0}.className + ' ' + {1}).trim();
                    }
                ", e, s);
            #else
                // TODO
            #end
        });
    } 

    private inline function setStyleRotate(e : Element, v : Float) : Void {
        renderer().setStyleRotate(e, v);
    }
    
    private inline function renderer() : RendererInterface {
        return RendererAbstract.currentRenderer();
    }

    private inline function mode() : RendererMode {
        return RendererAbstract.currentMode();
    }

    private inline function now(f : Void -> Void) : Void {
        mode().now(f);
    }

    private inline function start() : Void {
        mode().start();
    }

    private inline function end() : Void {
        mode().end();
    }    

    private inline function willChange(e : Element) : Void {
        renderer().willChange(e, null, null);
    }

    private inline function immediate() : RendererMode {
        return com.field.renderers.Immediate._instance;
    }

    private inline function appendChild(parent : Element, child : Element) : Void {
        renderer().appendChild(parent, child);
    }

    private inline function setTabIndex(e : Element, i : Int) : Void {
        renderer().setTabIndex(e, i);
    }

    private inline function setOnClick(e : Element, r : MouseEventReceiver) : Void {
        renderer().setOnClick(e, r);
    }

    private inline function setOnDblClick(e : Element, r : MouseEventReceiver) : Void {
        renderer().setOnDblClick(e, r);
    }    

    private inline function setOnMouseDown(e : Element, r : MouseEventReceiver) : Void {
        renderer().setOnMouseDown(e, r);
    }

    private inline function setOnMouseUp(e : Element, r : MouseEventReceiver) : Void {
        renderer().setOnMouseUp(e, r);
    }    

    private inline function setOnMouseOver(e: Element, r : MouseEventReceiver) : Void {
        renderer().setOnMouseOver(e, r);
    }    

    private inline function setOnTouchStart(e : Element, r : TouchEventReceiver) : Void {
        renderer().setOnTouchStart(e, r);
    }  

    private inline function setOnTouchMove(e : Element, r : TouchEventReceiver) : Void {
        renderer().setOnTouchMove(e, r);
    }  

    private inline function setOnTouchCancel(e : Element, r : TouchEventReceiver) : Void {
        renderer().setOnTouchCancel(e, r);
    }  

    private inline function setOnTouchEnd(e : Element, r : TouchEventReceiver) : Void {
        renderer().setOnTouchEnd(e, r);
    }  

    private inline function setOnKeyDown(e : Element, r : KeyEventReceiver) : Void {
        renderer().setOnKeyDown(e, r);
    }

    private inline function setOnGamepadConnected(e : Element, r : GamepadEventReceiver) : Void {
        renderer().setOnGamepadConnected(e, r);
    }

    private inline function setOnGamepadDisconnected(e : Element, r : GamepadEventReceiver) : Void {
        renderer().setOnGamepadDisconnected(e, r);
    } 

    private inline function getStyleString(s : Style) : String {
        return renderer().getStyleString(s);
    }

    private inline function combineStyles(s1 : Style, s2 : Style) : Style {
        return renderer().combineStyles(s1, s2);
    }

    private inline function getStylePart(s : Style, sPart : String) : Style {
        return renderer().getStylePart(s, sPart);
    }

    private inline function getStyle(e : Element) : Style {
        return renderer().getStyle(e);
    }    

    private inline function hideElement(e : Element, ?f : Null<Void -> Void> = null, ?temp : Null<RendererMode> = null) : Void {
        renderer().hide(e, f, temp);
    }

    private inline function showElement(e : Element, ?f : Null<Void -> Void> = null, ?temp : Null<RendererMode> = null) : Void {
        renderer().show(e, f, temp);
    }

    private inline function createElement(?s : Null<String>) : Element {
        #if js
            return js.Syntax.code("document.createElement({0})", s == null ? "div" : s);
        #else
            // TODO
        #end
    }

    private inline function setType(e : Element, s : String) : Void {
        #if js
            js.Syntax.code("{0}.type = {1}", e, s);
        #else
            // TODO
        #end
    }

    private inline function setStyle(e : Element, s : Style) : Void {
        renderer().setStyle(e, s);
    }

    private inline function getStyleFor(s : String) : Style {
        return renderer().getStyleFor(s);
    }

    private inline function getParent(e : Element) : Element {
        return renderer().getParent(e);
    }

    private inline function getX(e : Element, dRectWidth : Float, dTileWidth : Float, scale : Float) : Float {
        return renderer().getX(e, dRectWidth, dTileWidth, scale);
    }

    private inline function getY(e : Element, dRectHeight : Float, dTileHeight : Float, scale : Float) : Float {
        return renderer().getY(e, dRectHeight, dTileHeight, scale);
    }

    private inline function getFieldX(e : Element, dRectWidth : Float, dTileWidth : Float) : Float {
        return renderer().getFieldX(e, dRectWidth, dTileWidth);
    }

    private inline function getFieldY(e : Element, dRectHeight : Float, dTileHeight : Float) : Float {
        return renderer().getFieldY(e, dRectHeight, dTileHeight);
    }

    private inline function moveSpriteTo(e1 : Element, e2 : Element, ?f : Null<Void -> Void>, ?temp : Null<RendererMode>) : RendererInterface {
        return renderer().moveSpriteTo(e1, e2, f, temp);
    }

    private inline function left(x : Float, dRectWidth : Float, dTileBuffer : Float, dTileWidth : Float) : LeftStyle {
        return renderer().left(x, dRectWidth, dTileBuffer, dTileWidth);
    }
    
    private inline function top(y : Float, dRectHeight : Float, dTileBuffer : Float, dTileHeight : Float) : TopStyle {
        return renderer().top(y, dRectHeight, dTileBuffer, dTileHeight);
    }

    private inline function moveTo(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileBuffer : Float, dTileWidth : Float, dTileHeight : Float, left : LeftStyle, top : TopStyle, f : Null<Void -> Void>, temp : Null<RendererMode>) : RendererInterface {
        return renderer().moveTo(e, x, y, dRectWidth, dRectHeight, dTileBuffer, dTileWidth, dTileHeight, left, top, f, temp);
    }

    private inline function scroll(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileWidth : Float, dTileHeight : Float, f : Null<Void -> Void>, temp : Null<RendererMode>) : RendererInterface {
        return renderer().scroll(e, x, y, dRectWidth, dRectHeight, dTileWidth, dTileHeight, f, temp);
    }

    private inline function getOffsetHeight(e : Element) : Int {
        return renderer().getOffsetHeight(e);
    }

    private inline function getOffsetWidth(e : Element) : Int {
        return renderer().getOffsetWidth(e);
    }

    private inline function getChildrenCount(e : Element) : Int {
        return renderer().getChildrenCount(e);
    }

    private inline function getChildAt(e : Element, i : Int) : Element {
        return renderer().getChildAt(e, i);
    }

    private inline function forEachChild(e : Element, f : Int->Element->Void) : Void {
        renderer().forEachChild(e, f);
    }

    private inline function getChildrenAsVector(e : Element) : NativeVector<Element> {    
        return renderer().getChildrenAsVector(e);
    }

    private inline function getActiveElement() : Element {
        return renderer().getActiveElement();
    }

    private static var _later : NativeArray<Void -> Void> = new NativeArray<Void -> Void>();
    private static var _scheduled : Bool = false;

    private function doLater() : Void {
        var start : Date = Date.now();
        _scheduled = false;
        var batch : NativeArray<Void -> Void> = _later;
        _later = new NativeArray<Void -> Void>();

        for (f in batch) {
            f();
        }

        // console.log("DOM Update of " + batch.length + " events for " + (Date.now() - start) + "ms");

        if (_later.length() > 0) {
            #if js
                setTimeout(doLater, 1);
            #else
                // TODO
            #end
        }
    }

    public function later(f : Void -> Void) : Void {
        _later.push(f);
        if (!_scheduled) {
            #if js
                setTimeout(doLater, 1);
            #else
                // TODO
            #end
            _scheduled = true;
        }
    }

    public function setTimeout(f : Void -> Void, ms : Int) : Void {
        #if js
            js.Syntax.code("setTimeout({0}, {1})", f, ms);
        #else
            // TODO
        #end
    } 

    private inline function hasStyle(style : Style, part : Style) : Bool {
        return renderer().hasStyle(style, part);
    }

    private inline function containsElement(e1 : Element, e2 : Element) : Bool {
        return renderer().containsElement(e1, e2);
    }

    private inline function focusOnElement(e : Element) : Void {
        renderer().focusOnElement(e);
    }

    private inline function getElementsWithStyle(e : Element, s : Style) : NativeVector<Element> {
        return renderer().getElementsWithStyle(e, s);
    }

    private inline function forceWidth(e : Element, s : String) : Void {
        renderer().forceWidth(e, s);
    }

    private inline function forceHeight(e : Element, s : String) : Void {    
        renderer().forceHeight(e, s);
    }

    private inline function getActualPixelWidth(e : Element) : Int {
        return renderer().getActualPixelWidth(e);
    }

    private inline function getActualPixelHeight(e : Element) : Int {    
        return renderer().getActualPixelHeight(e);
    }
    
    private inline function setElementX(e : Element, i : Int) : Void {
        renderer().setElementX(e, i);
    }

    private inline function setElementY(e : Element, i : Int) : Void {
        renderer().setElementY(e, i);
    }

    private inline function removeStyle(e : Element, s : Style) : Void {
        renderer().removeStyle(e, s);
    }

    private inline function addStyle(e : Element, s : Style) : Void {
        renderer().addStyle(e, s);
    }

    private inline function clearStyleInfo(e : Element) : Void {
        renderer().clearStyleInfo(e);
    }

    private inline function click(e : Element) : Void {
        renderer().click(e);
    }

    private function drawLine(parent : Element, x1 : Int, y1 : Int, x2 : Int, y2 : Int) : Element {
        return renderer().drawLine(parent, x1, y1, x2, y2);
    }

    private function clearLines(parent : Element) : Void {
        renderer().clearLines(parent);
    }

    private function setCaption(e : Element, caption : String) : Void {
        renderer().setCaption(e, caption);
    }
}
