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
class MonthView extends FieldViewAbstract {
    private var _slotsInADay : Int;
    private var _calendar : Date->Iterable<CalendarInvite>;
    private var _calendarRaw : Iterable<CalendarInvite>;
    private var _showCurrentDay : Bool;
    private var _showControls : Bool;
    private var _showCurrentMonth : Bool;
    private var _showCurrentYear : Bool;
    private var _showWeekDays : Bool;
    private var _showSurroundingMonths : Bool;
    private var _gridLinesBetweenDays : Bool;
    private var _date : Date;
    private var _now : Date;
    private var _onMonthChange : Date->Date->Void;
    private var _onDayClick : Date->Void;
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
    public static function create(options : MonthViewOptions, options2 : FieldViewOptions) : MonthView {
        return new MonthView(options, options2);
    }

    /**
        Returns the possible options for creating a FieldView.
    **/
    public static function options() : MonthViewOptions {
        return new MonthViewOptions();
    }

    private function getCalendarFor(date : Date) : Iterable<CalendarInvite> {
        var arr : Array<CalendarInvite> = new Array<CalendarInvite>();
        var s : Date = new Date(date.getFullYear(), date.getMonth(), 1, 0, 0, 0);
        var e : Date = new Date(date.getFullYear(), date.getMonth(), DateTools.getMonthDays(date), 23, 59, 59);
        for (entry in _calendarRaw) {
            if ((entry.start.getTime() >= s.getTime() && entry.start.getTime() <= e.getTime()) || (entry.end.getTime() >= s.getTime() && entry.end.getTime() <= e.getTime())) {
                arr.push(entry);
            }
        }
        return arr;
    }

    private function new(options : MonthViewOptions, options2 : FieldViewOptions) {
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
        _showSurroundingMonths = fo.get("showSurroundingMonths") == true;
        _gridLinesBetweenDays = fo.get("gridLinesBetweenDays") == true;
        _onDayClick = cast fo.get("onDayClick");
        #if js
            if (cast js.Syntax.code("(typeof {0}) == \"string\"", _onDayClick)) {
                _onDayClick = cast js.Syntax.code("eval({0})", _onDayClick);
            }
        #end
        _onEventClick = cast fo.get("onEventClick");
        #if js
            if (cast js.Syntax.code("(typeof {0}) == \"string\"", _onEventClick)) {
                _onEventClick = cast js.Syntax.code("eval({0})", _onEventClick);
            }
        #end
        _onMonthChange = cast fo.get("onMonthChange");
        #if js
            if (cast js.Syntax.code("(typeof {0}) == \"string\"", _onMonthChange)) {
                _onMonthChange = cast js.Syntax.code("eval({0})", _onMonthChange);
            }
        #end

        super(options2.toMap());

        _field.addEventListenerFor(com.field.Events.locationSelect(), monthEvent);
        com.field.Events.locationSelect().addEventListener(function (e : EventInfo<Dynamic, Dynamic, Dynamic>) {
            var field = e.field();
            if (field.equals(_field)) {
                monthEvent(e);
            }
        });
        startDefaultListeners(
            startDefaultListenersOptions()        
         );        
    }

    private function monthEvent(e : com.field.EventInfo<Dynamic, Dynamic, Dynamic>) : Void {
        var mainHeaderRow : Int = (_showControls || _showCurrentMonth || _showCurrentYear ? 0 : -1);
        var weekDayHeaderRow : Int = (_showWeekDays ? 0 + (mainHeaderRow == -1 ? 0 : 1) : -1);
        var headerRows : Int = (mainHeaderRow == -1 ? 0 : 1) + (weekDayHeaderRow == -1 ? 0 : 1);

        var l : com.field.LocationExtendedInterface = cast e.location();
        var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
        if (mainHeaderRow >= 0 && l2.getY(null) == mainHeaderRow) {
            if (l2.getX(null) == 5) {
                previousMonth();
            } else if (l2.getX(null) == 6) {
                nextMonth();
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
            } else if (_onDayClick != null && day != null) {
                _onDayClick(day);
            }
        }
    }

