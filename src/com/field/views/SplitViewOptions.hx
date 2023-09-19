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
class SplitViewOptions extends OptionsAbstract<SplitViewOptions> {
    public inline function new() { super(); }

    public function left(f : DisplayInterface) : SplitViewOptions {
        return set("left", f);
    }

    public function right(f : DisplayInterface) : SplitViewOptions {
        return set("right", f);
    }

    public function execute() : SplitView {
        return SplitView.create(this);
    }

    /**
        The parent element for the view.
    **/
    public function parent(parent : Any) : SplitViewOptions {
        return set("parent", parent);
    }

    /**
        Show the FieldView on creation or not.  Default is false.
    **/    
    public function show(show : Bool) : SplitViewOptions {
        return set("show", show);
    }

    public function Aryzon() : SplitViewOptions {
        set("height", "2.99in");
        return set("width", "3.275in");
    }

    public function Daydream() : SplitViewOptions {
        set("height", "2.45in");
        return set("width", "2.175in");
    }

    public function LenovoHeadset() : SplitViewOptions {
        set("height", "1in");
        return set("width", "1.5in");
    }

    public function Anaglyph() : SplitViewOptions {
        // TODO
        return set("anaglyph", true);
    }

    /**
        Id assigned to the FieldView.
    **/
    public function id(id : String) : SplitViewOptions {
        return set("id", id);
    }
}
#end