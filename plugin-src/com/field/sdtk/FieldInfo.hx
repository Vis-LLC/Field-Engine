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
  Defines interface for interpreting fields.
**/
@:nativeGen
class FieldInfo {
  public var _field : FieldInterface<Dynamic, Dynamic>;
  public var _dynamic : FieldDynamicInterface<Dynamic, Dynamic>;
  public var _start : Int;
  public var _end : Int;
  public var _entriesInRow : Int;
  public var _increment : Int;
  public var _rowIncrement : Int;
  public var _collapse : Bool;
  public var _columnsAsAttributes : Bool;

  public function new(field : FieldInterface<Dynamic, Dynamic>, fieldDynamic : FieldDynamicInterface<Dynamic, Dynamic>, start : Int, end : Int, entriesInRow : Int, increment : Int, rowIncrement : Int) {
    _field = field;
    _dynamic = fieldDynamic;
    _start = start;
    _end = end;
    _entriesInRow = entriesInRow;
    _increment = increment;
    _rowIncrement = rowIncrement;
  }
}
