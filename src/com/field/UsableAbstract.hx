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

@:nativeGen
/**
    A base interface that is used to indicate that the object is managed by an Allocator.
**/
class UsableAbstract<F, L, S, T> implements Usable<F, T> {
    private var _f : Null<F> = null;
    private var _field : Null<FieldInterface<L, S>> = null;
    private var _inUse : Int = 0;

    private function new() {}

    public function doneWith() : Void {
        _field.doneWith(cast this);
    }

    public function nowInUse() : Int {
        return ++_inUse;
    }

    public function notInUse() : Int {
        if (_inUse <= 0) {
            return -1;
        } else {
            return --_inUse;
        }
    }

    public function useCount() : Int {
        return _inUse;
    }

    public function field() : F {
        return _f;
    }

    public function init(newField : F, newX : Int, newY : Int) : T {
        nowInUse();
        _f = newField;
        _field = cast newField;
        return cast this;
    }
}