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
import com.field.NativeVector;
import com.field.NativeArray;

@:expose
@:nativeGen
/**
    A Bridge Abstract for determining how a FieldView should render it's display to a console (text view).
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class RendererConsoleAbstract extends RendererAbstract {
    private function new() {
        super();
    }

    private var _alwaysUseCache : Bool = true;

    public override function mode() : RendererMode {
        return Immediate._instance;
    }

    public override function appendChild(parent : Element, child : Element) : Void {
        var child2 : NativeVector<Dynamic>  = cast child;
        var parent2 : NativeVector<Dynamic>  = cast parent;
        var children : NativeArray<Element> = cast parent2.get(6);
        if (children == null) {
            children = new NativeArray<Element>();
            parent2.set(6, children);
        }
        children.push(child);
        child2.set(7, parent);
        child2.set(8, parent2.get(8));
    }

    public override function setOnClick(e : Element, r : MouseEventReceiver) : Void {
        // TODO?
    }

    public override function setOnWheel(e : Element, r : MouseEventReceiver) : Void {
        // TODO?
    }

    public override function setOnDblClick(e : Element, r : MouseEventReceiver) : Void {
        // TODO?
    }

    public override function setOnTouchStart(e : Element, r : TouchEventReceiver) : Void {
        // TODO?
    }

    public override function setOnTouchCancel(e : Element, r : TouchEventReceiver) : Void {
        // TODO?
    }

    public override function setOnTouchMove(e : Element, r : TouchEventReceiver) : Void {
        // TODO?
    }

    public override function setOnMouseOver(e: Element, r : MouseEventReceiver) : Void {
        // TODO?
    }

    public override function setOnMouseDown(e: Element, r : MouseEventReceiver) : Void {
        // TODO?
    }

    public override function setOnMouseUp(e: Element, r : MouseEventReceiver) : Void {
        // TODO?
    }

    public override function setOnTouchEnd(e : Element, r : TouchEventReceiver) : Void {
        // TODO?
    }

    public override function setOnKeyDown(e : Element, r : KeyEventReceiver) : Void {
        // TODO?
    }

    public override function setOnGamepadConnected(e : Element, r : GamepadEventReceiver) : Void {
        // TODO?
    }

    public override function setOnGamepadDisconnected(e : Element, r : GamepadEventReceiver) : Void {
       // TODO?
    }

    public override function getStyleString(s : Style) : String {
        if (s == null) {
            return null;
        } else {
            var s2 : NativeArray<Dynamic> = cast s;
            return s2.join(" ");
        }
    }

    public override function combineStyles(s1 : Style, s2 : Style) : Style {
        if (s1 == null || s1 == cast "") {
            return cast s2;
        } else if (s2 == null || s2 == cast "") {
            return cast s1;
        } else {
            var s1b : NativeArray<Dynamic> = cast s1;
            var s2b : NativeArray<Dynamic> = cast s2;
            return cast s1b.concat(s2b);
        }
    }

    public override function setStyle(e : Element, s : Style) : Void {
        var e2 : NativeVector<Dynamic> = cast e;
        e2.set(5, s);
    }

    public override function getStylePart(s : Style, sPart : String) : Style {
        var s2 : NativeArray<Dynamic> = cast s;
        var i : Int = s2.indexOf(sPart);
        if (i < 0) {
            return null;
        } else {
            var sPart2 : NativeArray<Dynamic> = new NativeArray<Dynamic>();
            sPart2.push(s2.get(i));
            return cast sPart2;
        }
    }

    public override function getStyle(e : Element) : Style {
        var e2 : NativeVector<Dynamic> = cast e;
        return cast e2.get(5);
    }

    public override function setTabIndex(e : Element, index : Int) : Void { }

    public override function getStyleFor(s : String) : Style {
        var s2 : NativeArray<Dynamic> = new NativeArray<Dynamic>();
        s2.push(s);
        return cast s2;
    }    

    public override function getParent(e : Element) : Element {
        var e2 : NativeVector<Dynamic> = cast e;
        return cast e2.get(7);
    }

    public override function getOffsetHeight(e : Element) : Int {
        return getActualPixelHeight(e);
    }

    public override function getOffsetWidth(e : Element) : Int {
        return getActualPixelWidth(e);
    }

    public override function getChildrenCount(e : Element) : Int {
        var e2 : NativeVector<Dynamic> = cast e;
        var children : NativeArray<Element> = cast e2.get(6);
        if (children == null) {
            return 0;
        } else {
            return children.length();
        }
    }

    public override function getChildAt(e : Element, i : Int) : Element {
        var e2 : NativeVector<Dynamic> = cast e;
        var children : NativeArray<Element> = cast e2.get(6);
        return cast e2.get(i);
    }

    public override function getChildrenAsVector(e : Element) : NativeVector<Element> {
        var e2 : NativeVector<Dynamic> = cast e;
        var children : NativeArray<Element> = cast e2.get(6);
        return children.toVector();
    }

    public override function setStyleRotate(e : Element, v : Float) : Void { }

    public override function getActiveElement() : Element {
        return null;
    }

    public override function containsElement(e1 : Element, e2 : Element) : Bool {
        var e1b : Array<Dynamic> = cast e1;
        var e2b : Array<Dynamic> = cast e2;
        var x1 : Int = cast e1b[0];
        var y1 : Int = cast e1b[1];
        var x2 : Int = x1 + cast e1b[2];
        var y2 : Int = y1 + cast e1b[3];

        var x : Int = cast e2b[0];
        var y : Int = cast e2b[1];

        return x >= x1 && x < x2 && y >= y1 && y < y2;
    }

    public override function focusOnElement(e : Element) : Void { }

    public override function getElementsWithStyle(e : Element, s : Style) : NativeVector<Element> {
        // TODO?
        return null;
    }

    private function convert(s : String) : Int {
        var i : Int = s.indexOf("px");
        if (i > 0) {
            return Std.parseInt(s.substring(0,i));
        } else {
            return Std.parseInt(s);
        }
    }

    public override function forceWidth(e : Element, s : String) : Void {
        var e2 : NativeVector<Dynamic> = cast e;
        e2.set(2, convert(s));
    }

    public override function forceHeight(e : Element, s : String) : Void {
        var e2 : NativeVector<Dynamic> = cast e;
        e2.set(3, convert(s));
    }

    public override function getActualPixelWidth(e : Element) : Int {
        var e2 : NativeVector<Dynamic> = cast e;
        var i : Int = cast e2.get(2);
        return i == -1 ? 1 : i;
    }

    public override function getActualPixelHeight(e : Element) : Int {
        var e2 : NativeVector<Dynamic> = cast e;
        var i : Int = cast e2.get(3);
        return i == -1 ? 1 : i;
    }    

    public override function setElementX(e : Element, i : Int) : Void {
        var e2 : NativeVector<Dynamic> = cast e;
        e2.set(0, i);
    }

    public override function setElementY(e : Element, i : Int) : Void {
        var e2 : NativeVector<Dynamic> = cast e;
        e2.set(1, i);
    }

    public override function removeStyle(e : Element, s : Style) : Void {
        var e2 : NativeVector<Dynamic> = cast e;
        var e3 : NativeArray<Dynamic> = cast e2.get(5);
        var s2 : NativeArray<Dynamic> = cast s;
        for (s3 in s2) {
            e3.remove(s3);
        }
    }

    public override function addStyle(e : Element, s : Style) : Void {
        var e2 : NativeVector<Dynamic> = cast e;
        var e3 : NativeArray<Dynamic> = cast e2.get(5);
        e2.set(5, e3.concat(cast s));
    }

    public override function clearStyleInfo(e : Element) : Void {
        var e2 : NativeVector<Dynamic> = cast e;
        e2.set(5, new NativeArray<String>());
    }

    public override function click(e : Element) : Void {
        // TODO?
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
        return createElement();
    }

    public override function mergeFragment(parent : Element, fragment : Element) : Void {
        var fragment2 : NativeVector<Dynamic> = cast fragment;
        var children : NativeArray<Element> = cast fragment2.get(6);

        if (children != null) {
            for (child in children) {
                appendChild(parent, child);
            }
        }
    }

    public override function createStaticRectGrid(parent : Element, rows : Int, columns : Int) : NativeVector<NativeVector<Element>> {
        var parent2 : NativeVector<Dynamic> = cast parent;
        var width : Int = cast parent2.get(2);
        var height : Int = cast parent2.get(3);
        var ox : Int = cast parent2.get(0);
        var oy : Int = cast parent2.get(1);
        width = Math.floor(width / columns);
        height = Math.floor(height / rows);
        var elements : NativeVector<NativeVector<Element>> = new NativeVector<NativeVector<Element>>(rows);
        var j : Int = 0;
        while (j < rows) {
            var row : NativeVector<Element> = new NativeVector<Element>(columns);
            elements.set(j, row);
            var i : Int = 0;
            while (i < columns) {
                var e : Element = createElement();
                var e2 : NativeVector<Dynamic> = cast e;
                e2.set(0, ox + width * i);
                e2.set(1, oy + height * j);
                e2.set(2, width);
                e2.set(3, height);
                row.set(i, e);
                i++;
                appendChild(parent, e);
            }
            j++;
        }

        return elements;
    }

    public override function getText(e : Element) : String {
        var e2 : NativeVector<Dynamic> = cast e;
        return cast e2.get(4);
    }

    public override function setText(e : Element, s : String) : Void {
        var e2 : NativeVector<Dynamic> = cast e;
        e2.set(4, s);
        if (e2.get(8) != null) {
            var w : Int = cast e2.get(2);
            while (s.length < w) {
                s += " ";
            }
            var b : ConsoleBuffer = cast e2.get(8);
            var x : Int = cast e2.get(0);
            var y : Int = cast e2.get(1);
            var i : Int = 0;
            while (i < w) {
                b._buffer.get(y).set(x + i, s.charAt(i));
                i++;
            }
        }
    }

    public override function createElement(?s : Null<String>) : Element {
        var e2 : NativeVector<Dynamic> = new NativeVector<Dynamic>(9);
        var s2 : NativeArray<String> = new NativeArray<String>();
        if (s != null) {
            s2.push(s);
        }
        e2.set(0, 0);
        e2.set(1, 0);
        e2.set(2, -1);
        e2.set(3, -1);
        e2.set(4, null);
        e2.set(5, s2);
        e2.set(6, null);
        e2.set(7, null);
        return cast e2;
    }

    private var _defaultParent : Element = null;
    private var _mode : Int = -1;
    private var _buffers : NativeArray<ConsoleBuffer> = new NativeArray<ConsoleBuffer>();

    private function createBuffer(width : Int, height : Int) : ConsoleBuffer {
        var b = new ConsoleBuffer(width, height);
        _buffers.push(b);
        return b;
    }

    #if JS_WSH
        private static var _fso : Dynamic;
        private static var _stdout : Dynamic;
    #end

    private function write(s : String) : Void {
        #if sys
            Sys.stdout().writeString(s);
        #elseif JS_WSH
            if (_fso == null) {
                _fso = js.Syntax.code("new ActiveXObject(\"Scripting.FileSystemObject\")");
                _stdout = js.Syntax.code("{0}.GetStandardStream(1)", _fso);
            }
            js.Syntax.code("{0}.Write(\"{1}\")", _stdout, s);
        #end
    }

    private function displaySlice(s : String) {
        #if JS_BROWSER
            js.html.Console.log(s);
        #elseif JS_WSH
            write(s + "\n");
        #else
            Sys.println(s);
        #end
    }

    private function displayBuffers() : Void {
        var root : NativeVector<Dynamic> = cast defaultParent();
        var y : Int = 0;
        var width : Int = cast root.get(2);
        var height : Int = cast root.get(3);
        var sb : StringBuf = new StringBuf();

        while (y < height) {
            var x : Int = 0;
            while (x < width) {
                var displayed : Bool = false;
                for (buffer in _buffers) {
                    if (y >= buffer._screenY && y < (buffer._screenY + buffer._displayHeight) && x >= buffer._screenX && x < (buffer._screenX + buffer._displayWidth)) {
                        sb.add(buffer.displayBuffer(y - buffer._screenY , false));
                        x += buffer._displayWidth;
                        displayed = true;
                    }
                }
                if (!displayed) {
                    sb.add(" ");
                    x++;
                }
            }
            sb.add("\n");
            y++;
        }
        displaySlice(sb.toString());
    }

    public override function doDisplay() : Void {
        clear();
        displayBuffers();
    }

    public override function initBufferForInner(e : Element) : Void {
        var e2 : NativeVector<Dynamic> = cast e;
        if (e2.get(8) == null) {
            var b : ConsoleBuffer = createBuffer(e2.get(2), e2.get(3));
            var root : Element = defaultParent();
            var root2 : NativeVector<Dynamic> = cast root;
            var parent : Element = e2.get(7);
            var parent2 : NativeVector<Dynamic> = cast parent;
            e2.set(8, b);
            b._displayX = 0;
            b._displayY = 0;
            b._displayWidth = cast parent2.get(2);
            b._displayHeight = cast parent2.get(3);
            b._screenX = cast parent2.get(0);
            b._screenY = cast parent2.get(1);
        }
    }

    private function createDefaultParent() : Element {
        var e2 : NativeVector<Dynamic> = new NativeVector<Dynamic>(9);
        var s2 : NativeArray<String> = new NativeArray<String>();
        e2.set(0, 0);
        e2.set(1, 0);
        switch (_mode) {
            case -1: // 40x24 - TTY
                e2.set(2, 40);
                e2.set(3, 24);
            case 0: // 40x25 - CGA/EGA
                e2.set(2, 40);
                e2.set(3, 25);
            case 1: // 80x25 - MDA
                e2.set(2, 80);
                e2.set(3, 25);
            case 2: // 80x25 - EGA
                e2.set(2, 80);
                e2.set(3, 43);
            case 3: // 80x30 - VGA
                e2.set(2, 80);
                e2.set(3, 30);
            case 4: // 80x50 - VGA2
                e2.set(2, 80);
                e2.set(3, 50);
            case 5: // 80x60 - VESA
                e2.set(2, 80);
                e2.set(3, 60);
            case 6: // 132x25 - VESA2
                e2.set(2, 132);
                e2.set(3, 25);
            case 7: // 132x43 - VESA3
                e2.set(2, 132);
                e2.set(3, 43);
            case 8: // 132x50 - VESA4
                e2.set(2, 132);
                e2.set(3, 50);
            case 9: // 132x60 - VESA5
                e2.set(2, 132);
                e2.set(3, 60);
            case 10: // 160x120 - Very Large
                e2.set(2, 160);
                e2.set(3, 120);
        }
        e2.set(4, null);
        e2.set(5, s2);
        e2.set(6, null); 
        e2.set(7, null);
        return cast e2;      
    }

    public function width() : Int {
        var e : NativeVector<Dynamic> = cast defaultParent();
        return e.get(2);
    }

    public function height() : Int {
        var e : NativeVector<Dynamic> = cast defaultParent();
        return e.get(3);
    }    

    public override function defaultParent() : Element {
        if (_defaultParent == null) {
            _defaultParent = createDefaultParent();
        }
        return _defaultParent;
    }

    public override function fixedSizing() : Bool {
        return true;
    }    

    public function clear() { }

    public function hideCursor() { }

    public function moveCursor(dx:Int, dy:Int) {  }
}

@:expose
@:nativeGen
class ConsoleBuffer {
    public final _buffer : NativeVector<NativeVector<String>>;
    public var _displayWidth : Int;
    public var _displayHeight : Int;
    public var _displayX : Int;
    public var _displayY : Int;
    public var _screenX : Int;
    public var _screenY : Int;

    public function new(width : Int, height : Int) {
        _buffer = new NativeVector<NativeVector<String>>(height);
        var i : Int = 0;
        while (i < _buffer.length()) {
            _buffer.set(i, new NativeVector<String>(width));
            i++;
        }
    }

    public function displayBuffer(y : Int, ?nl : Bool = true) : String {
        var s : StringBuf = new StringBuf();
        var i : Int = 0;
        while (i < _displayWidth) {
            var v : String = _buffer.get(y + _displayY).get(i + _displayX);
            if (v == null || v == "") {
                v = " ";
            }
            s.add(v);
            i++;
        }
        if (nl) {
            s.add("\n");
        }
        return s.toString();
    }
}

#end