var Scheduler = Class.create(); 
Scheduler.prototype = {
	
	initialize : function() { 
		this.DIVISIONS = 48;// 分割数 
	  this.CELL_HEIGHT = 20;// 1つのセルの大きさ
	  this.WEEK_COUNT = 7; // 1週間のうちの日にち数
	
		this.CELL_WIDTH_DAY = 15; // 日別表示の１時間のwidth
		
	  this.startPos = 0;
		this.endPos = 0;
		this.currentIndex = 0;
		this.currentElement = null;
	},
	
	// セレクト開始
	startTimeField: function(index) {
		this.startPos = eval(this.getCellIndexY(this.eventSrcElementId()));
		if(this.startPos < 0) {
			return false;
		}
	  this.allDisplayNone();

	  this.endPos = this.startPos;
	  this.currentIndex = index;

	  style = $("target" + this.currentIndex).style;
	  style.height = this.CELL_HEIGHT + "px";
	  var timeFieldTop = this.getRegionTop("time" + this.currentIndex);
	  style.top = (this.startPos * this.CELL_HEIGHT + timeFieldTop) + "px";
	  style.display = "block";
	},
	
	// セレクト開始:日表示
	startTimeFieldDay: function (index){
	    this.startPos = eval(this.getCellIndexY(this.eventSrcElementId()));

	    if(this.startPos < 0) {
	        return false;
			}
			
	    this.allDisplayNone();

	    this.endPos = this.startPos;
	    this.currentIndex = index;
	    style = $("target" + this.currentIndex).style;

	    style.width = this.CELL_WIDTH_DAY + "px";
	    var timeFieldLeft = this.getRegionLeft("time" + this.currentIndex);
	    var timeFieldTop = this.getRegionTop("time" + this.currentIndex);
	    style.top = timeFieldTop;
	    style.left = (this.startPos * this.CELL_WIDTH_DAY + timeFieldLeft) + "px";

	    style.display = "block";
	},
	
	// セレクトD&D中
	overTimeField: function (){
	  if(this.currentElement != null) {
			return resize();
		}
	  
		if(this.currentIndex == 0) {
	    return false;
		}
		
	  y = eval(this.getCellIndexY(this.eventSrcElementId()));    
	  if(y < this.startPos || y == this.endPos || y >= this.DIVISIONS) {
	    return false;
		}

	  this.endPos = y;
	  YAHOO.util.Dom.setStyle("target" + this.currentIndex, "height", ((y - this.startPos + 1 ) * this.CELL_HEIGHT) + "px");
	},
	
	// セレクトD&D中:日表示
	overTimeFieldDay: function (){
	    if(this.currentElement != null){
	        return this.resizeDay();
	    }

	    if(this.currentIndex == 0){
	        return false;
	    }

	    y = eval(this.getCellIndexY(this.eventSrcElementId()));    
	    if(y < this.startPos || y == this.endPos || y >= this.DIVISIONS){
	        return false;
	    }

	    this.endPos = y;

	    // 別コード
	    YAHOO.util.Dom.setStyle("target" + this.currentIndex, "width", ((y - this.startPos + 1 ) * this.CELL_WIDTH_DAY) + "px");
	},
	
	// セレクト終了
	endTimeField: function (){
			if(this.currentElement != null){
	        return this.endResize();
	    }

	    return this.endTimeFieldCore();
	},
	
	endTimeFieldCore: function(){
			if(this.currentIndex == 0) {
	        return false;
			}
			
	    var baseDate = new Date($F('setup_base_date').replace(/-/g, "/"));
			var setupDate = new Date(baseDate.getYear() + 1900, baseDate.getMonth(), baseDate.getDate() + this.currentIndex - 1);
			var strSetupDate = ( setupDate.getYear() + 1900 ) + "/" + (setupDate.getMonth() + 1) + "/" + setupDate.getDate();
			$("view_setup_day").innerHTML = strSetupDate;
			
			startMin = this.startPos * 30 % 60;
			if (startMin == 0) { // TODO printfとかつかえたらいいのに
				 startMin = "00"
			}
			endMin = (this.endPos + 1) * 30 % 60;
			if (endMin == 0) { // TODO printfとかつかえたらいいのに
				 endMin = "00"
			}
			var strStartTime = Math.floor(this.startPos * 30 / 60) + ":" + startMin;
			$("view_setup_start_at").innerHTML = strStartTime;
			$("schedule_start_at").value = strSetupDate + " " + strStartTime;
			
			var strEndTime = Math.floor((this.endPos + 1) * 30 / 60) + ":" + endMin
			$("view_setup_end_at").innerHTML = strEndTime;
			$("schedule_end_at").value = strSetupDate + " " + strEndTime;
			
			tb_show("新規スケジュール登録","#TB_inline?height=300&width=400&inlineId=target_schedule",false);
			
			timeField = $("time" + this.currentIndex);
	    style = $("addSchedule").style;
	    style.left = (YAHOO.util.Dom.getX(timeField) + 100) + "px";
	    style.top = YAHOO.util.Dom.getY("cell" + this.currentIndex + '_' + this.endPos) + "px";
	    style.display = "block";
	
	    this.currentIndex = 0;
	},
	
	// セレクト終了:日別
	endTimeFieldDay: function (){
	    if(this.currentElement != null){
	        return this.endResizeDay();
	    }

	    if(this.currentIndex == 0) {
	        return false;
			}

	    if(this.startPos == this.endPos){
	        this.currentIndex = 0;
	        return false;
	    }

	    tb_show("新規スケジュール登録","#TB_inline?height=400&width=500&inlineId=target_schedule",false);
	    this.currentIndex = 0;
	},
	
	// 重なったときのリサイズ処理
	resize: function (){
	    if(this.currentElement == null){
	        return false;
	    }

	    y = eval(this.getCellIndexY(this.eventSrcElementId()));
	    if(y == -1){
	        if(this.eventSrcElementId() == currentElement.id){
	            y = this.getOffsetY() / this.CELL_HEIGHT;
	        }
	    }

	    if(y < this.startPos || y == this.endPos || y >= this.DIVISIONS)
	        return false;

	    this.endPos = y;        
	    this.currentElement.style.height = (this.CELL_HEIGHT * (y - this.startPos + 1) - 10) + "px";
	},
	
	startResize: function (id, y_index){
	    currentElement = $("schedule" + id);
	    this.startPos = y_index;
	    this.endPos = this.startPos;
	},
	
	// 日表示でのリサイズ
	resizeDay: function (){
	    if(currentElement == null){
	        return false;
	    }

	    var y = eval(getCellIndexY(eventSrcElementId()));
	    if(y == -1){
	        if(eventSrcElement() == currentElement){
	            y = this.startPos + Math.floor((getOffsetX() -10) / this.CELL_WIDTH_DAY) + 2;
	        }
	    } else {
	        y += 1;
	    }

	    // なにか innerHTML に書いておかないとサイズが変わらないケースがある。
	    //　height だけ変更してもだとリフレッシュされないことがあるということ？
	    minute = y%2*30;
	    currentElement.innerHTML = Math.floor(y/2) + ':' + ((minute == 0) ? '00' : minute);

	    if(y < 0 || y == this.endPos || y > this.division) {
	        return false;
			}
	    this.endPos = y;        
	    currentElement.style.width = (this.CELL_WIDTH_DAY * (y - this.startPos) - 10) + "px";
	},
	
	dayLongSchedule: function (setupDate, index) {
		setupDate = new Date(setupDate.replace(/-/g, "/"));
		var setupDay = ( setupDate.getYear() + 1900 ) + "/" + (setupDate.getMonth() + 1) + "/" + setupDate.getDate();
		var startAt = "00:00";
		var endAt = "23:59";
		$("view_setup_day").innerHTML = setupDay;
		$("view_setup_start_at").innerHTML = startAt;
		$("view_setup_end_at").innerHTML = endAt;
		
		$("schedule_start_at").value = setupDay + " " + startAt;
		$("schedule_end_at").value = setupDay + " " + endAt;
		$("schedule_day_long_flag").value = true;
		
	  tb_show("スケジュール追加","#TB_inline?height=300&width=400&inlineId=target_schedule",false);
	},
	
	// イベントが発生したエレメントIDを取得
	eventSrcElementId: function (){
		if(window.event) {
	    return window.event.srcElement;
		}
		
	  var caller = arguments.callee.caller;
	  while(caller) {
	    var object = caller.arguments[0];
	    if(object && object.constructor == MouseEvent) {
				return object.target.id;
			}
	    caller = caller.caller;
	  }

	  return null;
	},
	
	// cellIdから上から何番目かをかえす
	getCellIndexY: function (cellId) {
	    if(cellId.indexOf("cell") == -1){
	        return -1;
	    }
	    return cellId.split('_')[1];
	},
	
	getOffsetY: function (){
	  if(window.event) {
	    return window.event.offsetY;
		}
		
	  var caller = arguments.callee.caller;
	  while(caller){
	    var ob = caller.arguments[0];
	    if(ob && ob.constructor == MouseEvent) {
				return ob.layerY;
	    }
			caller = caller.caller;
	  }

	  return null;
	},

	// すべてターゲット要素の選択状態をクリアする
	allDisplayNone: function (){
	    for( i = 1; i <= this.WEEK_COUNT; i++ ){
					var target = $("target" + i);
					if(target == null) {
	            break;
	        }
	        target.style.display = "none";
	    }
	},
	
	// 指定IDの矩形領域を取得する
	getRegionTop: function (id){
	    if(this.isIE()){
	        return YAHOO.util.Dom.getRegion(id).top - 2;
	    } else {
	        return YAHOO.util.Dom.getRegion(id).top;
	    }
	},
	
	getRegionLeft: function (id){
	    if(this.isIE()){
	        return YAHOO.util.Dom.getRegion(id).left - 2;
	    } else {
	        return YAHOO.util.Dom.getRegion(id).left;
	    }
	},
	
	getRegionRight: function (id){
	    if(this.isIE()){
	        return YAHOO.util.Dom.getRegion(id).right - 2;
	    } else {
	        return YAHOO.util.Dom.getRegion(id).right;
	    }
	},
	
	isIE: function (){
	  var userAgent = window.navigator.userAgent
	  var msie = userAgent.indexOf ( "MSIE " )

	  if (msie > 0) {
			return true
		} else {
			return false;
		}
	}
};

