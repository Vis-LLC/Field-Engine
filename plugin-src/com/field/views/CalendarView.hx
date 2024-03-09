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

#if !EXCLUDE_RENDERING
@:expose
@:nativeGen
class CalendarView extends AbstractView {
    private var _monthView : MonthView;
    private var _dayView : DayView;
    // TODO - private var _weekView : WeekView;
    private var _eventView : EventView;

    public function new(options : CalendarViewOptions, options2 : FieldViewOptions) {
        super();
        var fo : NativeStringMap<Any> = options.toMap();
        var fo2 : NativeStringMap<Any> = options2.toMap();
        if (fo.get("eventView") == true) {
            var options3 = EventView.options();
            _eventView = options3.execute();
        }
        if (fo.get("dayView") == true) {
            var options3 = DayView.options();
            if (_eventView != null) {
                options3.onEventClick(_eventView.eventChange);
            }            
            options3.slotsInADay(fo.get("slots"));
            switch (fo.get("calendarType")) {
                case 0:
                    options3.calendarFunction(cast fo.get("calendar"));
                case 1:
                    options3.calendarData(cast fo.get("calendar"));
            }
            _dayView = options3.execute();
        }
        /* TODO
        if (fo.get("weekView") == true) {
            _weekView = WeekView.create(options, options2);
        }
        */  
        if (fo.get("monthView") == true) {
            var options3 = MonthView.options();
            if (_eventView != null) {
                options3.onEventClick(_eventView.eventChange);
            }            
            if (_dayView != null) {
                options3.onDayClick(_dayView.dayChange);
            }
            options3.slotsInADay(fo.get("slots"));
            switch (fo.get("calendarType")) {
                case 0:
                    options3.calendarFunction(cast fo.get("calendar"));
                case 1:
                    options3.calendarData(cast fo.get("calendar"));
            }
            options3.showCurrentDay(fo.get("showCurrentDay"));
            options3.showControls(fo.get("showControls"));
            options3.showCurrentMonth(fo.get("showCurrentMonth"));
            options3.showCurrentYear(fo.get("showCurrentYear"));
            options3.showWeekDays(fo.get("showWeekDays"));
            _monthView = options3.execute();
        }
    }

    /**
        Create a FieldView based on the specified options.
    **/
    public static function create(options : CalendarViewOptions, options2 : FieldViewOptions) : CalendarView {
        return new CalendarView(options, options2);
    }    

    /**
        Returns the possible options for creating a FieldView.
    **/
    public static function options() : CalendarViewOptions {
        return new CalendarViewOptions();
    }

    public static function register() : Void {
        com.field.replacement.Global.instance().register("field-calendar", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
            var options = com.field.views.CalendarView.options();
            if (e.getAttribute("slots") != null) {
                options.slotsInADay(e.getAttribute("slots"));
            }
            if (e.getAttribute("calendardata") != null) {
                options.calendarData(e.getAttribute("calendardata"));
            }
            if (e.getAttribute("calendarfunction") != null) {
                options.calendarFunction(e.getAttribute("calendarfunction"));
            } 
            if (e.getAttribute("showCurrentDay") != null) {
                options.showCurrentDay(e.getAttribute("showCurrentDay") == "true");
            }
            if (e.getAttribute("showControls") != null) {
                options.showControls(e.getAttribute("showControls") == "true");
            }
            if (e.getAttribute("showCurrentMonth") != null) {
                options.showCurrentMonth(e.getAttribute("showCurrentMonth") == "true");
            }
            if (e.getAttribute("showCurrentYear") != null) {
                options.showCurrentYear(e.getAttribute("showCurrentYear") == "true");
            }
            if (e.getAttribute("showWeekDays") != null) {
                options.showWeekDays(e.getAttribute("showWeekDays") == "true");
            }
            /*
            if (e.getAttribute("showSurroundingMonths") != null) {
                options.showSurroundingMonths(e.getAttribute("showSurroundingMonths") == "true");
            }
            if (e.getAttribute("gridLinesBetweenDays") != null) {
                options.gridLinesBetweenDays(e.getAttribute("gridLinesBetweenDays") == "true");
            }
            if (e.getAttribute("onDayClick") != null) {
                options.onDayClick(e.getAttribute("onDayClick"));
            }
            if (e.getAttribute("onEventClick") != null) {
                options.onEventClick(e.getAttribute("onEventClick"));
            }
            if (e.getAttribute("onMonthChange") != null) {
                options.onMonthChange(e.getAttribute("onMonthChange"));
            }*/

            if (e.id != null && e.id != "") {
                options.id(e.id);
            }
            options
                .parent(e.parentElement)
                .show(true);
            var view = options.execute();
            e.replaceWith(view.toElement());
        });        
    }    
}
#end

