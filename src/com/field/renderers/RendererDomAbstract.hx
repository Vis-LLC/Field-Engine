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

#if(!EXCLUDE_RENDERING && js)
import com.field.NativeArray;

@:expose
@:nativeGen
/**
    A Bridge Abstract for determining how a FieldView should render it's display in the DOM (Document Object Model).
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class RendererDomAbstract extends RendererAbstract {
    private function new() {
        super();
    }

    private var _alwaysUseCache : Bool = true;

    private function parseTransformForX(transform : String, trim : Int, divider : Float, scale : Null<Float>) : Float {
        var search = "translate3d(";
        var i = transform.indexOf(search);
        
        if (i >= 0) {
            i += search.length;
            var j = transform.indexOf(")", i);
            transform = transform.substring(i, j);
            var transformArray : NativeArray<String> = cast js.Syntax.code("{0}.split(',')", transform);
            transform = StringTools.trim(transformArray.get(0));
            if (scale == null) {
                scale = 1.0;
            }					
            return (Std.parseFloat(transform.substring(0, transform.length - trim)) / divider) * scale;
        } else {
            return 0;
        }
    }

    private function parseTransformForY(transform : String, trim : Int, divider : Float, scale : Null<Float>) : Float {
        var search = "translate3d(";
        var i = transform.indexOf(search);
        
        if (i >= 0) {
            i += search.length;
            var j = transform.indexOf(")", i);
            transform = transform.substring(i, j);
            var transformArray : NativeArray<String> = cast js.Syntax.code("{0}.split(',')", transform);
            transform = StringTools.trim(transformArray.get(1));
            if (scale == null) {
                scale = 1.0;
            }
            return (Std.parseFloat(transform.substring(0, transform.length - trim)) / divider) * scale;
        } else {
            return 0;
        }
    }

    private inline function styleOpacity(e : Element, v : Float) : Void {
        #if js
            js.Syntax.code("{0}.style.opacity = {1}", e, v);
        #else
            // TODO
        #end
    }

    private inline function styleDisplay(e : Element, v : String) : Void {
        #if js
            js.Syntax.code("{0}.style.display = {1}", e, v);
        #else
            // TODO
        #end
    }

    private inline function styleTransition(e : Element, v : String) : Void {
        #if js
            js.Syntax.code("{0}.style.transition = {1}", e, v);
        #else
            // TODO
        #end
    }

    private inline function setStyleTransform(e : Element, v : String) : Void {
        #if js
            js.Syntax.code("{0}.style.transform = {1}", e, v);
            /* TODO
    if (Field.UseAllTransform) {
        e.style["-ms-transform"] = s;
        e.style["-moz-transform"] = s;
        e.style["-webkit-transform"] = s;
    }
                */
        #else
            // TODO
        #end
    }

    private inline function getStyleTransform(e : Element) : String {
        #if js
            return cast js.Syntax.code("{0}.style.transform", e);
        #else
            // TODO
        #end
    }    

    public override function setStyleLeft(e : Element, v : LeftStyle) : Void {
        #if js
            js.Syntax.code("{0}.style.left = {1}", e, v);
        #else
            // TODO
        #end
    }

    private inline function getStyleLeft(e : Element) : LeftStyle {
        #if js
            return cast js.Syntax.code("{0}.style.left", e);
        #else
            // TODO
        #end
    }

    public override function setStyleTop(e : Element, v : TopStyle) : Void {
        #if js
            js.Syntax.code("{0}.style.top = {1}", e, v);
        #else
            // TODO
        #end
    }

    public override function setStyleBottom(e : Element, v : TopStyle) : Void {
        #if js
            js.Syntax.code("{0}.style.bottom = {1}", e, v);
        #else
            // TODO
        #end
    }    

    private inline function getStyleTop(e : Element) : TopStyle {
        #if js
            return js.Syntax.code("{0}.style.top", e);
        #else
            // TODO
        #end
    }

    private inline function setXCache(e : Element, v : LeftStyle) : Void {
        #if js
            js.Syntax.code("{0}.xCache = {1}", e, v);
        #else
            // TODO
        #end
    }

    private inline function setYCache(e : Element, v : TopStyle) : Void {
        #if js
            js.Syntax.code("{0}.yCache = {1}", e, v);
        #else
            // TODO
        #end
    }

    private inline function setEX(e : Element, v : Float) : Void {
        #if js
            js.Syntax.code("{0}.x = {1}", e, v);
        #else
            // TODO
        #end
    }

    private inline function setEY(e : Element, v : Float) : Void {
        #if js
            js.Syntax.code("{0}.y = {1}", e, v);
        #else
            // TODO
        #end
    }

    private inline function setWillchange(e : Element, v : String) : Void {
        if (v != null) {
            #if js
                js.Syntax.code("{0}.style.willChange = {1}", e, v);
                js.Syntax.code("{0}.style.bufferedRendering = 'dynamic'", e);
                js.Syntax.code("{0}.style.renderpriority = 'user-visible'", e); // TODO - Check to see if this is working
            #else
                // TODO
            #end
        } else {
            #if js
                js.Syntax.code("{0}.style.willChange = 'unset'", e, v);
                js.Syntax.code("{0}.style.bufferedRendering = 'static'", e);
                js.Syntax.code("{0}.style.renderpriority = 'background'", e); // TODO - Check to see if this is working
            #else
                // TODO
            #end
        }
    }

    public override function appendChild(parent : Element, child : Element) : Void {
        #if js
            js.Syntax.code("{0}.appendChild({1})", parent, child);
        #else
            // TODO
        #end
    }

    private function getEX(e : Element) : Null<Float> {
        #if js
            return cast js.Syntax.code("{0}.x", e);
        #else
            // TODO
        #end
    }

    private function getXCache(e : Element) : LeftStyle {
        #if js
            return cast js.Syntax.code("{0}.xCache", e);
        #else
            // TODO
        #end
    }    

    private function getEY(e : Element) : Null<Float> {
        #if js
            return cast js.Syntax.code("{0}.y", e);
        #else
            // TODO
        #end
    }

    private function getYCache(e : Element) : TopStyle {
        #if js
            return cast js.Syntax.code("{0}.yCache", e);
        #else
            // TODO
        #end
    }    

    public override function setOnClick(e : Element, r : MouseEventReceiver) : Void {
        #if js
            js.Syntax.code("{0}.onclick = {1}", e, EventInfoDOM.wrapFunction(r.onclick, true));
            js.Syntax.code("{0}.oncontextmenu = {1}", e, EventInfoDOM.wrapFunction(r.onclick, false));
        #else
            // TODO
        #end
    }

    public override function setOnWheel(e : Element, r : MouseEventReceiver) : Void {
        #if js
            js.Syntax.code("{0}.onwheel = {1}", e, EventInfoDOM.wrapFunction(r.onwheel, true));
        #else
            // TODO
        #end
    }

    public override function setOnDblClick(e : Element, r : MouseEventReceiver) : Void {
        #if js
            js.Syntax.code("{0}.ondblclick = {1}", e, EventInfoDOM.wrapFunction(r.ondblclick, true));
        #else
            // TODO
        #end
    }

    public override function setOnTouchStart(e : Element, r : TouchEventReceiver) : Void {
        #if js
            js.Syntax.code("{0}.ontouchstart = {1}", e, EventInfoDOM.wrapFunction(r.ontouchstart, true));
        #else
            // TODO
        #end
    }

    public override function setOnTouchCancel(e : Element, r : TouchEventReceiver) : Void {
        #if js
            js.Syntax.code("{0}.ontouchcancel = {1}", e, EventInfoDOM.wrapFunction(r.ontouchcancel, true));
        #else
            // TODO
        #end
    }

    public override function setOnTouchMove(e : Element, r : TouchEventReceiver) : Void {
        #if js
            js.Syntax.code("{0}.ontouchmove = {1}", e, EventInfoDOM.wrapFunction(r.ontouchmove, true));
        #else
            // TODO
        #end
    }

    public override function setOnMouseOver(e: Element, r : MouseEventReceiver) : Void {
        #if js
            js.Syntax.code("{0}.onmouseover = {1}", e, EventInfoDOM.wrapFunction(r.onmouseover, true));
        #else
            // TODO
        #end
    }

    public override function setOnMouseDown(e: Element, r : MouseEventReceiver) : Void {
        #if js
            js.Syntax.code("{0}.onmousedown = {1}", e, EventInfoDOM.wrapFunction(r.onmousedown, true));
        #else
            // TODO
        #end
    }

    public override function setOnMouseUp(e: Element, r : MouseEventReceiver) : Void {
        #if js
            js.Syntax.code("{0}.onmouseup = {1}", e, EventInfoDOM.wrapFunction(r.onmouseup, true));
        #else
            // TODO
        #end
    }

    public override function setOnTouchEnd(e : Element, r : TouchEventReceiver) : Void {
        #if js
            js.Syntax.code("{0}.ontouchend = {1}", e, EventInfoDOM.wrapFunction(r.ontouchend, true));
        #else
            // TODO
        #end
    }

    public override function setOnKeyDown(e : Element, r : KeyEventReceiver) : Void {
        #if js
            js.Syntax.code("{0}.onkeydown = {1}", e, EventInfoDOM.wrapFunction(r.onkeydown, true));
        #else
            // TODO
        #end
    }

    public override function setOnGamepadConnected(e : Element, r : GamepadEventReceiver) : Void {
        #if js
            js.Syntax.code("window.addEventListener(\"gamepadconnected\", {1})", e, EventInfoDOM.wrapFunction(r.ongamepadconnected, true));
        #else
            // TODO
        #end
    }

    public override function setOnGamepadDisconnected(e : Element, r : GamepadEventReceiver) : Void {
        #if js
            js.Syntax.code("window.addEventListener(\"gamepaddisconnected\", {1})", e, EventInfoDOM.wrapFunction(r.ongamepaddisconnected, true));
        #else
            // TODO
        #end
    }

    public override function getStyleString(s : Style) : String {
        return cast s;
    }

    public override function combineStyles(s1 : Style, s2 : Style) : Style {
        if (s2 == null) {
            return s1;
        } else if (s1 == null) {
            return s2;
        } else {
            return cast (s1 + " " + s2);
        }
    }

    public override function setStyle(e : Element, s : Style) : Void {
        #if js
            js.Syntax.code("{0}.className = {1}", e, s);
        #else
            // TODO
        #end
    }

    public override function getStylePart(s : Style, sPart : String) : Style {
        var sFull : String = cast s;
        sPart = " " + sPart;
        var i : Int = sFull.indexOf(sPart);
        if (i > 0) {
            var j : Int = sFull.indexOf(" ", i + 1);
            if (j < 0) {
                return cast sFull.substr(i);
            } else {
                return cast sFull.substr(i, j - i);
            }
        } else {
            return null;
        }
    }

    public override function getStyle(e : Element) : Style {
        #if js
            return js.Syntax.code("{0}.className", e);
        #else
            // TODO
        #end
    }

    public override function setTabIndex(e : Element, index : Int) : Void {
        #if js
            js.Syntax.code("{0}.tabIndex = {1}", e, index);
        #else
            // TODO
        #end
    }

    public override function getStyleFor(s : String) : Style {
        return cast s;
    }    

    public override function getParent(e : Element) : Element {
        #if js
            return js.Syntax.code("{0}.parentElement", e);
        #else
            // TODO
        #end
    }

    public override function getOffsetHeight(e : Element) : Int {
        #if js
            return cast js.Syntax.code("{0}.offsetHeight", e);
        #else
            // TODO
        #end
    }

    public override function getOffsetWidth(e : Element) : Int {
        #if js
            return cast js.Syntax.code("{0}.offsetWidth", e);
        #else
            // TODO
        #end
    }

    public override function getChildrenCount(e : Element) : Int {
        #if js
            return cast js.Syntax.code("{0}.childElementCount", e);
        #else
            // TODO
        #end
    }

    public override function getChildAt(e : Element, i : Int) : Element {
        #if js
            return cast js.Syntax.code("{0}.children[{1}]", e, i);
        #else
            // TODO
        #end
    }

    public override function getChildrenAsVector(e : Element) : NativeVector<Element> {
        #if js
            return cast js.Syntax.code("Array.from({0}.children)", e);
        #else
            // TODO
        #end
    }

    public override function setStyleRotate(e : Element, v : Float) : Void {
        #if js
            js.Syntax.code("
                var ov;
                if (!!({0}.transform)) {
                    ov = {0}.style.transform;
                    ov = parseInt(ov.replace('rotate(', '').replace('deg)', ''));
                }

                var t = 'rotate(' + (ov + {1}) + 'deg';
                {0}.style.transform = t;
            ", e, v);
                //s = dDiv.style.transform;
                //s = parseInt(s.replace("rotate(", "").replace("deg)", ""));

            //var t = "rotate(" + (d + s) + "deg)";
            //dDiv.style["-ms-transform"] = t;
            //dDiv.style["-webkit-transform"] = t;
            //dDiv.style.transform = t;
        #else
            // TODO
        #end
    }

    public override function getActiveElement() : Element {
        #if js
            return cast js.Syntax.code("document.activeElement");
        #else
            // TODO
        #end
    }

    public override function containsElement(e1 : Element, e2 : Element) : Bool {
        #if js
            return cast js.Syntax.code("{0}.contains{1}", e1, e2);
        #else
            // TODO
        #end
    }

    public override function focusOnElement(e : Element) : Void {
        #if js
            js.Syntax.code("document.focus({0})", e);
        #else
            // TODO
        #end
    }

    public override function getElementsWithStyle(e : Element, s : Style) : NativeVector<Element> {
        #if js
            return js.Syntax.code("{0}.getElementsByClassName({1})", e, s);
        #else
            // TODO
        #end
    }

    public override function forceWidth(e : Element, s : String) : Void {
        #if js
            js.Syntax.code("{0}.style.width = {1}; {0}.style.minWidth = {1}; {0}.style.maxWidth = {1}", e, s);
        #else
            // TODO
        #end
    }

    public override function forceHeight(e : Element, s : String) : Void {
        #if js
            js.Syntax.code("{0}.style.height = {1}; {0}.style.minHeight = {1}; {0}.style.maxHeight = {1}", e, s);
        #else
            // TODO
        #end
    }

    public override function getActualPixelWidth(e : Element) : Int {
        #if js
            return cast js.Syntax.code("{0}.clientWidth", e);
        #else
            // TODO
        #end
    }

    public override function getActualPixelHeight(e : Element) : Int {
        #if js
            return cast js.Syntax.code("{0}.clientHeight", e);
        #else
            // TODO
        #end
    }    

    public override function setElementX(e : Element, i : Int) : Void {
        #if js
            js.Syntax.code("{0}.style.left = {1}", e, i);
        #else
            // TODO
        #end
    }

    public override function setElementY(e : Element, i : Int) : Void {
        #if js
            js.Syntax.code("{0}.style.top = {1}", e, i);
        #else
            // TODO
        #end
    }

    public override function removeStyle(e : Element, s : Style) : Void {
        #if js
            js.Syntax.code("{0}.classList.remove({1})", e, s);
        #else
            // TODO
        #end
    }

    public override function addStyle(e : Element, s : Style) : Void {
        #if js
            js.Syntax.code("{0}.classList.add({1})", e, s);
        #else
            // TODO
        #end
    }

    public override function clearStyleInfo(e : Element) : Void {
        #if js
            js.Syntax.code("{0}.style = null", e);
        #else
            // TODO
        #end
    }

    public override function click(e : Element) : Void {
        #if js
            js.Syntax.code("{0}.click()", e);
        #else
            // TODO
        #end        
    }

    public override function drawLine(parent : Element, x1 : Int, y1 : Int, x2 : Int, y2 : Int) : Element {
        #if js
            var e : Element = cast js.Syntax.code("document.createElement('div')");
            appendChild(parent, e);
            setStyle(e, cast "line-segment");
            var angle : Float = -Math.atan2(y2 - y1, x2 - x1) / Math.PI * 180;
            var length : Float = Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
            js.Syntax.code("{0}.style = '--x1: ' + {1} + '; --y1: ' + {2} + '; --x2: ' + {3} + '; --y2: ' + {4} + '; --angle: ' + {5} + '; --length: ' + {6} +';'", e, x1, y1, x2, y2, angle, length);
            return e;
        #else
            // TODO
        #end
    }

    public override function clearLines(parent : Element) : Void {
        #if js
            var children : NativeVector<Element> = getChildrenAsVector(parent);
            for (e in children) {
                if (getStyle(e) == (cast "line-segment")) {
                    js.Syntax.code("{0}.parentNode.removeChild({0})", e);
                }
            }
        #else
            // TODO
        #end
    }

    public override function setCaption(e : Element, caption : String) : Void {
        #if js
            js.Syntax.code("{0}.title = {1}", e, caption);
            js.Syntax.code("{0}.alt = {1}", e, caption);
        #else
            // TODO
        #end
    }

    public override function setColor(e : Element, color : String) : Void {
        #if js
            js.Syntax.code("{0}.style.backgroundColor = {1}", e, color);
            js.Syntax.code("{0}.style.color = {1}", e, color);
        #else
            // TODO
        #end
    }    

    public override function createFragment(parent : Element) : Element {
        #if js
            return cast js.Syntax.code("document.createDocumentFragment()");
        #else
            // TODO
        #end
    }

    public override function mergeFragment(parent : Element, fragment : Element) : Void {
        #if js
            return cast js.Syntax.code("{0}.appendChild({1})", parent, fragment);
        #else
            // TODO
        #end
    }

    public override function createStaticRectGrid(parent : Element, rows : Int, columns : Int) : NativeVector<NativeVector<Element>> {
        #if js
            var table : Element = cast js.Syntax.code("document.createElement('table')");
            js.Syntax.code("{0}.cellPadding = \"0x\"", table);
            js.Syntax.code("{0}.cellSpacing = \"0x\"", table);
            var elements : NativeVector<NativeVector<Element>> = new NativeVector<NativeVector<Element>>(rows);
            var j : Int = 0;
            while (j < rows) {
                var eRow : Element = cast js.Syntax.code("document.createElement('tr')");
                js.Syntax.code("{0}.appendChild({1})", table, eRow);
                var row : NativeVector<Element> = new NativeVector<Element>(columns);
                elements.set(j, row);
                var i : Int = 0;
                while (i < columns) {
                    var e : Element = cast js.Syntax.code("document.createElement('td')");
                    row.set(i, e);
                    js.Syntax.code("{0}.appendChild({1})", eRow, e);
                    i++;
                }
                j++;
            }

            setStyle(table, getStyle(parent));
            js.Syntax.code("{0}.appendChild({1})", getParent(parent), table);
            js.Syntax.code("{0}.removeChild({1})", getParent(parent), parent);
            return elements;
        #else
            // TODO
        #end
    }

    public override function getText(e : Element) : String {
        #if js
            return cast js.Syntax.code("{0}.textContent", e);
        #else
            // TODO
        #end
    }

    public override function setText(e : Element, s : String) : Void {
        #if js
            js.Syntax.code("{0}.textContent = {1}", e, s);
        #else
            // TODO
        #end
    }

    public override function createElement(?s : Null<String>) : Element {
        #if js
            return js.Syntax.code("document.createElement({0})", s == null ? "div" : s);
        #else
            // TODO
        #end
    }

    public override function defaultParent() : Element {
        #if js
            return js.Syntax.code("document.body");
        #else
            // TODO
        #end
    }

    public override function smoothScroll(e : Element, x : Float, y : Float, dRectWidth : Float, dRectHeight : Float, dTileBuffer : Float, dTileWidth : Float, dTileHeight : Float, time : Int, f : Null<Void -> Void>, temp : Null<RendererMode>) : RendererInterface {
        var t : String = "" + time + "ms";
        var transition : String = "width linear " + t + ", height linear " + t + ", left linear " + t + ", top linear " + t + ", transform linear " + t;
        styleTransition(e, transition);
        return moveTo(e, x, y, dRectWidth, dRectHeight, dTileBuffer, dTileWidth, dTileHeight, null, null, f, temp);
    }

    public override function smoothScrollOn(e : Element) : Bool {
        return js.Syntax.code("{0}.style.transition != null && {0}.style.transition != \"\"", e);
    }

    public override function clearSmoothScroll(e : Element) : RendererInterface {
        styleTransition(e, null);
        return this;
    }

    public override function hasSmoothScroll() : Bool {
        return true;
    }
}

/* TODO
function discardDivPlain(e)
	{
		e.parentNode.removeChild(e);
	}

	function getDivPlain()
	{
		return document.createElement("div");
	}

	function discardDivEx(e)
	{
		e.parentNode.removeChild(e);
		dDiscardedDivs.push(e);
		for (var i = 0; i < e.childNodes; i++)
		{
			var e2 = e.childNodes[i];

			if (e2.tagName === "div")
			{
				discardDiv(e2);
			}
			else
			{
				e.removeChild(e2);
			}
		}
		e.style = null;
	}

	function getDivEx()
	{
		if (dDiscardedDivs.length > 0)
		{
			return dDiscardedDivs.pop();
		}
		else
		{
			return document.createElement("div");
		}
	}

	discardDiv = discardDivEx;
	getDiv = getDivEx;

	function d(sClass, dParent)
	{
		var dDiv = getDiv();
		domUpdate.now(function () {
			dDiv.className = sClass;
		});
		if (!!dParent)
		{
			dParent.appendChild(dDiv);
		}
		return dDiv;
	}

*/
#end