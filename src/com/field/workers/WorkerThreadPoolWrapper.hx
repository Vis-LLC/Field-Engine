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
class WorkerThreadPoolWrapper implements WorkerThreadPoolInterface {
    private var _pool : WorkerThreadPoolInterface;

    private function new(pool : WorkerThreadPoolInterface) {
        _pool = pool;
    }

    public function registerObjectToGlobal(k : String) : Void {
        _pool.registerObjectToGlobal(k);
    }

    public function splitWork(processors : Null<Int>, f : AccessorInterface -> Any, callback : Null<Any->Any->Int->Int->Void>, whenDone : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void, data : Any, ?cleanDivide : Null<Int>) : Void {
        _pool.splitWork(processors, f, callback, whenDone, data, cleanDivide);
    }

    public function dispose() : Void {
        // TODO

        _pool = null;
    }

    public function isDisposed() : Bool {
        return (_pool == null);
    }

    public function initAccessors(defaultAccessorData : AccessorFlatArraysData) : NativeVector<NativeVector<Any>> {
        return _pool.initAccessors(defaultAccessorData);
    }

    public function wrapped() : Void { }

    public function notWrapped() : Void { }    
}