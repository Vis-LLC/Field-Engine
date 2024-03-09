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
    private var _showCurrentDay : Bool;
    private var _showControls : Bool;
    private var _showCurrentMonth : Bool;
    private var _showCurrentYear : Bool;
    private var _showWeekDays : Bool;
    private var _gridLinesBetweenHours : Bool;
    private var _onDayChange : Date->Date->Void;
    private var _onEventClick : CalendarInvite->Void;
    private var _onHourClick : Date->Void;
    private var _clock24Hr : Bool;
    private static var _clockLabels24 = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "!7", "18", "19", "20", "21", "22", "23"];
    private static var _clockLabels12 = ["12AM", " 1AM", " 2AM", " 3AM", " 4AM", " 5AM", " 6AM", " 7AM", " 8AM", " 9AM", "10AM", "11AM", "12PM", " 1PM", " 2PM", " 3PM", " 4PM", " 5PM", " 6PM", " 7PM", " 8PM", " 9PM", "10PM", "11PM"];

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
        _showCurrentDay = fo.get("showCurrentDay") == true;
        _showControls = fo.get("showControls") == true;
        _showCurrentMonth = fo.get("showCurrentMonth") == true;
        _showCurrentYear = fo.get("showCurrentYear") == true;
        _showWeekDays = fo.get("showWeekDays") == true;
        _gridLinesBetweenHours = fo.get("gridLinesBetweenHours") == true;
        _onHourClick = cast fo.get("onHourClick");
        #if js
            if (cast js.Syntax.code("(typeof {0}) == \"string\"", _onHourClick)) {
                _onHourClick = cast js.Syntax.code("eval({0})", _onHourClick);
            }
        #end
        _onEventClick = cast fo.get("onEventClick");
        #if js
            if (cast js.Syntax.code("(typeof {0}) == \"string\"", _onEventClick)) {
                _onEventClick = cast js.Syntax.code("eval({0})", _onEventClick);
            }
        #end
        _onDayChange = cast fo.get("onDayChange");
        #if js
            if (cast js.Syntax.code("(typeof {0}) == \"string\"", _onDayChange)) {
                _onDayChange = cast js.Syntax.code("eval({0})", _onDayChange);
            }
        #end        
        super(options2.toMap());
        _field.addEventListenerFor(com.field.Events.locationSelect(), dayEvent);
        com.field.Events.locationSelect().addEventListener(function (e : EventInfo<Dynamic, Dynamic, Dynamic>) {
            var field = e.field();
            if (field.equals(_field)) {
                dayEvent(e);
            }
        });        
        startDefaultListeners(
           startDefaultListenersOptions()        
        );
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
            if (e.getAttribute("gridLinesBetweenHours") != null) {
                options.gridLinesBetweenHours(e.getAttribute("gridLinesBetweenHours") == "true");
            }
            if (e.getAttribute("onEventClick") != null) {
                options.onEventClick(e.getAttribute("onEventClick"));
            }
            if (e.getAttribute("onDayChange") != null) {
                options.onDayChange(e.getAttribute("onDayChange"));
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
        var mainHeaderRow : Int = (_showControls || _showCurrentMonth || _showCurrentYear || _showWeekDays || _showCurrentDay ? 0 : -1);
        var headerRows : Int = (mainHeaderRow == -1 ? 0 : 1);

        if (_showCurrentMonth || _showCurrentYear || _showWeekDays || _showCurrentDay) {
            try {
                var l : com.field.LocationExtendedInterface = cast _field.get(0, 0);
                var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
                var s : String = "";
                if (_showCurrentMonth) {
                    #if js
                        s += cast js.Syntax.code("{0}.toLocaleString('default', { month: 'long' })", _date);
                    #else
                        s += add(DateTools.format(_date, "%B");
                    #end
                    if (_showCurrentYear || _showCurrentDay || _showWeekDays) {
                        s += " ";
                    }
                }

                if (_showCurrentDay) {
                    s += _date.getDate();
                    if (_showCurrentYear) {
                        s += ", ";
                    } else if (_showWeekDays) {
                        s += " ";
                    }
                }

                if (_showCurrentYear) {
                    s += _date.getFullYear();
                    if (_showWeekDays) {
                        s += " ";
                    }
                }

                if (_showWeekDays) {
                    #if js
                        s += cast js.Syntax.code("{0}.toLocaleString('default', { weekday: 'long' })", _date);
                    #else
                        s += DateTools.format(_date, "%A");
                    #end
                }

                l.value(s);
                l2.doneWith();
            } catch (ex : Any) { }
        }

        if (_showControls) {
            var l : com.field.LocationExtendedInterface = cast _field.get(1, 0);
            var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
            l.value("<");
            l2.doneWith();

            l = cast _field.get(2, 0);
            l2 = cast l;
            l.value(">");
            l2.doneWith();            
        }


        while (hours <= hourCount) {
            var day : Date = new Date(_date.getFullYear(), _date.getMonth(), _date.getDate(), hours, 0, 0);            
            var l : com.field.LocationExtendedInterface = cast _field.get(hourColumn, hours + headerRows);
            var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
            l.value(_clock24Hr ? _clockLabels24[hours] : _clockLabels12[hours]);
            if (_gridLinesBetweenHours) {
                l2.attribute("grid-line", "right");
            }
            l2.doneWith();
            hourEventCount.set(hours, 1);
            var slots : Int = 0;
            while (slots < _slotsInADay) {
                var l : com.field.LocationExtendedInterface = cast _field.get(hourColumn + 1 + slots, hours + headerRows);
                var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
                l.value("");
                if (_gridLinesBetweenHours) {
                    l2.attribute("grid-line", "top");
                }             
                l2.data("event", "");
                l2.data("date", day);
                l2.doneWith();
                slots++;
            }
            hours++;
        }

        try {
            for (e in _calendar(_date)) {
                var start : Int = e.start.getHours();
                var end : Int = e.end.getHours();
                var hour : Int = start;
                while (hour <= end) {
                    var l : com.field.LocationExtendedInterface = cast _field.get(hourColumn + hourEventCount.get(hour), hour + headerRows);
                    var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
                    l.value(e.summary);
                    l2.data("event", e);
                    l2.doneWith();
                    hourEventCount.set(hour, hourEventCount.get(hour) + 1);
                    hour++;
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

    public function nextDay() : Void {
        dayChange(new Date(_date.getFullYear(), _date.getMonth(), _date.getDate() + 1, 0, 0, 0));
    }

    public function previousDay() : Void {
        dayChange(new Date(_date.getFullYear(), _date.getMonth(), _date.getDate() - 1, 0, 0, 0));
    }

    public override function scrollView(x : Float, y : Float) : Void {
        var mainHeaderRow : Int = (_showControls || _showCurrentMonth || _showCurrentYear || _showWeekDays || _showCurrentDay ? 0 : -1);
        var headerRows : Int = (mainHeaderRow == -1 ? 0 : 1);

        if ((originY() - y) < 0 || x < 0) {
            originY(0);
            originX(0);
            nextDay();
        } else if ((originY() - y) > ((24 + headerRows) - _tileHeight) || x > 0) {
            originY(0);
            originX(0);
            previousDay();
        } else {
            super.scrollView(x, y);
        }
    }

    private function dayEvent(e : com.field.EventInfo<Dynamic, Dynamic, Dynamic>) : Void {
        var mainHeaderRow : Int = (_showControls || _showCurrentMonth || _showCurrentYear || _showWeekDays || _showCurrentDay ? 0 : -1);
        var headerRows : Int = (mainHeaderRow == -1 ? 0 : 1);

        var l : com.field.LocationExtendedInterface = cast e.location();
        var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
        if (mainHeaderRow >= 0 && l2.getY(null) == mainHeaderRow) {
            if (l2.getX(null) == 1) {
                previousDay();
            } else if (l2.getX(null) == 2) {
                nextDay();
            }
        } else if (l2.getY(null) > headerRows) {
            var day : Date = null;
            try {
                day = cast (l2.data("date") != "" ? l2.data("date") : null);
            } catch (ex : Any) { }
            
            var event : CalendarInvite = null;
            try {
                event = cast (l2.data("event") != "" ? l2.data("event") : null);
            } catch (ex : Any) { }            
            if (_onEventClick != null && event != null) {
                _onEventClick(event);
            } else if (_onHourClick != null && day != null) {
                _onHourClick(day);
            }
        }
    }
}
#end