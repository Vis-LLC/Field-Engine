/*
    Copyright (C) 2021 Vis LLC - All Rights Reserved

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

package com.field.sdtk;

import com.sdtk.table.DataTableRowWriter;

/**
  Defines interface for processing fields as tables.
**/
@:expose
@:nativeGen
class FieldWriter extends com.sdtk.table.DataTableWriter {
  private var _i : Int;
  private var _info : FieldInfo;

  private function new(info : FieldInfo) {
    super();
    _info = info;
    _i = info._start;
  }

  public static function writeToWholeField(field : FieldInterface<Dynamic, Dynamic>) : FieldWriter {
    return new FieldWriter(new FieldInfo(field, null, 0, field.height(), field.width(), 1, 1));
  }
  
  public static function writeToExpandableField(field : FieldDynamicInterface<Dynamic, Dynamic>) : FieldWriter {
    if (field == null) {
      var options : FieldOptions<LocationDynamic, SpriteDynamic> = new FieldOptions<LocationDynamic, SpriteDynamic>();
      field = cast FieldDynamic.create(options);
    }
    return new FieldWriter(new FieldInfo(cast field, field, 0, -1, -1, 1, 1));
  }

  public static function reuse(info : FieldInfo) : FieldWriter {
    return new FieldWriter(info);
  }

  public override function start() : Void {
  }

  private override function writeStartI(name : String, index : Int, rowWriter : Null<DataTableRowWriter>) : com.sdtk.table.DataTableRowWriter {
    if (_info._end >= 0 && (index + _info._start) > _info._end) {
      return null;
    }

    while (_i >= _info._field.height()) {
      _info._dynamic.incrementHeight();
    }
    
    if (_info._dynamic != null) {
      rowWriter = FieldRowWriter.writeToExpandableRowReuse(_info._dynamic, _i, cast rowWriter);
    } else {
      rowWriter = FieldRowWriter.writeToWholeRowReuse(_info._field, _i, cast rowWriter);
    }
    
    _i += _info._rowIncrement;
    return rowWriter;
  }

  public function flip() : FieldReader {
    return FieldReader.reuse(_info);
  }
  
  public function getField() : FieldInterface<Dynamic, Dynamic> {
    return _info._field;
  }
  
  #if cs
    @:native('Dispose')
  #elseif java
    @:native('close')
  #end
  public override function dispose() : Void {
    if (_info != null) {
      _info = null;
    }
  }
  
  public override function writeHeaderFirst() : Bool {
    return false;
  }
  
  public override function writeRowNameFirst(): Bool {
  	return true;
  }
}