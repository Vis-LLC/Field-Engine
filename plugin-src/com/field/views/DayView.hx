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
import com.sdtk.calendar.CalendarInvite;

@:expose
@:nativeGen
/**
    Displays a Field in an Element.
**/
class DayView extends FieldViewAbstract {
    private var _slotsInADay : Int;
    private var _calendar : Date->Iterable<CalendarInvite>;
    private var _calendarRaw : Iterable<CalendarInvite>;
    private var _date : Date;
    private var _onEventClick : CalendarInvite->Void;

    private static function withDefault(v : Any, d : Any) : Any {
        if (v == null) {
            return d;
        } else {
            return v;
        }
    }

    /**
        Create a FieldView based on the specified options.
    **/
    public static function create(options : DayViewOptions, options2 : FieldViewOptions) : DayView {
        return new DayView(options, options2);
    }

    /**
        Returns the possible options for creating a FieldView.
    **/
    public static function options() : DayViewOptions {
        return new DayViewOptions();
    }

    private function getCalendarFor(date : Date) : Iterable<CalendarInvite> {
        var arr : Array<CalendarInvite> = new Array<CalendarInvite>();
        var s : Date = new Date(date.getFullYear(), date.getMonth(), date.getDay(), 0, 0, 0);
        var e : Date = new Date(date.getFullYear(), date.getMonth(), date.getDay(), 23, 59, 59);
        for (entry in _calendarRaw) {
            if ((entry.start.getTime() >= s.getTime() && entry.start.getTime() <= e.getTime()) || (entry.end.getTime() >= s.getTime() && entry.end.getTime() <= e.getTime())) {
                arr.push(entry);
            }
        }
        return arr;
    }

    private function new(options : DayViewOptions, options2 : FieldViewOptions) {
        var fo : NativeStringMap<Any> = options.toMap();
        _slotsInADay = cast fo.get("slots");
        switch (cast fo.get("calendarType")) {
            case 0:
                _calendar = cast fo.get("calendar");
                _calendarRaw = null;
                #if js
                    if (cast js.Syntax.code("(typeof {0}) == \"string\"", _calendar)) {
                        _calendar = cast js.Syntax.code("eval({0})", _calendar);
                    }
                #end                
            case 1:
                _calendar = getCalendarFor;
                _calendarRaw = cast fo.get("calendar");                
        }
        _onEventClick = cast fo.get("onEventClick");
        #if js
            if (cast js.Syntax.code("(typeof {0}) == \"string\"", _onEventClick)) {
                _onEventClick = cast js.Syntax.code("eval({0})", _onEventClick);
            }
        #end        
        super(options2.toMap());
    }

    public static function register() : Void {
        com.field.replacement.Global.instance().register("field-day", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
            var options = com.field.views.DayView.options();
            if (e.getAttribute("slots") != null) {
                options.slotsInADay(e.getAttribute("slots"));
            }
            if (e.getAttribute("calendardata") != null) {
                options.calendarData(e.getAttribute("calendardata"));
            }
            if (e.getAttribute("calendarfunction") != null) {
                options.calendarFunction(e.getAttribute("calendarfunction"));
            }            
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

    public override function fullRefresh() : Void {
        var init : Bool = false;
        if (_date == null) {
            init = true;
            _date = Date.now();
        }
        var hours : Int = 0;
        var hourCount : Int = 23;
        var hourColumn : Int = 0;
        var hourEventCount : Map<Int, Int> = new Map<Int, Int>();

        while (hours <= hourCount) {
            var l : com.field.LocationExtendedInterface = cast _field.get(hourColumn, hours);
            var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
            l.value(hours);
            l2.doneWith();
            hourEventCount.set(hours, 1);
            hours++;
        }

        try {
            for (e in _calendar(_date)) {
                var start : Int = e.start.getHours();
                var end : Int = e.end.getHours();
                var hour : Int = start;
                while (hour <= end) {
                    var l : com.field.LocationExtendedInterface = cast _field.get(hourColumn + hourEventCount.get(hour), hour);
                    var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
                    l.value(e.summary);
                    l2.doneWith();
                    hour++;
                    hourEventCount.set(hour, hourEventCount.get(hour) + 1);
                }
            }
        } catch (ex : Any) {
            // TODO - Maybe autoretry?
        }

        super.fullRefresh();
    }

    public function dayChange(date : Date) : Void {
        _date = date;
        fullRefresh();
    }
}
#end