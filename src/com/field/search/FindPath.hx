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

package com.field.search;

import com.field.Coordinate;
import com.field.NativeArray;
import com.field.search.FindPathResult;
import haxe.Exception;
import com.field.NativeStringMap;

@:expose
@:nativeGen
/**
  Finds a path from one location in a Field to another.
**/
class FindPath {
    private function new() { }

    private static function execute(local : AccessorInterface) : Any {
        var fromDirection : NativeVector<Coordinate> = local.directions();
 
        var data : NativeVector<NativeStringMap<Any>> = cast local.data();
        var result : NativeArray<FindPathResult> = new NativeArray<FindPathResult>();
        var sliceSize : Int = Math.floor(data.length() / local.sliceCount());
        var sliceStart : Int = Math.floor(sliceSize * local.slice());
        var sliceEnd : Int = sliceStart + sliceSize;
        // TODO - Store somewhere and retrieve?
        var canEnterCache : NativeIntMap<Bool> = new NativeIntMap<Bool>();
        var maxPossible : Int = cast #if js
            js.Syntax.code("Number.MAX_VALUE");
        #else
            // TODO
        #end
   
        var i : Int = sliceStart;
        while (i < sliceEnd) {
            var options : Null<NativeStringMap<Any>> = data.get(i);
            var cache : Null<NativeIntMap<Any>> = cast options.get("cache");
            var startX : Int = cast options.get("startX");
            var startY : Int = cast options.get("startY");
            var endX : Int = cast options.get("endX");
            var endY : Int = cast options.get("endY");
            var canEnter : Null<Any->Any->Any->Any->Bool> = cast options.get("canEnter");
            var iDistanceLimit : Null<Int> = cast options.get("distanceLimit");
            var iHopLimit : Null<Int> = cast options.get("hopLimit");
            var width : Int = local.getColumns();
            var height : Int = local.getRows();

            options = null;

            if (canEnter == null) {
                canEnter = function (accessor : Any, ?x : Any = null, ?y : Any = null, ?name : Any = null) : Bool { return true; }
            }
    
            if (cache == null) {
                cache = new NativeIntMap<Any>();//{ start: {}, next: { }, };
            }
    
            if (iDistanceLimit == null) {
                iDistanceLimit = 100;
            }
    
            if (iHopLimit == null) {
                iHopLimit = 200;
            }

            cache.set(-1, new NativeStringMap<Any>());

            var startDirection = function (x : Int, y : Int, ?iCountTo : Null<Int>) : Int {
                if (iCountTo == null) {
                    iCountTo = 1;
                }
                //var key = iCountTo + x * 10 + y * 100;
                //var result = cache.start[key];
                //if (!result) {
                var result : Int = -1;
                var iCount : Int = 0;
                var i : Int = 0;

                while (i <= 3) {
                    var direction : Coordinate = fromDirection.get(i);
                    var directionX : Int = direction.x;
                    var directionY : Int = direction.y;
                    if (
                         (directionX != 0 && directionX == x)
                        || (directionY != 0 && directionY == y)
                    ) {
                        iCount++;
                        if (iCount >= iCountTo) {
                            result = i;
                            break;
                        }
                    }
                    i++;
                }
                //	cache.start[key] = result;
                //}
                return result;
            }
    
            var nextDirection = function (x : Int, y : Int) : Null<Int> {
                if (x == 0 || y == 0) {
                    return null;
                } else {
                    return startDirection(x, y, 2);
                }
            }


            var min : Null<Coordinate -> Coordinate -> Int -> Int -> Int -> Null<Int> -> Null<String> -> FindPathResult> = null;
            min = function (start : Coordinate, end : Coordinate, iHops : Int, directionX : Int, directionY : Int, ?distance : Null<Int>, ?endKey : Null<String>) : FindPathResult {
                if (endKey == null) {
                    endKey = "-" + end.x + "," + end.y;
                }
                var key : String;
                var startKey : Null<String>;
                {
                    var lookup : Int = width * start.y + start.x;
                    startKey = cache.get(width * start.y + start.x);
                    if (startKey == null) {
                        startKey = "" + start.x + "," + start.y;
                        cache.set(lookup, startKey);
                    }
                }
                key = startKey + endKey;
                var result : Null<FindPathResult>;
                {
                    var map : NativeStringMap<FindPathResult> = cast cache.get(-1);
                    result = cast map.get(key);
                }
                var path : Null<NativeArray<Coordinate>> = null;
                var value : Int = -1;
                if (result == null) {
                    if (distance == null) {
                        directionX = end.x - start.x;
                        directionY = end.y - start.y;
                        distance = Math.floor(Math.abs(directionX) + Math.abs(directionY));
                    }
                    if (distance <= iDistanceLimit) {
                        var distanceX : Int = Math.floor(Math.abs(directionX));
                        var distanceY : Int = Math.floor(Math.abs(directionY));
                        if (directionX != 0) {
                            directionX = Math.floor(directionX / distanceX);
                        }
                        if (directionY != 0) {
                            directionY = Math.floor(directionY / distanceY);
                        }
                        if (distance <= 1) {
                            value = 1;
                            path = new NativeArray<Coordinate>();
                            path.push(start);
                            path.push(end);
                        } else {
                            var minValue : Int = maxPossible;
                            var iStartingDirection : Int;
                            var iNextDirection : Null<Int>;
                            var iDirection : Int = -1;
                            var iDirections : Int = local.directions().length();
                            var iRotation : Int;
                            var direction : Coordinate;
                            var possibilities : NativeArray<FindPathResult> = new NativeArray<FindPathResult>();
                            var best : Null<FindPathResult> = null;

                            iStartingDirection = startDirection(directionX, directionY);
                            iNextDirection = nextDirection(directionX, directionY);
                            if (iNextDirection == null) {
                                iRotation = 1;
                            } else {
                                if (iNextDirection == 0 && iStartingDirection == 3) {
                                    iNextDirection = 4;
                                }
                                if (distanceX >= distanceY) {
                                    if (iStartingDirection % 2 == 0) {
                                        var iSwap : Int = iStartingDirection;
                                        iStartingDirection = iNextDirection;
                                        iNextDirection = iSwap;
                                    }
                                } else {
                                    if (iStartingDirection % 2 == 1) {
                                        var iSwap : Int = iStartingDirection;
                                        iStartingDirection = iNextDirection;
                                        iNextDirection = iSwap;
                                    }
                                }
                                iRotation = (iNextDirection - iStartingDirection + iDirections) % iDirections;
                            }

                            var i : Int = 0;
                            while (i < iDirections) {
                                iDirection = (i * iRotation + iStartingDirection + iDirections) % iDirections;
                                direction = fromDirection.get(iDirection);
                                var pos : Coordinate = new Coordinate(start.x + direction.x, start.y + direction.y);
                                var lookup : Int = pos.y * width + pos.x;
                                var canEnterResult : Null<Bool> = canEnterCache.get(lookup);
                                if (canEnterResult == null) {
                                    canEnterResult = canEnter(local, pos, null, null);
                                    canEnterCache.set(lookup, canEnterResult);
                                }
                                if (canEnterResult == true) {
                                    var newDirectionX : Int = end.x - pos.x;
                                    var newDirectionY : Int = end.y - pos.y;
                                    var newDistance : Int = Math.floor(Math.abs(newDirectionX) + Math.abs(newDirectionY));
                                    if ((iHops + newDistance + 1) <= iHopLimit) {
                                        var possibility : FindPathResult = min(pos, end, iHops + 1, newDirectionX, newDirectionY, newDistance, endKey);
                                        possibilities.push(possibility);
                                        if (possibility.value == (distance - 1)) {
                                            best = possibility;
                                            minValue = distance;
                                            break;
                                        }
                                    }
                                }

                                i++;
                            }
                            if (best == null) {
                                for (possibility in possibilities) {
                                    if (possibility.value < minValue) {
                                        best = possibility;
                                        minValue = possibility.value;
                                    }
                                }
                            }
                            if (best == null) {
                                value = maxPossible;
                                path = new NativeArray<Coordinate>();
                                path.push(start);
                            } else {
                                value = minValue;
                                path = new NativeArray<Coordinate>();
                                path.push(start);
                                path = path.concat(best.path.toArray());
                            }
                        }
                    }

                    result = new FindPathResult(start, end, value, path.toVector());
                    {
                        var map : NativeStringMap<FindPathResult> = cast cache.get(-1);
                        map.set(key, result);
                    }
                } else {
                    path = result.path.toArray();
                    value = result.value;
                }
                return result;
            }

            result.push(min(new Coordinate(startX, startY), new Coordinate(endX, endY), 0, 0, 0, null, null));
            i++;
        }

        return result;
    }

