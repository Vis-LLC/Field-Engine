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

package com.field.util;

@:expose
@:nativeGen
class ShooterGame extends SimpleGame {
    private var _additional : Array<Void->Void> = null;
    private var _startTime : Float = null;
    private var _currentDisplays : Array<com.field.views.FieldView> = null;
    private var _currentTime : com.field.renderers.Element = null;
    private var _licenseView : LicenseView = null;
    private var _start : StartGameView = null;
    private var _licenseDisplay : com.field.renderers.Element = null;
    private var _licenseClose : Array<com.field.renderers.Element> = null;
    private var _gameDisplay : com.field.renderers.Element = null;
    private var _loadingDisplay : Array<com.field.renderers.Element> = null;
    private var _lastDisplayedTime : String = null;
    private var _changes : Bool = true;
    private var _lastUpdate : Null<Float>;
    private var _currentUpdate : Null<Float>;
    private var _delayMultiple : Float;
    private var _swipe : Null<Float>;
    private var _interval : Dynamic;
    private var _delayBetweenIntervals : Int = 100;
    private var _swipeState : Int;
    private var _swipeEndX : Int;
    private var _swipeEndY : Int;
    private var _swipeStartX : Int;
    private var _swipeStartY : Int;
    private var _resources : Map<String, String> = new Map<String, String>();
    private var _state : State = StateAbstract.getState();
    private var _gameViews : Array<com.field.util.SingleFieldView> = new Array<com.field.util.SingleFieldView>();
    private var _paused : Bool = false;
    private static var _pauseTime : Null<Int>;
    private static var _resumeTime : Null<Int>;
    private static var _pauseDuration : Null<Int>;

    private function new() {
        super();    
    }

    private function pause() : Void {
        #if JS_BROWSER
            var e : js.html.Element = cast _gameDisplay;
            e.classList.add("paused");
        #end
        _pauseTime = cast haxe.Timer.stamp() * 1000;
        _paused = true;
    }

    private function resume() : Void {
        _resumeTime = cast haxe.Timer.stamp() * 1000;
        _pauseDuration = _resumeTime - _pauseTime;
        _startTime += _pauseDuration;
        com.field.views.ViewHistory.addPauseDuration(_pauseTime, _pauseDuration);
        #if JS_BROWSER
            var e : js.html.Element = cast _gameDisplay;
            e.classList.remove("paused");
        #end
        _paused = false;
    }

    private function initElements() : Void {
        #if js
            js.Browser.document.body.style.height = "100vh";
            js.Browser.document.body.style.width = "100vw";
            js.Browser.document.body.style.minHeight = "100vh";
            js.Browser.document.body.style.minWidth = "100vw";
            js.Browser.document.body.style.maxHeight = "100vh";
            js.Browser.document.body.style.maxWidth = "100vw";                        
            js.Browser.document.body.style.overflow = "hidden";
        #end
        for (field in Reflect.fields(this)) {
            var value : Dynamic = Reflect.field(this, field);
            if (Std.isOfType(value, LicenseView)) {
                var license : LicenseView = cast value;
                _licenseView = license;
                _licenseDisplay = license.toElement();
                _licenseClose = license._close;
                _loadingDisplay = license._loading;
            } else if (Std.isOfType(value, StartGameView)) {
                var start : StartGameView = cast value;
                _start = start;

            } else if (Std.isOfType(value, SingleFieldView)) {
                var single : SingleFieldView = cast value;
                _gameViews.push(single);
            } 
        }
        switch (_gameViews.length) {
            case 0:
                _gameViews = null;
            default:
                if (_licenseView != null) {
                    changeView(_licenseView);
                } else if (_start != null) {
                    changeView(_start);
                } else {
                    Start();
                }
        }
    }

    private function changeView(view : com.field.views.AbstractView) : Void {
        var currentDisplay : com.field.renderers.Element = _gameDisplay;
        _gameDisplay = view.toElement();
        if (Std.isOfType(view, SingleFieldView)) {
            var single : SingleFieldView = cast view;
            _currentDisplays = single.fieldViews();
        } else {
            _currentDisplays = null;
        }
        if (currentDisplay == null) {
            #if js
                js.Browser.document.body.appendChild(cast _gameDisplay);
            #end
        } else {
            #if js
                var e : js.html.Element = cast currentDisplay;
                e.replaceWith(cast _gameDisplay);
            #end
        }
        if (_currentDisplays != null) {
            setTimeout(function () {
                for (display in _currentDisplays) {
                    display.fullRefresh();
                }
            }, 1);
        }
    }

    private function gameStartUpdate() : Void { }

    private function gameUpdate() : Void { }

    private function gameFinalizeUpdate() : Void { }

    private function gameSwipe(angle : Float) : Void { }

    private function gameStart() : Void { }

    private function gameRestart() : Void { }

