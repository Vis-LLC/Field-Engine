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
class CalendarViewOptions extends CalendarOptionsAbstract<CalendarViewOptions> {
    public inline function new() {
        super();
    }

    public function monthView(monthView : Bool) : CalendarViewOptions {
        return cast setOnce("monthView", monthView);
    }

    public function dayView(dayView : Bool) : CalendarViewOptions {
        return cast setOnce("dayView", dayView);
    }    

    public function weekView(weekView : Bool) : CalendarViewOptions {
        return cast setOnce("weekView", weekView);
    }

    public function eventView(eventView : Bool) : CalendarViewOptions {
        return cast setOnce("eventView", eventView);
    }

    /**
        Create a CalendarView using the specified options.
    **/
    public function execute() : CalendarView {
        return CalendarView.create(this, _fieldOptions);
    }    
}
#end