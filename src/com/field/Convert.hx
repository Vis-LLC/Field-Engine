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
    Collection of conversion routines.  Converting from native data structures to a Field.
    For additional conversion routines, see com.field.sdtk.
**/
class Convert {
    private function new() { }

    /**
        Options for converting a 2D array to a Field.
    **/
    public static function array2DToFieldNoIndexesOptions() : Array2DToFieldNoIndexesOptions {
        return new Array2DToFieldNoIndexesOptions();
    }

    /**
        Convert a 2D array to a Field.
    **/
    public static function array2DToFieldNoIndexes(foOptions : Array2DToFieldNoIndexesOptions) : FieldInterface<Dynamic, Dynamic> {
        var oValues : NativeVector<NativeVector<Any>>;
        var iColumns : Int;
        var iRows : Int;
        var iStartColumn : Int;
        var iStartRow : Null<Int>;
        var bByRow : Null<Bool>;

        {
            var fo : NativeStringMap<Any> = foOptions.toMap();
            var width : Int = cast fo.get("width");
            var height : Int = cast fo.get("height");

            oValues = cast fo.get("value");
            iColumns = cast fo.get("columns");
            iRows = cast fo.get("rows");
            iStartColumn = cast fo.get("startColumn");
            iStartRow = cast fo.get("startRow");
            bByRow = cast fo.get("byRow");

            if (bByRow == null) {
                bByRow = true;
            }
    
            if (iStartRow == null) {
                iStartRow = 0;
            }
    
            if (iStartColumn == null) {
                iStartColumn = 0;
            }

            if (fo.get("locationManager") == null) {
                foOptions.locationPreallocated();
            }

            if (fo.get("locationAllocator") == null) {
                foOptions.locationAllocator(LocationTextValue.getAllocator());
            }					

            if (iColumns == null && width == null) {
                iColumns = ((bByRow && oValues.length() > 0) ? oValues.get(0).length() : oValues.length()) - iStartColumn;
                foOptions.width(iColumns);
            } else if (iColumns == null) {
                iColumns = width;
            } else if (width == null) {
                foOptions.width(iColumns);
            }

            if (iRows == null && height == null) {
                iRows = ((bByRow || oValues.length() == 0) ? oValues.length() : oValues.get(0).length()) - iStartRow;
                foOptions.height(iRows);
            } else if (iRows == null) {
                iRows = height;
            } else if (height == null) {
                foOptions.height(iRows);
            }

            fo = null;
        }

        {
            var fField : FieldInterface<Dynamic, Dynamic> = cast FieldStandard.create(cast foOptions);
            foOptions = null;
            var iEnd : Int = bByRow ? iRows : iColumns;
            var jEnd : Int = bByRow ? iColumns : iRows;

            var i : Int = 0;
            while (i < iEnd) {
                var oSegment : NativeVector<Dynamic> = oValues.get(i);
                var j : Int = 0;
                while (j < jEnd) {
                    var l : LocationInterface<Dynamic, Dynamic> = fField.get(bByRow ? j : i, bByRow ? i : j);
                    var l_ext : LocationExtendedInterface = cast l;
                    l_ext.value(oSegment.get(j));
                    l.doneWith();
                    j++;
                }

                i++;
            }

            fField.advanced().setRefresh(function (callback : Void->Void) {
                var iEnd : Int = bByRow ? iRows : iColumns;
                var jEnd : Int = bByRow ? iColumns : iRows;
    
                var i : Int = 0;
                while (i < iEnd) {
                    var oSegment : NativeVector<Dynamic> = oValues.get(i);
                    var j : Int = 0;
                    while (j < jEnd) {
                        var l : LocationInterface<Dynamic, Dynamic> = fField.get(bByRow ? j : i, bByRow ? i : j);
                        var l_ext : LocationExtendedInterface = cast l;
                        l_ext.value(oSegment.get(j));
                        l.doneWith();
                        j++;
                    }
                    i++;
                }
    
                if (callback != null) {
                    callback();
                }
            });

            return fField;
        }
    }