    private function Update() : Void {
        if (_paused) {
            return;
        }
        if (_additional == null) {
            _additional = new Array<Void->Void>();
        }
        var now : Float = Date.now().getTime();
        var duration : Float = now - this._startTime;
        var seconds : Int = Math.floor(duration / 1000);
        var minutes : Int = Math.floor(seconds / 60);
        seconds = seconds % 60;
        var time : String = "" + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
        gameStartUpdate();
        if (_changes || _additional.length > 0 || _lastDisplayedTime != time) {
            _lastDisplayedTime = time;
            if (_currentTime != null) {
                _additional.push(function () {
                    setText(_currentTime, time);
                });
            }
            com.field.Advanced.startGraphicsUpdate();
            for (display in _currentDisplays) {
                display.update();
            }
            var i : Int = 0;
            while (i < _additional.length) {
                com.field.Advanced.queueGraphicsUpdate(_additional[i]);
                i++;
            }
            _additional = new Array<Void->Void>();
            com.field.Advanced.endGraphicsUpdate();
            _changes = false;
        }
    
        _lastUpdate = _currentUpdate;
        _currentUpdate = Date.now().getTime();
        if (_lastUpdate != null) {
            _delayMultiple = (_currentUpdate - _lastUpdate) / 100;
            if (_delayMultiple > 3) {
                DisableBackgroundEffect();
            }
            //console.log(Game.DelayMultiple);
        } else {
            _delayMultiple = 1;
        }
        gameUpdate();
        if (_swipe != null) {
            gameSwipe(_swipe);
        }
        gameFinalizeUpdate();
        _swipe = null;
    }

    private override function Load() : Void {
        initElements();
        #if js
            js.Syntax.code("{0}.style.display = \"none\"", _gameDisplay);
            js.Syntax.code("{0}.style.display = \"\"", _licenseDisplay);
        #else
            hideElement(_gameDisplay, null, null);
            showElement(_licenseDisplay, null, null);
        #end

        for (close in _licenseClose) {
            setOnClick(close, toMouseEventReceiverNoArgs(CloseLicense));
            enableElement(close);
        }

        for (display in _loadingDisplay) {
            hideElement(display, null, null);
        }

        if (_start != null) {
            if (_start._newGame != null) {
                setOnClick(_start._newGame, toMouseEventReceiverNoArgs(Start));
                enableElement(_start._license);
            }
            if (_start._license != null) {
                setOnClick(_start._license, toMouseEventReceiverNoArgs(OpenLicense));
                enableElement(_start._license);
            }
        }
    }

    private function OpenLicense() : Void {
        if (_licenseView != null) {
            changeView(_licenseView);
        } else {
            #if js
                js.Syntax.code("{0}.style.display = \"none\"", _gameDisplay);
                js.Syntax.code("{0}.style.display = \"\"", _licenseDisplay);
            #else
                hideElement(_gameDisplay, null, null);
                showElement(_licenseDisplay, null, null);
            #end
            Start();
        }
    }

    private function CloseLicense() : Void {
        if (_start != null) {
            changeView(_start);
        } else if (_gameViews != null && _gameViews.length > 0) {
            Start();
        } else {
            #if js
                js.Syntax.code("{0}.style.display = \"\"", _gameDisplay);
                js.Syntax.code("{0}.style.display = \"none\"", _licenseDisplay);
            #else
                showElement(_gameDisplay, null, null);
                hideElement(_licenseDisplay, null, null);
            #end
            Start();
        }
    }

    private function calculateSwipeAngle() {
        var deltaX : Int = _swipeEndX - _swipeStartX;
        var deltaY : Int = _swipeEndY - _swipeStartY;
        _swipe = Math.atan2(deltaY, deltaX) * 180 / Math.PI;
    }        

    private function startSwipe(x : Int, y : Int) : Void {
        _swipeState = 1;
        _swipeStartX = x;
        _swipeStartY = y;
    }

    private function continueSwipe(x : Int, y : Int) : Void {
        if (_swipeState > 0) {
            _swipeEndX = x;
            _swipeEndY = y;
            _swipeState = 2;
            calculateSwipeAngle();
        }
    }

    private function endSwipe(x : Int, y : Int) : Void {
        if (_swipeState > 0) {
            _swipeEndX = x;
            _swipeEndY = y;
            _swipeState = 2;
            calculateSwipeAngle();
            _swipeState = 0;
        }
    }

    private function Start() : Void {
        _startTime = Date.now().getTime();

        #if js
            var startSwipe = this.startSwipe;
            var continueSwipe = this.continueSwipe;
            var endSwipe = this.endSwipe;
            var calculateSwipeAngle = this.calculateSwipeAngle;
            var swipeRecord = this;

            js.Syntax.code("document.addEventListener('touchstart', function (event) {
                {0}(event.touches[0].clientX, event.touches[0].clientY);
                try {
                    event.preventDefault();
                } catch (ex) { }
            })", startSwipe);
        
