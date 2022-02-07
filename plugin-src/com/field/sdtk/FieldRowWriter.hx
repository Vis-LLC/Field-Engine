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

/**
  Defines interface for processing fields as table rows.
**/
@:expose
@:nativeGen
class FieldRowWriter extends com.sdtk.table.DataTableRowWriter {
  private var _i : Int;
  private var _info : FieldInfo;

  private function new(info : FieldInfo) {
    super();
    reuse(info);
  }

  public function reuse(info : FieldInfo) {
    _info = info;
    _i = info._start;
  }

  /**
    Continue writing a field from the specified location.
  **/
  public static function continueWrite(info : FieldInfo, row : Int, start : Int, end : Int) : FieldRowWriter {
    return continueWriteReuse(info, row, start, end, null);
  }

  /**
    Write to only a section of a field row.
  **/
  public static function writeToPartOfRow(field : FieldInterface<Dynamic, Dynamic>, row : Int, start : Int, end : Int, increment : Int) : FieldRowWriter {
    return writeToPartOfRowReuse(field, row, start, end, increment, null);
  }

  /**
    Write to entire field row.
  **/
  public static function writeToWholeRow(field : FieldInterface<Dynamic, Dynamic>, row : Int) : FieldRowWriter {
    return writeToWholeRowReuse(field, row, null);
  }

  public static function writeToExpandableRow(field : FieldDynamicInterface<Dynamic, Dynamic>, row : Int) : FieldRowWriter {
    return writeToExpandableRowReuse(field, row, null);
  }  
  
  /**
    Continue writing a field from the specified location.
  **/
  public static function continueWriteReuse(info : FieldInfo, row : Int, start : Int, end : Int, rowWriter : Null<FieldRowWriter>) : FieldRowWriter {
    var info : FieldInfo = new FieldInfo(info._field, null, start, end, info._entriesInRow, info._increment, info._rowIncrement);
    if (rowWriter == null) {
      rowWriter = new FieldRowWriter(info);
    } else {
      try {
        rowWriter.reuse(info);
      } catch (ex : Any) {
        rowWriter = new FieldRowWriter(info);
      }
    }
    return rowWriter;
  }

  /**
    Write to only a section of a field row.
  **/
  public static function writeToPartOfRowReuse(field : FieldInterface<Dynamic, Dynamic>, row : Int, start : Int, end : Int, increment : Int, rowWriter : Null<FieldRowWriter>) : FieldRowWriter {
    var info : FieldInfo = new FieldInfo(field, null, start, end, field.width(), increment, row);
    if (rowWriter == null) {
      rowWriter = new FieldRowWriter(info);
    } else {
      try {
        rowWriter.reuse(info);
      } catch (ex : Any) {
        rowWriter = new FieldRowWriter(info);
      }
    }
    return rowWriter;
  }

  /**
    Write to entire field row.
  **/
  public static function writeToWholeRowReuse(field : FieldInterface<Dynamic, Dynamic>, row : Int, rowWriter : Null<FieldRowWriter>) : FieldRowWriter {
    var info : FieldInfo = new FieldInfo(field, null, 0, field.width() - 1, field.width(), 1, row);
    if (rowWriter == null) {
      rowWriter = new FieldRowWriter(info);
    } else {
      try {
        rowWriter.reuse(info);
      } catch (ex : Any) {
        rowWriter = new FieldRowWriter(info);
      }
    }
    return rowWriter;
  }

  public static function writeToExpandableRowReuse(field : FieldDynamicInterface<Dynamic, Dynamic>, row : Int, rowWriter : Null<FieldRowWriter>) : FieldRowWriter {
    var info : FieldInfo = new FieldInfo(cast field, field, 0, -1, -1, 1, row);
    if (rowWriter == null) {
      rowWriter = new FieldRowWriter(info);
    } else {
      try {
        rowWriter.reuse(info);
      } catch (ex : Any) {
        rowWriter = new FieldRowWriter(info);
      }
    }
    return rowWriter;
  } 

  public override function write(data : Dynamic, name : String, index : Int) : Void {
    if (_info != null) {
      if (_info._end >= 0 && (index + _info._start) > _info._end) {
        return;
      }
      while (_i >= _info._field.width()) {
        _info._dynamic.incrementWidth();
      }
      var l : LocationInterface<Dynamic, Dynamic> = cast _info._field.get(_i, _info._rowIncrement);
      if (l.hasValue() || l.isDynamic()) {
        var l2 : LocationExtendedInterface = cast l;
        l2.value(data);
        l2.name(name);
      } else {
        // TODO
      }
      l.doneWith();
      _i += _info._increment;
    }
  }
  
  public function reset() {
    _i = _info._start;
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
}
