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
class CircleViewOptions extends OptionsAbstract<CircleViewOptions> {
    public inline function new() { super(); }

    public function execute() : CircleView {
        return CircleView.create(this);
    }

    public function display(f : DisplayInterface) : CircleViewOptions {
        return set("display", f);
    }

    public function DreamMeOrbit() : CircleViewOptions {
        set("reverse", true);
        return set("size", "2.0in");
    }

    /**
        The parent element for the view.
    **/
    public function parent(parent : Any) : CircleViewOptions {
        return set("parent", parent);
    }

    /**
        Show the FieldView on creation or not.  Default is false.
    **/    
    public function show(show : Bool) : CircleViewOptions {
        return set("show", show);
    }

    /**
        Id assigned to the FieldView.
    **/
    public function id(id : String) : CircleViewOptions {
        return set("id", id);
    }  
}
#end