    public static function register() : Void {
        com.field.replacement.Global.instance().register("field-month", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
            var options = com.field.views.MonthView.options();
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
            _now = _date;
        }
        var days : Int = 0;
        var dayCount : Int = DateTools.getMonthDays(_date);
        var week : Int = 0;
        var monthStart : Int = 0;
        var monthEnd : Int = 0;
        var dayEventCount : Map<Int, Int> = new Map<Int, Int>();
        var mainHeaderRow : Int = (_showControls || _showCurrentMonth || _showCurrentYear ? 0 : -1);
        var weekDayHeaderRow : Int = (_showWeekDays ? 0 + (mainHeaderRow == -1 ? 0 : 1) : -1);
        var headerRows : Int = (mainHeaderRow == -1 ? 0 : 1) + (weekDayHeaderRow == -1 ? 0 : 1);

        if (_showCurrentMonth) {
            try {
                var l : com.field.LocationExtendedInterface = cast _field.get(0, 0);
                var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
                var s : String;
                #if js
                    s = cast js.Syntax.code("{0}.toLocaleString('default', { month: 'long' })", _date);
                #else
                    s = DateTools.format(_date, "%B");
                #end
                l.value(s);
                l2.doneWith();
            } catch (ex : Any) { }
        }

        if (_showCurrentYear) {
            var l : com.field.LocationExtendedInterface = cast _field.get(1, 0);
            var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
            l.value(_date.getFullYear());
            l2.doneWith();
        }

        if (_showControls) {
            var l : com.field.LocationExtendedInterface = cast _field.get(5, 0);
            var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
            l.value("<");
            l2.doneWith();

            l = cast _field.get(6, 0);
            l2 = cast l;
            l.value(">");
            l2.doneWith();            
        }

        if (_showWeekDays) {
            days = 0;
            var weekDays : Array<String> = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
            while (days < 7) {
                var l : com.field.LocationExtendedInterface = cast _field.get(days, weekDayHeaderRow);
                var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
                l.value(weekDays[days]);
                l2.doneWith();
                days++;
            }
            days = 0;
        }

        // TODO - Assign slot function

        monthStart = (new Date(_date.getFullYear(), _date.getMonth(), 1, 0, 0, 0)).getDay();
        monthEnd = (new Date(_date.getFullYear(), _date.getMonth(), dayCount, 0, 0, 0)).getDay();
        var startDay : Date = new Date(_date.getFullYear(), _date.getMonth() - 1, 1, 0, 0, 0);
        startDay = new Date(_date.getFullYear(), _date.getMonth() - 1, DateTools.getMonthDays(startDay) - monthStart + 1, 0, 0, 0);

        while (days < 7 * 6) {
            var day : Date = new Date(startDay.getFullYear(), startDay.getMonth(), startDay.getDate() + days, 0, 0, 0);
            var dayOfWeek : Int = day.getDay();
            var l : com.field.LocationExtendedInterface = cast _field.get(dayOfWeek, week * _slotsInADay + headerRows);
            var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
            if (day.getMonth() != _date.getMonth()) {
                l2.attribute("other-month", true);
                if (_showSurroundingMonths) {
                    l.value(day.getDate());
                } else {
                    l.value("");
                }
            } else {
                l2.attribute("other-month", false);
                l.value(day.getDate());
            }
            l2.doneWith();
            dayEventCount.set(days, 1);
            if (_gridLinesBetweenDays || _showCurrentDay || _showSurroundingMonths) {
                var eachSlot : Int = 0;
                while (eachSlot < _slotsInADay) {
                    var l : com.field.LocationExtendedInterface = cast _field.get(dayOfWeek, week * _slotsInADay + eachSlot + headerRows);
                    var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
                    if (_gridLinesBetweenDays) {
                        var s : String;
                        if (eachSlot == 0) {
                            s = "top";
                        } else if (eachSlot == (_slotsInADay - 1)) {
                            s = "bottom";
                            l.value("");
                        } else {
                            s = "middle";
                            l.value("");
                        }
                        l2.attribute("grid-line", s);
                    }
                    if (_showCurrentDay) {
                        l2.attribute("current-day", (day.getDate() == _now.getDate() && day.getMonth() == _now.getMonth() && day.getFullYear() == _now.getFullYear()));
                    }       
                    if (_showSurroundingMonths) {
                        l2.attribute("other-month", (day.getMonth() != _date.getMonth()));
                    }
                    l2.data("event", "");
                    l2.data("date", day);
                    l2.doneWith();
                    eachSlot++;
                }
            }
            if (dayOfWeek >= 6) {
                week++;
            }
            days++;
        }

        try {
            for (e in _calendar(_date)) {
                var day : Date = new Date(e.start.getFullYear(), e.start.getMonth(), e.start.getDate(), 0, 0, 0);
                var dayOfWeek : Int = day.getDay();
                week = Math.floor((day.getDate() + monthStart - 1) / 7);
                var l : com.field.LocationExtendedInterface = cast _field.get(dayOfWeek, week * _slotsInADay + dayEventCount.get(day.getDate()) + headerRows);
                var l2 : com.field.LocationInterface<Dynamic, Dynamic> = cast l;
                dayEventCount.set(day.getDate(), dayEventCount.get(day.getDate()) + 1);
                l.value(e.summary);
                l2.data("event", e);
                l2.doneWith();
            }
        } catch (ex : Any) {
            // TODO - Maybe autoretry?
        }

        super.fullRefresh();
    }

    public function monthChange(date : Date) : Void {
        if (_onMonthChange != null) {
            _onMonthChange(_date, date);
        }
        _date = date;
        fullRefresh();
    }

    public function nextMonth() : Void {
        monthChange(new Date(_date.getFullYear(), _date.getMonth() + 1, 1, 0, 0, 0));
    }
    
    public function previousMonth() : Void {
        monthChange(new Date(_date.getFullYear(), _date.getMonth() - 1, 1, 0, 0, 0));
    }

    public override function scrollView(x : Float, y : Float) : Void {
        var mainHeaderRow : Int = (_showControls || _showCurrentMonth || _showCurrentYear || _showWeekDays || _showCurrentDay ? 0 : -1);
        var headerRows : Int = (mainHeaderRow == -1 ? 0 : 1);

        if ((originY() - y) < 0 || x < 0) {
            originY(0);
            originX(0);
            previousMonth();
        } else if ((originY() - y) > 0 || x > 0) {
            originY(0);
            originX(0);
            nextMonth();
        } else {
            super.scrollView(x, y);
        }
    }    
}
#end