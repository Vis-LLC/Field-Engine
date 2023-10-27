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
}

window.addEventListener('load', function() {
    com.field.replacement.Global.instance().replaceElements()
});
