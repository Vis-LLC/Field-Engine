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

/**
    These methods are not generally accessed directly and are considered "advanced".  All Fields should support these operations.
**/
@:expose
@:nativeGen
interface FieldAdvancedInterface extends HasAccessor {
    /**
        These operations are generally run in parallel on multiple threads.
    **/
    function largeOperation(f : AccessorInterface -> Any, callback : Null<Any->Any->Int->Int->Void>, whenDone : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void, data : Any, cleanDivide : Int) : Void;

    /**
        These operations are generally run sequentially.
    **/
    function smallOperation(f : AccessorInterface -> Any, callback : Null<Any->Any->Int->Int->Void>, whenDone : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void, data : Any, cleanDivide : Int) : Void;
    
    /**
        These operations are "batched".  Normally, they run sequentially as "small operations", but when there are multiple requested at one time, they are run in a set as a "large operation".
    **/
    function scheduleOperation(f : AccessorInterface->Any, options : ScheduleOperationOptions<Dynamic>) : Void;

    /**
        Register a type to be used in different memory spaces for parallel operations.
    **/
    function registerClass(t : String) : Void;

    /**
        Register a function to be used in different memory spaces for parallel operations.
    **/
    function registerFunction(f : String) : Void;

    /**
        Replace refresh routine for Field
    **/
    function setRefresh(f : Dynamic->Void) : Void;

    /**
        Dispose of extra data structures, threads, etc that support workers.
    **/
    function doneWithWorkers() : Void;
}