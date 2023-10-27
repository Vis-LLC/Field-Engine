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
class EventView extends FieldViewAbstract {
    private var _event : CalendarInvite;

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
    public static function create(options : EventViewOptions, options2 : FieldViewOptions) : EventView {
        return new EventView(options, options2);
    }

    /**
        Returns the possible options for creating a FieldView.
    **/
    public static function options() : EventViewOptions {
        return new EventViewOptions();
    }

    private function eventToMap() : NativeStringMap<Any> {
        var wasNull : Bool = (_event == null);
        if (wasNull) {
            _event = new CalendarInvite();
        }
        var map : NativeStringMap<Any> = new NativeStringMap<Any>();
        map.set("created", _event.created);
        map.set("start", _event.start);
        map.set("end", _event.end);
        map.set("summary", _event.summary);
        map.set("uid", _event.uid);
        //map.set("schedulingType", _event.schedulingType);
        // TODO - Add option to hide actions
        //map.set("actionExecute", _event.actionExecute);
        //map.set("actionExecuteIn", _event.actionExecuteIn);
        //map.set("actionExecuteParameters", _event.actionExecuteParameters);
        if (wasNull) {
            _event = null;
        }
        return map;
    }

    private function new(options : EventViewOptions, options2 : FieldViewOptions) {
        var fo : NativeStringMap<Any> = options.toMap();
        var map = eventToMap();
        var options = com.field.Convert.dictionaryToFieldOptions();
        options = cast options.names(NativeVector.fromIterator(map.keys()));
        options = cast options.value(map);
        _field = com.field.Convert.dictionaryToField(options);
            //.tileWidth(Game.InventoryField.width())
            //.tileHeight(Game.InventoryField.height())
            //.tileBuffer(0)
            //.tilesAreSquares(false)

        super(options2.toMap());
    }

    public static function register() : Void {
        com.field.replacement.Global.instance().register("field-event", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
            var options = com.field.views.EventView.options();
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
        super.fullRefresh();
    }

    public function eventChange(event : CalendarInvite) : Void {
        _event = event;
        var map = eventToMap();
        var options = com.field.Convert.dictionaryToFieldOptions();
        options = cast options.names(NativeVector.fromIterator(map.keys()));
        options = cast options.value(map);
        _field = com.field.Convert.dictionaryToField(options);
        fullRefresh();
    }
   
}
#end