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

import com.sdtk.table.DataTableRowReader;

/**
  Defines interface for processing arrays as tables.
**/
@:expose
@:nativeGen
class FieldReader extends com.sdtk.table.DataTableReader {
  private var _i : Int;
  private var _info : FieldInfo;

  private function new(info : FieldInfo) {
    super();
    _info = info;
    _i = info._start;
  }

  /**
    Read the whole field.
  **/
  public static function readWholeField(field : FieldInterface<Dynamic, Dynamic>) : FieldReader {
    return new FieldReader(new FieldInfo(field, null, 0, field.height(), field.width(), 1, 1));
  }

  public static function reuse(info : FieldInfo) : FieldReader {
    return new FieldReader(info);
  }

  public override function hasNext() : Bool {
    return _i <= (_info._end < 0 ? _info._field.height() - 1 : _info._end);
  }

  public override function nextReuse(rowReader : Null<DataTableRowReader>) : Dynamic {
    var rowReader : FieldRowReader = FieldRowReader.readWholeRowReuse(_info._field, _i, cast rowReader);
    _i += _info._rowIncrement;
    incrementTo(null, rowReader, _i);
    return rowReader;
  }

  public override function next() : Dynamic {
    return nextReuse(null);
  }

  public override function iterator() : Iterator<Dynamic> {
    return new FieldReader(_info);
  }

  public function flip() : FieldWriter {
    return FieldWriter.reuse(_info);
  }
  
  public override function headerRowNotIncluded() : Bool {
    return true;
  }
}