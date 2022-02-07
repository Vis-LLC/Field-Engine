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

package com.field.workers;

@:nativeGen
/**
    Provides routines that allow for management of Thread Pools.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
interface WorkerThreadPoolInterface {
    /**
        This object needs to be shared across the ThreadPool.
    **/
    function registerObjectToGlobal(k : String) : Void;

    /**
        Execute the given function on the ThreadPool.
    **/
    function splitWork(processors : Null<Int>, f : AccessorInterface -> Any, callback : Null<Any->Any->Int->Int->Void>, whenDone : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void, data : Any, ?cleanDivide : Null<Int>) : Void;

    /**
        Shutdown all threads managed by the ThreadPool.
    **/
    function dispose() : Void;

    /**
        Checks to see if the Thread Pool has been disposed.
    **/
    function isDisposed() : Bool;

    /**
        Initialize accessors managed by the ThreadPool.
    **/
    function initAccessors(defaultAccessorData : AccessorFlatArraysData) : NativeVector<NativeVector<Any>>;

    /**
        Pool is wrapped.
    **/
    function wrapped() : Void;

    /**
        Pool is no longer wrapped.
    **/
    function notWrapped() : Void;
}