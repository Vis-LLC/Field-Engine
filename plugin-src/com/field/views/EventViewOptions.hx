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
class EventViewOptions  extends CalendarOptionsAbstract<EventViewOptions>{
    public inline function new() {
        super();
    }
    
    public function event(event : CalendarInvite) : EventViewOptions {
        return setOnce("event", event);
    }

    /**
        Create a DayView using the specified options.
    **/
    public function execute() : EventView {
        _fieldOptions.tilesAreSquares(false);
        _fieldOptions.tileWidth(1 + (cast _values.get("slots")));
        _fieldOptions.tileHeight(24);
        if (_fieldOptions._values.get("tileBuffer") == null) {
            _fieldOptions.tileBuffer(0);
        }
        if (_fieldOptions._values.get("field") == null) {
            _fieldOptions.field(cast com.field.FieldDynamic.options().width(1 + (cast _values.get("slots"))).height(24).execute());
        }
        return EventView.create(this, _fieldOptions);
    }
}
#end