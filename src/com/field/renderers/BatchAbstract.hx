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

package com.field.renderers;

@:expose
@:nativeGen
/**
    A Partial Strategy for how the FieldView runs all rendering operations in a set/batch.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class BatchAbstract implements RendererMode {
    private var _laterBatch : NativeArray<Void -> Void> = new NativeArray<Void -> Void>();
    private var _batch : NativeArray<Void -> Void> = new NativeArray<Void -> Void>();
    private var _block : Int = 0;
    private var _scheduled : Bool = false;

    public function now(f : Void -> Void) : Void {
        if (_block > 0) {
            _batch.push(f);
        } else {
            f();
        }
    }

    public function later(f : Void -> Void) : Void {
        _laterBatch.push(f);
    }

    public function start() : Void {
        _block++;
    }

    private function endI(f : Void -> Void) : Void {
        _block--;
        if (_block < 0) {
            _block = 0;
        }

        if (_block == 0 && !_scheduled) {
            _scheduled = true;
            f();
        }
    }

    private function onAnimationFrame(f : Void -> Void) {
        #if js
            js.Syntax.code("window.requestAnimationFrame({0})", f);
        #else
            // TODO
        #end
    }

    private function next(f : Void -> Void) {
        // TODO
    }

    public function go() : Void {
        var start : Date = Date.now();
        _scheduled = false;
        var batch : NativeArray<Void -> Void> = _batch;
        _batch = _laterBatch;
        _laterBatch = new NativeArray<Void -> Void>();

        for (f in batch) {
            f();
        }

        // console.log("DOM Update of " + batch.length + " events for " + (Date.now() - start) + "ms");

        if (_batch.length() > 0) {
            schedule(go);
        }
    }

    public function end() : Void {
    }

    public function schedule(f : Void -> Void) : Void {
    }
}
