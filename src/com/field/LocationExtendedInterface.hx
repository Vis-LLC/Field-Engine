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

package com.field;

@:expose
@:nativeGen
/**
    Adds the concepts of Locations having Values that they are "strongly associated with".  For example, with a table of values, each Location has a value it contains.
**/
interface LocationExtendedInterface {
    /**
        The value the Location contains.
    **/
    function value(?oNew : Any = null) : Any;

    /**
        The actual value the Location contains.
    **/
    function actualValue(?oNew : Any = null) : Any;

    /**
        The data source connected to the Location.
    **/
    function dataSource(?oNew : Any) : Any;

    /**
        The data source connected to the Location.
    **/
    function name(?oNew : Any = null) : Any;
}
