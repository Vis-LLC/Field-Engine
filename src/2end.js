    }
}

if (!!(com.field.views.GraphView) && !!(com.field.views.GraphView.register)) {
    com.field.views.GraphView.register();
    com.field.views.GraphView.register = null;
    com.field.views.MonthView.register();
    com.field.views.MonthView.register = null;
    com.field.views.DayView.register();
    com.field.views.DayView.register = null;
    com.field.views.CalendarView.register();
    com.field.views.CalendarView.register = null;
    com.field.views.CodeView.register();
    com.field.views.CodeView.register = null;    
}

if (!(globalThis["Game"])) {
    globalThis.Game = {
        Load: function () {
            com.field.util.SimpleGame.beginLoad();
        }
    };
}

if (!(globalThis["App"])) {
    globalThis.App = {
        Load: function () {
            com.field.util.SimpleApp.beginLoad();
        }
    }
}

window.addEventListener('load', function() {
    com.field.replacement.Global.instance().replaceElements()
});
