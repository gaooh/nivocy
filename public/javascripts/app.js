// 日本語のカレンダーオブジェクトを生成して返す。
function createJaCalendarObj(id) {
	calendar　= new YAHOO.widget.Calendar("calendar", id, { title:"日付を選択してください", close:true } );
	calendar.selectEvent.subscribe(caldendarSelect, calendar, true);
	
	calendar.cfg.setProperty("MDY_YEAR_POSITION", 1);  
	calendar.cfg.setProperty("MDY_MONTH_POSITION", 2);  
	calendar.cfg.setProperty("MDY_DAY_POSITION", 3);  

	calendar.cfg.setProperty("MY_YEAR_POSITION", 1);  
	calendar.cfg.setProperty("MY_MONTH_POSITION", 2);  

	calendar.cfg.setProperty("MONTHS_SHORT",   ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]);  
	calendar.cfg.setProperty("MONTHS_LONG",    ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]);  
	calendar.cfg.setProperty("WEEKDAYS_1CHAR", ["日", "月", "火", "水", "木", "金", "土"]);  
	calendar.cfg.setProperty("WEEKDAYS_SHORT", ["日","月", "火", "水", "木", "金", "土"]);  
	calendar.cfg.setProperty("WEEKDAYS_MEDIUM",["日","月", "火", "水", "木", "金", "土"]);  
	calendar.cfg.setProperty("WEEKDAYS_LONG",  ["日","月", "火", "水", "木", "金", "土"]);  
	
	return calendar;
}

var EntryManager = Class.create(); 
EntryManager.prototype = {
	initialize : function(from, to, linkList, addPoint) { 
		this.from = from; 
	  this.to = to;
	  this.linkList = linkList;
		this.addPoint = addPoint;
	},
	
	// fromの select form list から　to, linkListの 複数のselect form へ追加する
	// その際、postできるようにhiddenパラメータを addPoint へ追加する
	addMember: function () { 
		var selectList = $(this.from);
		var selectedList = $(this.to);
		for( i = 0; i < selectList.length; i++) {

			if(selectList.options[i].selected == true) {
				var selectedItem = selectList.options[i];
				selectedList[selectedList.length] = new Option(selectedItem.text,selectedItem.value);
				for (j = 0; j < this.linkList.length ; j++) {
					var link = $(this.linkList[j]);
					link[link.length] = new Option(selectedItem.text,selectedItem.value);
				}
				selectList.options[i] = null;

				var addElement = document.createElement('input');
				addElement.id = "selectUser" + selectedItem.value; 
				addElement.name = "selectUser[]"; 
				addElement.type = "hidden";
				addElement.value = selectedItem.value;  
				var addpoint = $(this.addPoint);
				addpoint.appendChild(addElement);
			}
		}
	}, 
	
	// to, linkList の複数の　select form list から　fromのselect form へ追加する
	// その際、postできるようにhiddenパラメータを addPoint から削除する
	deleteMember: function () { 
		var selectList = $(this.from);
		var selectedList = $(this.to);
		for( i = 0; i < selectedList.length; i++) {
			if(selectedList.options[i].selected == true) {
				var delSelectItem = selectedList.options[i];
				selectList[selectList.length] = new Option(delSelectItem.text,delSelectItem.value);
				selectedList.options[i] = null;
				for (j = 0; j < this.linkList.length ; j++) {
					var link = $(this.linkList[j]);
					link.options[i] = null;
				}
				
				Element.remove("selectUser" + delSelectItem.value);
			}
		}
	}
	
};
