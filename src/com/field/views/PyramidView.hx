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

package com.field.views;

import com.field.renderers.Element;
import com.field.renderers.Style;


#if(!EXCLUDE_RENDERING || !js)
@:expose
@:nativeGen

class PyramidView extends AbstractView {
    private var _bottom : DisplayInterface;
    private var _left : DisplayInterface;
    private var _right : DisplayInterface;
    private var _top : DisplayInterface;
    private var _bottomTriangle : Element;
    private var _leftTriangle : Element;
    private var _rightTriangle : Element;
    private var _topTriangle : Element;
    private var _bottomContent : Element;
    private var _leftContent : Element;
    private var _rightContent : Element;
    private var _topContent : Element;    
    private var _size : String;
    private var _triangleSize : String;
    private var _foregroundColor : String;
    private var _backgroundColor : String;
    private var _borderColor : String;
    private var _id : String;
    private var _fieldSheet : Element = null;
    private var _forceSize : Bool = false;

    public static var PYRAMID_VIEW_STYLE : Style = cast "pyramid_view";
    public static var PYRAMID_TRIANGLE_STYLE : Style = cast "triangle";
    public static var PYRAMID_TOP_TRIANGLE_STYLE : Style = cast "top";
    public static var PYRAMID_BOTTOM_TRIANGLE_STYLE : Style = cast "bottom";
    public static var PYRAMID_LEFT_TRIANGLE_STYLE : Style = cast "left";
    public static var PYRAMID_RIGHT_TRIANGLE_STYLE : Style = cast "right";
    public static var PYRAMID_CONTENT_STYLE : Style = cast "content";
    public static var FULLSCREEN : Style = cast "pyramid_view_fullscreen";
    private static var _pyramidViewCount : Int = 0;

    public static function create(options : PyramidViewOptions) : PyramidView {
        return new PyramidView(options);
    }

    /**
        Returns the possible options for creating a MirrorView.
    **/
    public static function options() : PyramidViewOptions {
        return new PyramidViewOptions();
    }

    private function loadFieldSheet() : Element {
        #if js
            return createElement("style");
        #end
        return null;
    }

    private function new(options : PyramidViewOptions) {
        super();
        var po : NativeStringMap<Any> = options.toMap();
        _top = cast po.get("top");
        _bottom = cast po.get("bottom");
        _right = cast po.get("right");
        _left = cast po.get("left");
        _id = cast po.get("id");
        _foregroundColor = cast po.get("foregroundColor");
        _backgroundColor = cast po.get("backgroundColor");
        _borderColor = cast po.get("borderColor");

        if (_foregroundColor == null) {
            _foregroundColor = "white";
        }

        if (_backgroundColor == null) {
            _backgroundColor = "black";
        }
        
        if (_borderColor == null) {
            _borderColor = "black";
        }        

        _element = getElement();
        _topTriangle = createElement("div");
        _bottomTriangle = createElement("div");
        _leftTriangle = createElement("div");
        _rightTriangle = createElement("div");
        _topContent = createElement("div");
        _bottomContent = createElement("div");
        _leftContent = createElement("div");
        _rightContent = createElement("div");
        
        appendChild(_topTriangle, _topContent);
        addStyle(_topContent, PYRAMID_CONTENT_STYLE);
        appendChild(_bottomTriangle, _bottomContent);
        addStyle(_bottomContent, PYRAMID_CONTENT_STYLE);
        appendChild(_leftTriangle, _leftContent);
        addStyle(_leftContent, PYRAMID_CONTENT_STYLE);
        appendChild(_rightTriangle, _rightContent);
        addStyle(_rightContent, PYRAMID_CONTENT_STYLE);
        appendChild(_element, _topTriangle);
        addStyle(_topTriangle, PYRAMID_TRIANGLE_STYLE);
        addStyle(_topTriangle, PYRAMID_TOP_TRIANGLE_STYLE);
        appendChild(_element, _bottomTriangle);
        addStyle(_bottomTriangle, PYRAMID_TRIANGLE_STYLE);
        addStyle(_bottomTriangle, PYRAMID_BOTTOM_TRIANGLE_STYLE);
        appendChild(_element, _leftTriangle);
        addStyle(_leftTriangle, PYRAMID_TRIANGLE_STYLE);
        addStyle(_leftTriangle, PYRAMID_LEFT_TRIANGLE_STYLE);
        appendChild(_element, _rightTriangle);
        addStyle(_rightTriangle, PYRAMID_TRIANGLE_STYLE);
        addStyle(_rightTriangle, PYRAMID_RIGHT_TRIANGLE_STYLE);

        if (po.get("size") != null) {
            _size = po.get("size");
            _triangleSize = po.get("triangleSize");
            _forceSize = true;
        }

        var parentElement : Element;
        var show : Null<Bool> = cast po.get("show");
        parentElement = po.get("parent");

        if (parentElement != null) {
            appendChild(parentElement, _element);
        }

        _pyramidViewCount++;
        if (_id == null) {
            _id = "PyramidView" + _pyramidViewCount;
        }
    
        // TODO - Move
        #if js
            js.Syntax.code("{0}.id = {1}", _element, _id);
        #else
        #end

        addStyle(_element, PYRAMID_VIEW_STYLE);

        _fieldSheet = loadFieldSheet();
        appendChild(_element, _fieldSheet);

        if (show) {
            showElement(_element);
            updateStyles();
        }
    }

    public function getTopContent() : Element {
        return _topContent;
    }

    public function getBottomContent() : Element {
        return _bottomContent;
    }

    public function getLeftContent() : Element {
        return _leftContent;
    }

    public function getRightContent() : Element {
        return _rightContent;
    }

    public function fullScreen() : Void {
        setStyle(toElement(), FULLSCREEN);
    }    

    public function updateStyles() : Void {
        if (!_forceSize) {
            var actualHeight = getActualPixelHeight(this._element);
            var actualWidth = getActualPixelWidth(this._element);
            
            if (actualHeight > actualWidth) {
                _size = actualWidth + "px";
                _triangleSize = (actualWidth / 2) + "px";
            } else {
                _size = actualHeight + "px";
                _triangleSize = (actualHeight / 2) + "px";
            }
        }

        now(function() {
            #if js
            try {
                setText(_fieldSheet, "#" + _id + "." + PyramidView.PYRAMID_VIEW_STYLE + "{  width: " + _size + "; height: " + _size + "; background: " + _borderColor + " ; color: " + _foregroundColor + "; } #" + _id + " ." + PyramidView.PYRAMID_TRIANGLE_STYLE + " {  border-right: " + _triangleSize + " solid transparent; border-bottom: " + _triangleSize + " solid " + _backgroundColor + "; border-left: " + _triangleSize + " solid transparent; border-top: " + _triangleSize + " solid transparent; #" + _id + " ." + PyramidView.PYRAMID_CONTENT_STYLE + " { height: " + _triangleSize + "; }");
            } catch (ex : Any) {

            }
            #end
        });
    }
}
#end