// DD
DDProxyTest = function(id, sGroup, config) {
    if (id) {
        this.init(id, sGroup, config);
    }
};

var dragging = null;
YAHOO.extend(DDProxyTest, YAHOO.util.DD);

DDProxyTest.prototype.endDrag = function (event) {
    var x_index = Math.ceil((getRegionLeft(dragging) - getRegionLeft("time1")) / cellWidth);
    var y_index = Math.floor((getRegionTop(dragging) - getRegionTop("time1")) / cellHeight);
    
    if(x_index > 0 && x_index <= 7 && y_index >= 0 && y_index < 48){
        var base_day = document.getElementById("base_day").value;
        var base_month = document.getElementById("base_month").value;
        var base_year = document.getElementById("base_year").value;
    
        window.open(ddUpdateUrl + '/' +
            + getScheduleIdFromElement(this)
            + '?type=' + type + '&index=' + x_index + '&startTime=' + y_index + '&baseDay=' + base_day
            + '&baseMonth=' + base_month + '&baseYear=' + base_year, '_self');
    }
};

DDProxyTest.prototype.startDrag = function (event) {
    dragging = eventSrcElement();
    dragging.parentNode.style.zIndex = 10000;
};

DDDay = function(id, sGroup, config) {
    if (id) {
				this.init(id, sGroup, config);
    }
};
YAHOO.extend(DDDay, YAHOO.util.DD);

DDDay.prototype.endDrag = function (event) {
    var y_index = Math.floor((getRegionLeft(dragging) - getRegionLeft("time1")) / dayCellWidth);
    
    if(y_index >= 0 && y_index < 48){
        var base_day = document.getElementById("base_day").value;
        var base_month = document.getElementById("base_month").value;
        var base_year = document.getElementById("base_year").value;
    
        window.open(ddUpdateUrl + '/' +
            + getScheduleIdFromElement(this)
            + '?type=' + type + '&index=' + 1 + '&startTime=' + y_index + '&baseDay=' + base_day
            + '&baseMonth=' + base_month + '&baseYear=' + base_year, '_self');
    }
};

DDDay.prototype.startDrag = function (event) {
    dragging = eventSrcElement();
    dragging.parentNode.parentNode.parentNode.parentNode.style.zIndex = 10000;
};