/*
    Copyright (C) 2020-2023 Vis LLC - All Rights Reserved

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

package com.field.views;

#if(!EXCLUDE_RENDERING || !js)
@:expose
@:nativeGen
class MirrorViewOptions extends OptionsAbstract<MirrorViewOptions> {
    public inline function new() { super(); }

    public function mirror(f : MirrorableInterface) : MirrorViewOptions {
        return set("mirror", f);
    }

    public function execute() : MirrorView {
        return MirrorView.create(this);
    }
}
#end