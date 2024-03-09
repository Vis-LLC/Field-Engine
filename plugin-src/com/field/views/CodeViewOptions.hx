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
import com.sdtk.calendar.CalendarInvite;

@:expose
@:nativeGen
/**
    Specifies options for creating MonthViews.
**/
class CodeViewOptions extends OptionsAbstract<CodeViewOptions> {
    private var _fieldOptions : FieldViewOptions = new FieldViewOptions();

    public inline function new() {
        super();
    }

    public function code(value : String) : CodeViewOptions {
        return setOnce("code", value);
    }

    public function language(value : String) : CodeViewOptions {
        return setOnce("language", value);
    }

    public function result(value : Dynamic) : CodeViewOptions {
        return setOnce("result", value);
    }

    public function resultFormat(value : String) : CodeViewOptions {
        return setOnce("resultFormat", value);
    }

    public function values(value : Dynamic) : CodeViewOptions {
        return setOnce("values", value);
    }

    /**
        The parent element for the view.
    **/
    public function parent(parent : Any) : CodeViewOptions {
        return setOnce("parent", parent);
    }

    /**
        Show the FieldView on creation or not.  Default is false.
    **/    
    public function show(show : Bool) : CodeViewOptions {
        return setOnce("show", show);
    }

    /**
        Id assigned to the FieldView.
    **/
    public function id(id : String) : CodeViewOptions {
        return setOnce("id", id);
    }

    /**
        Create a CalendarView using the specified options.
    **/
    public function execute() : CodeView {
        return CodeView.create(this, _fieldOptions);
    }

    public function fieldViewOptions() : FieldViewOptions {
        return _fieldOptions;
    }
}
#end