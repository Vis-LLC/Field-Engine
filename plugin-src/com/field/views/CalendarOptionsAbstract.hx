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

import haxe.display.Protocol.Timer;
#if !EXCLUDE_RENDERING
import com.field.navigator.DirectionInterface;
import com.field.renderers.Style;
import com.sdtk.calendar.CalendarInvite;

@:expose
@:nativeGen
/**
    Specifies options for creating MonthViews.
**/
class CalendarOptionsAbstract<T> extends OptionsAbstract<T> {
    private var _fieldOptions : FieldViewOptions = new FieldViewOptions();

    private inline function new() {
        super();
    }
    
    public function slotsInADay(slots : Int) : T {
        return cast setOnce("slots", slots);
    }

    public function calendarFunction(calendar : Date->Iterable<CalendarInvite>) : T {
        setOnce("calendarType", 0);
        return cast setOnce("calendar", calendar);
    }

    public function calendarData(calendar : Iterable<CalendarInvite>) : T {
        setOnce("calendarType", 1);
        return cast setOnce("calendar", calendar);
    }

    public function showCurrentDay(show : Bool) : T {
        return cast setOnce("showCurrentDay", show);
    }

    public function showControls(show : Bool) : T {
        return cast setOnce("showControls", show);
    }

    public function showCurrentMonth(show : Bool) : T {
        return cast setOnce("showCurrentMonth", show);
    }

    public function showCurrentYear(show : Bool) : T {
        return cast setOnce("showCurrentYear", show);
    }

    public function showWeekDays(show : Bool) : T {
        return cast setOnce("showWeekDays", show);
    }

    /**
        The parent element for the view.
    **/
    public function parent(parent : Any) : T {
        _fieldOptions.parent(parent);
        return cast this;
    }

    /**
        Show the FieldView on creation or not.  Default is false.
    **/    
    public function show(show : Bool) : T {
        _fieldOptions.show(show);
        return cast this;
    }

    /**
        Id assigned to the FieldView.
    **/
    public function id(id : String) : T {
        _fieldOptions.id(id);
        return cast this;
    }
}
#end