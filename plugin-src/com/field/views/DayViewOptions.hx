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
    Specifies options for creating DayViews.
**/
class DayViewOptions  extends CalendarOptionsAbstract<DayViewOptions>{
    public inline function new() {
        super();
    }

    public function gridLinesBetweenHours(show : Bool) : MonthViewOptions {
        return cast setOnce("gridLinesBetweenHours", show);
    }    
    
    public function onHourClick(callback : Date->Void) : MonthViewOptions {
        return cast setOnce("onHourClick", callback);
    }   

    public function onEventClick(callback : CalendarInvite->Void) : DayViewOptions {
        return cast setOnce("onEventClick", callback);
    }

    public function onDayChange(callback : Date->Date->Void) : MonthViewOptions {
        return cast setOnce("onDayChange", callback);
    }    

    /**
        Create a DayView using the specified options.
    **/
    public function execute() : DayView {
        var headerHeight : Int = (cast _values.get("showControls") == true || cast _values.get("showCurrentMonth") == true || cast _values.get("showCurrentYear") == true || cast _values.get("showWeekDays") == true  ? 1 : 0);
        _fieldOptions.tilesAreSquares(false);
        if (_values.get("slots") == null) {
            _values.set("slots", 0);
        }
        _fieldOptions.scrollOnMove(true);
        _fieldOptions.scrollOnWheel(true);
        _fieldOptions.tileWidth(1 + (cast _values.get("slots")));
        if (_fieldOptions._values.get("tileBuffer") == null) {
            _fieldOptions.tileBuffer(0);
        }
        if (_fieldOptions._values.get("style") == null) {
            _fieldOptions.style("day_view");
        }
        if (_fieldOptions._values.get("tileHeight") == null) {
            _fieldOptions.tileHeight(headerHeight + 6);
        }
        if (_fieldOptions._values.get("field") == null) {
            _fieldOptions.field(cast com.field.FieldDynamic.options().width(1 + (cast _values.get("slots"))).height(
                headerHeight + 24
            ).execute());
        }
        return DayView.create(this, _fieldOptions);
    }
}
#end