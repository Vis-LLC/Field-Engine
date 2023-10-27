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
    A Bridge Abstract for determining how a FieldView should render it's display in Swing.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class RendererSwing extends RendererAWT {
    private function new() {
        super();
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

    public override function setStyleRotate(e : Element, v : Float) : Void {
        // TODO?
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

    public override function createStaticRectGrid(parent : Element, rows : Int, columns : Int) : NativeVector<NativeVector<Element>> {
        // TODO
        return null;
    }

    public override function createElement(?s : Null<String>) : Element {
        if (s == null) {
            return cast new JTextField();
        } else {
            // TODO
            return null;
        }
    }

    public override function defaultParent() : Element {
        // TODO - Soon
        return null;
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

    public override function moveSpriteTo(e1 : Element, e2 : Element, f : Null<Void -> Void>, tempMode : Null<RendererMode>) {
        // TODO
        return this;
    }    
}

@:native('javax.swing.JTextField') extern class JTextField extends java.awt.TextComponent {
    function new();
}
#end