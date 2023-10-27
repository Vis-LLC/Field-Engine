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

#if(!EXCLUDE_RENDERING && java)
import com.field.NativeArray;

@:expose
@:nativeGen
/**
    A Bridge Abstract for determining how a FieldView should render it's display in AWT.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class RendererAWT extends RendererAbstract {
    private function new() {
        super();
    }

    public override function setOnClick(e : Element, r : MouseEventReceiver) : Void {
        var c : java.awt.Component = cast e;
        c.addMouseListener(new MouseListenerWrapper(r, cast e));
    }

    public override function setOnWheel(e : Element, r : MouseEventReceiver) : Void {
        var c : java.awt.Component = cast e;
        c.addMouseWheelListener(new MouseWheelListenerWrapper(r, cast e));
    }

    public override function setOnDblClick(e : Element, r : MouseEventReceiver) : Void {
        // TODO
    }

    public override function setOnTouchStart(e : Element, r : TouchEventReceiver) : Void {
        // Intentionally left empty
    }

    public override function setOnTouchCancel(e : Element, r : TouchEventReceiver) : Void {
        // Intentionally left empty
    }

    public override function setOnTouchMove(e : Element, r : TouchEventReceiver) : Void {
        // Intentionally left empty
    }

    public override function setOnMouseOver(e: Element, r : MouseEventReceiver) : Void {
        var c : java.awt.Component = cast e;
        c.addMouseListener(new MouseListenerWrapper(r, cast e));
    }

    public override function setOnMouseDown(e: Element, r : MouseEventReceiver) : Void {
        var c : java.awt.Component = cast e;
        c.addMouseListener(new MouseListenerWrapper(r, cast e));
    }

    public override function setOnMouseUp(e: Element, r : MouseEventReceiver) : Void {
        var c : java.awt.Component = cast e;
        c.addMouseListener(new MouseListenerWrapper(r, cast e));
    }

    public override function setOnTouchEnd(e : Element, r : TouchEventReceiver) : Void {
        // Intentionally left empty
    }

    public override function setOnKeyDown(e : Element, r : KeyEventReceiver) : Void {
        var c : java.awt.Component = cast e;
        c.addKeyListener(new KeyListenerWrapper(r, cast e));
    }

    public override function setOnGamepadConnected(e : Element, r : GamepadEventReceiver) : Void {
        // TODO
    }

    public override function setOnGamepadDisconnected(e : Element, r : GamepadEventReceiver) : Void {
        // TODO
    }

    public override function getStyleString(s : Style) : String {
        // TODO
        return "";
    }

    public override function combineStyles(s1 : Style, s2 : Style) : Style {
        // TODO
        return null;
    }

    public override function setStyle(e : Element, s : Style) : Void {
        // TODO
    }

    public override function getStylePart(s : Style, sPart : String) : Style {
        // TODO
        return null;
    }

    public override function getStyle(e : Element) : Style {
        // TODO
        return null;
    }

    public override function setTabIndex(e : Element, index : Int) : Void {
        // TODO
    }

    public override function getStyleFor(s : String) : Style {
        // TODO
        return null;
    }    

    public override function getParent(e : Element) : Element {
        var c : java.awt.Component = cast e;
        return cast c.getParent();
    }

    public override function getOffsetHeight(e : Element) : Int {
        var c : java.awt.Component = cast e;
        return c.getHeight();
    }

    public override function getOffsetWidth(e : Element) : Int {
        var c : java.awt.Component = cast e;
        return c.getWidth();
    }

    public override function getChildrenCount(e : Element) : Int {
        var c : java.awt.Container = cast e;
        return c.getComponentCount();
    }

    public override function getChildAt(e : Element, i : Int) : Element {
        var c : java.awt.Container = cast e;
        return cast c.getComponent(i);
    }

    public override function getChildrenAsVector(e : Element) : NativeVector<Element> {
        var v : NativeVector<Element> = new NativeVector<Element>(getChildrenCount(e));
        var i : Int = 0;
        while (i < v.length()) {
            v.set(i, getChildAt(e, i));
            i++;
        }
        return v;
    }

    public override function setStyleRotate(e : Element, v : Float) : Void {
        // TODO?
    }

    public override function getActiveElement() : Element {
        return cast java.awt.KeyboardFocusManager.getCurrentKeyboardFocusManager().getFocusOwner();
    }

    public override function containsElement(e1 : Element, e2 : Element) : Bool {
        if (Std.isOfType(e1, java.awt.Container)) {
            var c : java.awt.Container = cast e1;
            return c.contains(cast e2);
        } else {
            return false;
        }
    }

    public override function focusOnElement(e : Element) : Void {
        // TODO - Soon
    }

    public override function getElementsWithStyle(e : Element, s : Style) : NativeVector<Element> {
        // TODO
        return null;
    }

    public override function forceWidth(e : Element, s : String) : Void {
        // TODO - Soon
    }

    public override function forceHeight(e : Element, s : String) : Void {
        // TODO - Soon
    }

    public override function getActualPixelWidth(e : Element) : Int {
        return getOffsetWidth(e);
    }

    public override function getActualPixelHeight(e : Element) : Int {
        return getOffsetHeight(e);
    }    

    public override function setElementX(e : Element, i : Int) : Void {
        // TODO - Soon
    }

    public override function setElementY(e : Element, i : Int) : Void {
        // TODO - Soon
    }

    public override function removeStyle(e : Element, s : Style) : Void {
        // TODO
    }

    public override function addStyle(e : Element, s : Style) : Void {
        // TODO
    }

    public override function clearStyleInfo(e : Element) : Void {
        // TODO
    }

    public override function click(e : Element) : Void {
        var c : java.awt.Component = cast e;
        c.dispatchEvent(new java.awt.event.MouseEvent(c, java.awt.event.MouseEvent.MOUSE_CLICKED, 0, 0, 0, 0, 1, false));
    }

    public override function drawLine(parent : Element, x1 : Int, y1 : Int, x2 : Int, y2 : Int) : Element {
        // TODO
        return null;
    }

    public override function clearLines(parent : Element) : Void {
        // TODO
    }

    public override function setCaption(e : Element, caption : String) : Void {
        // TODO
    }

    public override function setColor(e : Element, color : String) : Void {
        // TODO
    }    

    public override function createFragment(parent : Element) : Element {
        return parent;
    }

    public override function mergeFragment(parent : Element, fragment : Element) : Void {
        // Intentionally left empty
    }

    public override function createStaticRectGrid(parent : Element, rows : Int, columns : Int) : NativeVector<NativeVector<Element>> {
        // TODO
        return null;
    }

    public override function getText(e : Element) : String {
        if (Std.isOfType(e, java.awt.TextComponent)) {
            var c : java.awt.TextComponent = cast e;
            return c.getText();
        } else {
            return null;
        }
    }

    public override function setText(e : Element, s : String) : Void {
        if (Std.isOfType(e, java.awt.TextComponent)) {
            var c : java.awt.TextComponent = cast e;
            c.setText(s);
        }
    }

    public override function createElement(?s : Null<String>) : Element {
        if (s == null) {
            return cast new java.awt.TextField();
        } else {
            // TODO
            return null;
        }
    }

    public override function defaultParent() : Element {
        // TODO - Soon
        return null;
    }

    public override function hide(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        var c : java.awt.Component = cast e;
        c.setVisible(false);
        return this;
    }

    public override function show(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        var c : java.awt.Component = cast e;
        c.setVisible(true);
        return this;
    }

    public override function left(x : Float, dRectWidth : Float, dTileBuffer : Float, dTileWidth : Float) : LeftStyle {
        // TODO - Soon
        return null;
    }

    public override function top(y : Float, dRectHeight : Float, dTileBuffer : Float, dTileHeight : Float) : TopStyle {
        // TODO - Soon
        return null;
    }

    public override function moveTo(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileBuffer : Float, dTileWidth : Float, dTileHeight : Float, left : LeftStyle, top : TopStyle, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        // TODO - Soon
        return this;
    }

    public override function scroll(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileWidth : Float, dTileHeight : Float, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        // TODO - Soon
        return this;
    }

    public override function willChange(e : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) : RendererInterface {
        // Intentionally left blank
        return this;
    }

    public override function getX(e : Element, dRectWidth : Float, dTileWidth : Float, scale : Float) : Float {
        var c : java.awt.Component = cast e;
        var location : java.awt.Point = c.getLocation();
        return location.x / dRectWidth;
    }

    public override function getY(e : Element, dRectHeight : Float, dTileHeight : Float, scale : Float) : Float {
        var c : java.awt.Component = cast e;
        var location : java.awt.Point = c.getLocation();
        return location.y / dRectHeight;
    }

    public override function getFieldX(e : Element, dRectWidth : Float, dTileWidth : Float) : Float {
        return -this.getX(e, dRectWidth, dTileWidth, dTileWidth);
    }

    public override function getFieldY(e : Element, dRectHeight : Float, dTileHeight : Float) : Float {
        return -this.getY(e, dRectHeight, dTileHeight, dTileHeight);
    }

    public override function moveSpriteTo(e1 : Element, e2 : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) {
        // TODO
        return this;
    }    

    public override function hasSmoothScroll() : Bool {
        return false;
    }
}

@:nativeGen
class ActionListenerWrapper implements java.awt.event.ActionListener {
    private var _wrapped : MouseEventReceiver;
    private var _element : java.awt.Component;

    public function new(wrap : MouseEventReceiver, element : java.awt.Component) {
        _wrapped = wrap;
        _element = element;
    }

    public function actionPerformed(e : java.awt.event.ActionEvent) : Void {
        _wrapped.onclick(new EventInfoAWT(e, null, null, null, _element));
    }
}

@:nativeGen
class KeyListenerWrapper implements java.awt.event.KeyListener {
    private var _wrapped : KeyEventReceiver;
    private var _element : java.awt.Component;

    public function new(wrap : KeyEventReceiver, element : java.awt.Component) {
        _wrapped = wrap;
        _element = element;
    }

    public function keyPressed(e : java.awt.event.KeyEvent) : Void {
        _wrapped.onkeydown(new EventInfoAWT(null, e, null, null, _element));
    }

    public function keyReleased(e : java.awt.event.KeyEvent) : Void { }

    public function keyTyped(e : java.awt.event.KeyEvent) : Void { }
}

@:nativeGen
class MouseListenerWrapper implements java.awt.event.MouseListener {
    private var _wrapped : MouseEventReceiver;
    private var _element : java.awt.Component;

    public function new(wrap : MouseEventReceiver, element : java.awt.Component) {
        _wrapped = wrap;
        _element = element;
    }

    public function mouseClicked(e : java.awt.event.MouseEvent) : Void {
        _wrapped.onclick(new EventInfoAWT(null, null, e, null, _element));
    }

    public function mouseEntered(e : java.awt.event.MouseEvent) : Void {
        _wrapped.onmouseover(new EventInfoAWT(null, null, e, null, _element));
    }

    public function mouseExited(e : java.awt.event.MouseEvent) : Void {
        _wrapped.onmouseover(new EventInfoAWT(null, null, e, null, _element));
    }

    public function mousePressed(e : java.awt.event.MouseEvent) : Void { }

    public function mouseReleased(e : java.awt.event.MouseEvent) : Void { }    
}

@:nativeGen
class MouseWheelListenerWrapper implements java.awt.event.MouseWheelListener {
    private var _wrapped : MouseEventReceiver;
    private var _element : java.awt.Component;

    public function new(wrap : MouseEventReceiver, element : java.awt.Component) {
        _wrapped = wrap;
        _element = element;
    }

    public function mouseWheelMoved(e : java.awt.event.MouseWheelEvent) : Void {
        _wrapped.onwheel(new EventInfoAWT(null, null, null, e, _element));
    }
}

@:nativeGen
class EventInfoAWT implements EventInfoInterface {
    private var _eventA : java.awt.event.ActionEvent;
    private var _eventK : java.awt.event.KeyEvent;
    private var _eventM : java.awt.event.MouseEvent;
    private var _eventW : java.awt.event.MouseWheelEvent;
    private var _element : java.awt.Component;

    public function new(eventA : java.awt.event.ActionEvent, eventK : java.awt.event.KeyEvent, eventM : java.awt.event.MouseEvent, eventW : java.awt.event.MouseWheelEvent, element : java.awt.Component) {
        _eventA = eventA;
        _eventK = eventK;
        _eventM = eventM;
        _eventW = eventW;
        _element = element;
    }

    public function preventDefault() : Void { }

    public function getX() : Int {
        if (_eventM == null) {
            return 0;
        } else {
            return _eventM.getX();
        }
    }

    public function getY() : Int {
        if (_eventM == null) {
            return 0;
        } else {
            return _eventM.getY();
        }
    }

    public function target() : Null<Element> {
        return cast _element;
    }

    public function keyCode() : Int {
        if (_eventK == null) {
            return 0;
        } else {
            return _eventK.getKeyCode();
        }
    }

    public function key() : String {
        if (_eventK == null) {
            return null;
        } else {
            return "" + _eventK.getKeyChar();
        }
    }

    public function buttons() : Int {
        if (_eventM == null) {
            return 0;
        } else {
            return _eventM.getButton();
        }
    }

    public function wheelDelta() : NativeVector<Float> {
        var v : NativeVector<Float> = new NativeVector<Float>(1);
        v.set(0, _eventW.getWheelRotation());
        return v;
    }
}
#end