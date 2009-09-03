var OnloadFunction = Class.create();
OnloadFunction.prototype = {
    initialize : function(func) {
        this.func = func;
    },
    getFunc : function() {
        return this.func;
    }
};
var OnloadFunctions = Class.create();
OnloadFunctions.prototype = {
    initialize : function() {
        this.last = 0;
        this.functions = new Array();
    },
    getFunctionAt : function(index) {
        return this.functions[index];
    },
    appendFunction : function(func) {
        this.functions[this.last] = func;
        this.last++;
    },
    getLength : function() {
        return this.last;
    },
    iterator : function() {
        return new OnloadFunctionIterator(this);
    }
}
var OnloadFunctionIterator = Class.create();
OnloadFunctionIterator.prototype = {
    initialize : function(functions) {
        this.functions = functions;
        this.index = 0;
    },
    hasNext : function () {
        return this.index < this.functions.getLength();
    },
    next : function() {
        return this.functions.getFunctionAt(this.index++);
    }
}
var onloadFunctions = new OnloadFunctions();
function multipleOnload () {
    var it = onloadFunctions.iterator();
    while (it.hasNext()){
        var func = it.next();
        func.func();
    }
}
window.onload = multipleOnload;