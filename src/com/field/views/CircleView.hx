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

class CircleView extends AbstractView {
    private var _display : DisplayInterface;
    private var _topTriangle : Element;
    private var _size : String;
    private var _triangleSize : String;
    private var _foregroundColor : String;
    private var _backgroundColor : String;
    private var _id : String;
    private var _fieldSheet : Element = null;
    private var _forceSize : Bool = false;
    private var _reverse : Bool;

    public static var CIRCLE_VIEW_STYLE : Style = cast "circle_view";
    public static var FULLSCREEN : Style = cast "circle_view_fullscreen";
    private static var _circleViewCount : Int = 0;

    public static function create(options : CircleViewOptions) : CircleView {
        return new CircleView(options);
    }

    /**
        Returns the possible options for creating a MirrorView.
    **/
    public static function options() : CircleViewOptions {
        return new CircleViewOptions();
    }

    private function loadFieldSheet() : Element {
        #if js
            return createElement("style");
        #end
        return null;
    }

    private function new(options : CircleViewOptions) {
        super();
        var po : NativeStringMap<Any> = options.toMap();
        _display = cast po.get("display");
        _id = cast po.get("id");

        var parentElement : Element;
        var show : Null<Bool> = cast po.get("show");
        parentElement = po.get("parent");

        _element = getElement();

        if (parentElement != null) {
            appendChild(parentElement, _element);
        }

        _circleViewCount++;
        if (_id == null) {
            _id = "CircleView" + _circleViewCount;
        }
    
        if (po.get("size") != null) {
            _size = po.get("size");
            _forceSize = true;
        }

        if (po.get("reverse") != null) {
            _reverse = po.get("reverse");
        } else {
            _reverse = false;
        }

        // TODO - Move
        #if js
            js.Syntax.code("{0}.id = {1}", _element, _id);
        #else
        #end

        addStyle(_element, CIRCLE_VIEW_STYLE);

        _fieldSheet = loadFieldSheet();
        appendChild(_element, _fieldSheet);

        if (show) {
            showElement(_element);
            updateStyles();
        }
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
                setText(_fieldSheet, "#" + _id + "." + CircleView.CIRCLE_VIEW_STYLE + "{ width: " + _size + "; height: " + _size + "; " + (_reverse ? "transform: scale(-1, 1); " : "") + "}");
            } catch (ex : Any) {

            }
            #end
        });
    }    


}
#end

/*


<html>
<head>
    <style>
        :root {
            --diameter: 1.0in;
        }

        .display {
            border-radius: 50%;
            width: var(--diameter);
            height: var(--diameter);
            overflow: hidden;
        }
    </style>
</head>
<body>
    <div class="display">
        <img src="test.png" />
    </div>
</body>
</html>
*/