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
  Defines interface for processing fields as tables.
**/
@:expose
@:nativeGen
class FieldRowReader extends com.sdtk.table.DataTableRowReader {
    private var _i : Int;
    private var _info : FieldInfo;
  
    private function new(info : FieldInfo) {
      super();
      reuse(info);
    }

    public function reuse(info : FieldInfo) {
      _info = info;
      _i = info._start;
      //_done = false;
      _index = -1;
      _started = false;
      _value = null;
    }
  
    /**
      Continue reading an field from the specified location.
    **/
    public static function continueRead(info : FieldInfo, row : Int, start : Int, end : Int) : FieldRowReader {
      return continueReadReuse(info, row, start, end, null);
    }
  
    /**
      Read only a section of a field row.
    **/
    public static function readPartOfRow(field : FieldInterface<Dynamic, Dynamic>, row : Int, start : Int, end : Int, increment : Int) : FieldRowReader {
      return readPartOfRowReuse(field, row, start, end, increment, null);
    }
  
    /**
      Read entire field row.
    **/
    public static function readWholeRow(field : FieldInterface<Dynamic, Dynamic>, row : Int) : FieldRowReader {
      return readWholeRowReuse(field, row, null);
    }

    /**
      Continue reading an field from the specified location.
    **/
    public static function continueReadReuse(info : FieldInfo, row : Int, start : Int, end : Int, rowReader : Null<FieldRowReader>) : FieldRowReader {
      var info : FieldInfo = new FieldInfo(info._field, null, start, end, info._entriesInRow, info._increment, info._rowIncrement);
      if (rowReader == null) {
        rowReader = new FieldRowReader(info);
      } else {
        rowReader.reuse(info);
      }
      return rowReader;
    }
  
    /**
      Read only a section of a field row.
    **/
    public static function readPartOfRowReuse(field : FieldInterface<Dynamic, Dynamic>, row : Int, start : Int, end : Int, increment : Int, rowReader : Null<FieldRowReader>) : FieldRowReader {
      var info : FieldInfo = new FieldInfo(field, null, start, end, field.width(), increment, row);
      if (rowReader == null) {
        rowReader = new FieldRowReader(info);
      } else {
        rowReader.reuse(info);
      }
      return rowReader;      
    }
  
    /**
      Read entire field row.
    **/
    public static function readWholeRowReuse(field : FieldInterface<Dynamic, Dynamic>, row : Int, rowReader : Null<FieldRowReader>) : FieldRowReader {
      var info : FieldInfo = new FieldInfo(field, null, 0, field.width() - 1, field.width(), 1, row);
      if (rowReader == null) {
        rowReader = new FieldRowReader(info);
      } else {
        rowReader.reuse(info);
      }
      return rowReader;      
    }    
  
    public override function hasNext() : Bool {
      return _i <= _info._end;
    }
  
    public override function next() : Dynamic {
      var l : LocationInterface<Dynamic, Dynamic> = cast _info._field.get(_i, _info._rowIncrement);
      var name : Null<String> = null;
      if (l.hasValue()) {
        var l2 : LocationExtendedInterface = cast l;
        _value = l2.value();
        name = cast l2.name();
      } else {
        // TODO - Name?
        _value = null;
        try {
          var l2 : LocationExtendedInterface = cast l;
          name = cast l2.name();
        } catch (ex) { }
      }
      l.doneWith();
      _i += _info._increment;
      incrementTo(name, _value, _i);
      return _value;
    }
  
    public override function iterator() : Iterator<Dynamic> {
      return new FieldRowReader(_info);
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