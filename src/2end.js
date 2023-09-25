    }
}

com.field.views.GraphView.register();
com.field.views.GraphView.register = null;

window.addEventListener('load', function() {
    com.field.replacement.Global.instance().replaceElements()
});