    public static function schedule(options : FindPathOptions) : Void {
        var fo : NativeStringMap<Any> = options.toMap();
        if (fo.get("whenDone") == null) {
            throw new Exception("whenDone required with a scheduled operation.");
        }
        var field : FieldInterface<Dynamic, Dynamic> = cast fo.get("field");
        field.advanced().registerClass(Type.getClassName(Coordinate));
        field.advanced().registerClass(Type.getClassName(FindPathResult));
        //field.advanced().registerClass(Type.getClassName(UsableAbstract));
        //field.advanced().registerClass(Type.getClassName(UsableAbstractWithData));
        //field.advanced().registerClass(Type.getClassName(SpriteAbstract));
        //field.advanced().registerFunction(Type.getClassName(SpriteAbstract) + ".getAttribute");

        field.advanced().scheduleOperation(execute, options);
    }

    public static function immediate(options : FindPathOptions) : FindPathResult {
        var fo : NativeStringMap<Any> = options.toMap();
        options = null;
        if (fo.get("callback") != null) {
            throw new Exception("Callback not supported on immediate.");
        }
        if (fo.get("whenDone") != null) {
            throw new Exception("whenDone not supported on immediate.");
        }        
        var field : FieldInterface<Dynamic, Dynamic> = cast fo.get("field");
        fo.set("field", null);
        var accessor : AccessorInterface = field.getDefaultAccessor();
        accessor.data(fo);
        var r : Any = execute(accessor);
        accessor.clearData();
        return cast r;
    }

    public static function options() : FindPathOptions {
        return new FindPathOptions();
    }
}
