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

#if(!EXCLUDE_RENDERING || !js)
@:expose
@:nativeGen
class PyramidViewOptions extends OptionsAbstract<PyramidViewOptions> {
    public inline function new() { super(); }

    public function top(f : DisplayInterface) : PyramidViewOptions {
        return set("top", f);
    }

    public function bottom(f : DisplayInterface) : PyramidViewOptions {
        return set("bottom", f);
    }

    public function left(f : DisplayInterface) : PyramidViewOptions {
        return set("left", f);
    }

    public function right(f : DisplayInterface) : PyramidViewOptions {
        return set("right", f);
    }

    public function execute() : PyramidView {
        return PyramidView.create(this);
    }

    /**
        The parent element for the view.
    **/
    public function parent(parent : Any) : PyramidViewOptions {
        return set("parent", parent);
    }

    /**
        Show the FieldView on creation or not.  Default is false.
    **/    
    public function show(show : Bool) : PyramidViewOptions {
        return set("show", show);
    }
    
    public function borderColor(color : String) : PyramidViewOptions {
        return set("border", color);
    }

    public function backgroundColor(color : String) : PyramidViewOptions {
        return set("background", color);
    }    

    public function foregroundColor(color : String) : PyramidViewOptions {
        return set("foreground", color);
    }

    public function HOLHOPyramid() : PyramidViewOptions {
        set("size", "10in");
        return set("triangleSize", "5in");
    }

    /**
        Id assigned to the FieldView.
    **/
    public function id(id : String) : PyramidViewOptions {
        return set("id", id);
    }
}
#end