    private static function separateColumns(sName : String, oValue : Any, fLocation : Any -> String -> LocationInterface<Dynamic, Dynamic>) : NativeVector<LocationInterface<Dynamic, Dynamic>> {
        var lLocations : NativeArray<LocationInterface<Dynamic, Dynamic>> = new NativeArray<LocationInterface<Dynamic, Dynamic>>();
        
        lLocations.push(fLocation(sName, "Name"));
        lLocations.push(fLocation(oValue, "Value"));

        return lLocations.toVector();
    }

    /**
        Options for converting a dictionary/map to a Field.
    **/
    public static function dictionaryToFieldOptions() : DictionaryToFieldOptions {
        return new DictionaryToFieldOptions();
    }

    private static function get(o : Any) : Any {
        if (isFunction(o)) {
            var f : Void -> Dynamic = cast o;
            return f();
        } else {
            return o;
        }
    }

    private static function isFunction (o : Any) : Bool {
        return
        #if js
            cast js.Syntax.code("(typeof {0} === 'function')", o);
        #else
            // TODO
        #end
    }

    // TODO - Optimized/Restricted version and non-optimized version
    /**
        Convert a dictionary to a Field.
    **/
    public static function dictionaryToField(foOptions : DictionaryToFieldOptions) : FieldInterface<Dynamic, Dynamic> {
        var iColumns : Null<Int>;
        var fEntryHandler : Null<String -> Any -> Any -> NativeVector<LocationInterface<Dynamic, Dynamic>>>;
        var sNames : Null<NativeVector<String>>;
        var oValue : Null<NativeStringMap<Any>>;

        {
            var fo : NativeStringMap<Any> = foOptions.toMap();

            iColumns = cast fo.get("columns");
            fEntryHandler = cast fo.get("entryHandler");
            sNames = cast get(fo.get("names"));
            oValue = cast fo.get("value");

            {
                var width : Null<Int> = cast fo.get("width");

                if (iColumns == null && width == null) {
                    iColumns = 2;
                    foOptions.width(iColumns);
                } else if (iColumns == null) {
                    iColumns = width;
                } else if (width == null) {
                    foOptions.width(iColumns);
                }
            }

            if (fo.get("locationManager") == null) {
                foOptions.locationPreallocated();
            }

            if (fo.get("locationAllocator") == null) {
                foOptions.locationAllocator(LocationTextValue.getAllocator());
            }

            if (fEntryHandler == null) {
                fEntryHandler = cast separateColumns;
            }

            if (fo.get("height") == null) {
                foOptions.height(sNames.length());
            }

            fo = null;
        }
        {
            var fField : FieldInterface<Dynamic, Dynamic> = cast FieldStandard.create(cast foOptions);
            foOptions = null;
            var iCurrentColumn : Int = 0;
            var iCurrentRow : Int = 0;

            for (sName in oValue.keys()) {
                var o : Any = oValue.get(sName);
                var bAdd : Bool = false;

                if (sNames != null) {
                    bAdd = (sNames.indexOf(sName) >= 0);
                } else {
                    bAdd = !isFunction(o);
                }

                if (bAdd) {
                    switch (iColumns) {
                        case 2: {
                            var i : Int = 0;
                            while (i < 2) {
                                var lLocation : LocationInterface<Dynamic, Dynamic> = fField.get(i, iCurrentRow);
                                var l_ext : LocationExtendedInterface = cast lLocation;
                                switch (i) {
                                    case 0:
                                        l_ext.value(sName);
                                    case 1:
                                        l_ext.value(get(o));
                                }
                                lLocation.doneWith();
                                i++;
                            }
                        }
                    }
                    iCurrentRow++;
                }
            }

            fField.advanced().setRefresh(function (callback : Void->Void) {
                var iCurrentRow : Int = 0;
                for (sName in oValue.keys()) {
                    var o : Any = oValue.get(sName);
                    var bAdd : Bool = false;
    
                    if (sNames != null) {
                        bAdd = (sNames.indexOf(sName) >= 0);
                    } else {
                        bAdd = !isFunction(o);
                    }
    
                    if (bAdd) {
                        o = get(o);
                        var lLocation : LocationInterface<Dynamic, Dynamic> = fField.get(1, iCurrentRow++);
                        var l_ext : LocationExtendedInterface = cast lLocation;
                        l_ext.value(o);
                        lLocation.doneWith();
                    }
                }

                callback();
            });

            return fField;
        }
    }
}