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

class SplitView extends AbstractView {
    private var _left : DisplayInterface;
    private var _right : DisplayInterface;
    private var _leftSide : Element;
    private var _rightSide : Element;
    private var _width : String;
    private var _height : String;
    private var _id : String;
    private var _fieldSheet : Element = null;
    private var _forceSize : Bool = false;

    public static var SPLIT_VIEW_STYLE : Style = cast "split_view";
    public static var SPLIT_SIDE_STYLE : Style = cast "side";
    public static var SPLIT_LEFT_STYLE : Style = cast "left";
    public static var SPLIT_RIGHT_STYLE : Style = cast "right";
    public static var FULLSCREEN : Style = cast "split_view_fullscreen";
    private static var _splitViewCount : Int = 0;

    public static function create(options : SplitViewOptions) : SplitView {
        return new SplitView(options);
    }

    /**
        Returns the possible options for creating a MirrorView.
    **/
    public static function options() : SplitViewOptions {
        return new SplitViewOptions();
    }

    private function loadFieldSheet() : Element {
        #if js
            return createElement("style");
        #end
        return null;
    }

    private function new(options : SplitViewOptions) {
        super();
        var po : NativeStringMap<Any> = options.toMap();
        _right = cast po.get("right");
        _left = cast po.get("left");
        _id = cast po.get("id");

        _element = getElement();
        _leftSide = createElement("div");
        _rightSide = createElement("div");

        appendChild(_element, _leftSide);
        addStyle(_leftSide, SPLIT_LEFT_STYLE);
        addStyle(_leftSide, SPLIT_SIDE_STYLE);
        appendChild(_element, _rightSide);
        addStyle(_rightSide, SPLIT_RIGHT_STYLE);
        addStyle(_rightSide, SPLIT_SIDE_STYLE);

        if (po.get("width") != null) {
            _width = po.get("width");
            _height = po.get("height");
            _forceSize = true;
        }

        var parentElement : Element;
        var show : Null<Bool> = cast po.get("show");
        parentElement = po.get("parent");

        if (parentElement != null) {
            appendChild(parentElement, _element);
        }

        _splitViewCount++;
        if (_id == null) {
            _id = "SplitView" + _splitViewCount;
        }
    
        // TODO - Move
        #if js
            js.Syntax.code("{0}.id = {1}", _element, _id);
        #else
        #end

        addStyle(_element, SPLIT_VIEW_STYLE);

        _fieldSheet = loadFieldSheet();
        appendChild(_element, _fieldSheet);

        if (show) {
            showElement(_element);
            updateStyles();
        }
    }

    public function getLeftSide() : Element {
        return _leftSide;
    }

    public function getRightSide() : Element {
        return _rightSide;
    }

    public function fullScreen() : Void {
        setStyle(toElement(), FULLSCREEN);
    }

    public function updateStyles() : Void {
        if (!_forceSize) {
            var actualHeight = getActualPixelHeight(this._element);
            var actualWidth = getActualPixelWidth(this._element);
            
            if (actualHeight > actualWidth) {
                _width = (actualHeight / 2) + "px";
                _height = actualWidth + "px";
            } else {
                _width = (actualWidth / 2) + "px";
                _height = actualHeight + "px";
            }
        }

        now(function() {
            #if js
            try {
                setText(_fieldSheet, "#" + _id + "." + SplitView.SPLIT_SIDE_STYLE + "{  width: " + _width + "; height: " + _height + ";  }");
            } catch (ex : Any) {

            }
            #end
        });
    }
}
#end