            js.Syntax.code("document.addEventListener('touchmove', function (event) {
                if ({1}._swipeState > 0) {
                    {0}(event.touches[0].clientX, event.touches[0].clientY);
                }
                event.preventDefault();
            }, { passive: false })", continueSwipe, swipeRecord);
        
            js.Syntax.code("document.addEventListener('touchend', function (event) {
                {0}(event.changedTouches[0].clientX, event.changedTouches[0].clientY);
                event.preventDefault();
            })", endSwipe);
        
            // Event listener for mouse events
            js.Syntax.code("document.addEventListener('mousedown', function (event) {
                {0}(event.clientX, event.clientY);

                function handleMouseMove(event) {
                    if ({1}._swipeState > 0) {
                        {1}._swipeEndX = event.clientX;
                        {1}._swipeEndY = event.clientY;
                        {1}._swipeState = 2;
                        {2}();
                    }
                }
            
                function handleMouseUp(event) {
                    {1}._swipeState = 0;
                    {2}();
            
                    document.removeEventListener('mousemove', handleMouseMove);
                    document.removeEventListener('mouseup', handleMouseUp);
                }
            
                document.addEventListener('mousemove', handleMouseMove);
                document.addEventListener('mouseup', handleMouseUp);
            })", startSwipe, swipeRecord, calculateSwipeAngle);
        #end
    
        gameStart();
    }

    private function StartUpdates() {
        EndUpdates();
        #if js
            _interval = js.Syntax.code("setInterval({0}, {1})", Update, _delayBetweenIntervals);
        #elseif python
            python.Syntax.code("import sched");
            python.Syntax.code("import time");
            _interval = function () : Void {
                if (_interval != null) {
                    var scheduler : Dynamic = python.Syntax.code("sched.scheduler(time.time, time.sleep)");
                    python.Syntax.code("{0}.enter({1}/1000.0, 1, {2})", scheduler, _delayBetweenIntervals, Update);
                    setTimeout(interval, _delayBetweenIntervals);
                    Update();
                }
            };
            var interval : Void->Void = cast _interval;
            interval();
        #elseif java
            _interval = new java.util.Timer();
            var interval : java.util.Timer = cast _interval;
            interval.scheduleAtFixedRate(new java.util.TimerTask() {
                public function run() : Void {
                    Update();
                }
            }, 0, _delayBetweenIntervals);
        #elseif cs
            _interval = new cs.system.threading.Timer(Update, null, 0, _delayBetweenIntervals);
            var interval : cs.system.threading.Timer = cast _interval;
            interval.start();
        #else
            _interval = new haxe.Timer(_delayBetweenIntervals);
            var interval : haxe.Timer = cast interval;
            interval.run = Update;
            interval.start();
        #end
    }

    private function EndUpdates() {
        if (_interval != null) {
            #if js
                js.Syntax.code("clearInterval({0})", _interval);
                _interval = null;
            #elseif python
                python.Synax.code("cancel({0})", _interval);
                _interval = null;
            #elseif java
                var interval : java.util.Timer = cast _interval;
                interval.cancel();
                _interval = null;
            #elseif cs
                var interval : cs.system.threading.Timer = cast _interval;
                interval.stop();
                _interval = null;
            #else
                var interval : haxe.Timer = cast _interval;
                interval.Dispose();
                _interval = null;
            #end
        }
    }

    private function isEmbedded(sResource : String) : Bool {
        if (sResource == null) {
            return false;
        }
        sResource = _resources.get(sResource);
        if (sResource == null) {
            return false;
        } else
            return (sResource.indexOf(".wav") < 0 && sResource.indexOf(".png") < 0 && sResource.indexOf(".mp3") < 0 && sResource.indexOf(".flac") < 0);
    }

    private function getResourceSource(sResource : String, sType : String) : String {
        if (isEmbedded(sResource)) {
            return "data:" + sType + ";base64," + _resources.get(sResource);
        } else {
            var sResult : String = _resources.get(sResource);
            return sResult == null ? sResource : sResult;
        }
    }

    private function PlayMusic(music : String) : Void {
        var audio : Dynamic = js.Browser.document.getElementById("music");
        music = getResourceSource(music, "audio/wav");
        audio.src = music;
        audio.play();
    }

    private function PlaySoundEffect(effect : String) : Void {
        var audio : Dynamic = js.Browser.document.getElementById("soundEffect");
        effect = getResourceSource(effect, "audio/wav");
        audio.src = effect;
        audio.play();
    }

    private function ShowBackground(background : String) : Void {
        try {
            var e : Dynamic = js.Browser.document.getElementsByClassName("background")[0];
            background = getResourceSource(background, "image/png");
            e.style.backgroundImage = "url('" + background + "')";
            e.style.animation = "shiftAndRotate 300s infinite linear";
        } catch (ex : Any) {
            setTimeout(function () {
                ShowBackground(background);
            }, 1);
        }
    }

    private function DisableBackgroundEffect() : Void {
        try {
            #if js
                var e : Dynamic = js.Syntax.code("document.getElementsByClassName('background')[0]");
                js.Syntax.code("{0}.style.animation = ''", e);
            #end
        } catch (ex) {
            setTimeout(function () {
                DisableBackgroundEffect();
            }, 1);
        }
    }

    private function Restart() : Void {
        setTimeout(function () {
            EndUpdates();
            _swipe = null;
            _interval = null;
            _swipeState = null;
            gameRestart();
            setTimeout(function () {
                Start();
            }, 1);
        }, 1);
    }
}