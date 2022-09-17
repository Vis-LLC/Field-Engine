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

package com.field.views;

#if !EXCLUDE_RENDERING
import com.field.NativeArray;
import com.field.renderers.Element;
import com.field.renderers.Style;

@:expose
@:native
/**
    Base class for FieldView/LocationView/SpriteView
**/
class AbstractView extends com.field.renderers.RendererAccessor {
    private var _element : Element;
    private static var _discardedElements : NativeArray<Element> = new NativeArray<Element>();
    private static var _skipTouches : Int = 0;
    private static var _skipTouchesStart : Int = 0;

    public function new() {
        super();
    }
    
    private static function getSkipTouches() : Int {
        if (_skipTouches <= 0) {
            return 0;
        } else {
            var current : Int = 0;
            #if js
                js.Syntax.code("{0} = (new Date()).getMilliseconds()", current);
            #end
            if ((current - _skipTouchesStart) < 250) {
                return _skipTouches;
            } else {
                _skipTouches = 0;
                return 0;
            }
        }
    }

    private static function skipTouchesDec() : Void {
        _skipTouches--;
    }

    private static function setSkipTouches(skips : Int) : Void {
        _skipTouches = skips;
        #if js
            js.Syntax.code("{0} = (new Date()).getMilliseconds()", _skipTouchesStart);
        #end
    }

    private function getElement(?style : Null<Style> = null, ?parent : Null<Element> = null) : Element {
        var o : Element = popElement();
        if (style != null) {
            now(function () {
                setStyle(o, style);
            });
            setOriginalStyle(o, style);
        }
        if (parent != null) {
            appendChild(parent, o);
        }
        return o;
    }
    
    /**
        Get element that represents the View.
    **/
    public function toElement() : Element {
        return _element;
    }

    private function popElement() : Element {
        if (_discardedElements.length() > 0) {
            return _discardedElements.pop();
        } else {
            return createElement();
        }
    }
    
    private inline function setOriginalStyle(e : Element, s : Style) : Void {
        #if js
            js.Syntax.code("{0}.originalClassName = {1}", e, s);
        #else
            // TODO
        #end
    }

    public function getOriginalStyle(e : Element) : Style {
        #if js
            return js.Syntax.code("{0}.originalClassName", e);
        #else
            // TODO
        #end
    }    
  
    private inline function locationHasValue(lLocation : LocationInterface<Dynamic, Dynamic>) : Bool {
        #if js
            return cast js.Syntax.code("!!({0}.value)", lLocation);
        #else
            // TODO
        #end
    }

    private inline function getLocationValue(lLocation : LocationInterface<Dynamic, Dynamic>) : Any {
        #if js
            return cast js.Syntax.code("{0}.value()", lLocation);
        #else
            // TODO
        #end
    }

    private inline function locationHasDataSource(lLocation : LocationInterface<Dynamic, Dynamic>) : Bool {
        #if js
            return cast js.Syntax.code("!!({0}.dataSource)", lLocation);
        #else
            // TODO
        #end
    }

    private inline function getLocationDataSource(lLocation : LocationInterface<Dynamic, Dynamic>) : Any {
        #if js
            return cast js.Syntax.code("{0}.dataSource()", lLocation);
        #else
            // TODO
        #end
    }    

    private inline function setDataSource(o : Element, v : Any) : Void {
        #if js
            setTextContent(o, "");
            js.Syntax.code("
                var ifFrame = document.createElement(\"iframe\");
                ifFrame.src = {1};
                {0}.appendChild(ifFrame);
            ", o, v);
        #else
            // TODO
        #end
    }

}
#end