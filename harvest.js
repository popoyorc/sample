clear();


var dsrdNum = 100;

var cntr = document.getElementsByClassName('_5rfl').length;
var scrllInc = 500;

do{
sleep(500);
window.scrollTo(0,scrllInc++);

console.log(cntr);
}while(cntr < dsrdNum);


var numPatt = /((\s9|09|\+639|639)\d{9})/g;
var namePatt = /'s photo./g;
var data = "";
console.log(document.getElementsByClassName('_5rfl').length);
for (var i = 0; i < document.getElementsByClassName('_5rfl').length; i++) {
	var cpNum = "",name;
	try{
		var entryAlt = document.getElementsByClassName("uiScaledImageContainer _a99")[i].getElementsByTagName('img')[0].alt;
		if(namePatt.test(entryAlt)){
			name = entryAlt.replace(namePatt,"");
			var pstDesc = document.getElementsByClassName('_5rfl')[i].innerHTML;
			var m;
			do {
    				m = numPatt.exec(pstDesc);
    				if (m) {
					cpNum = cpNum + m[1] + ", ";
    				}
			} while (m);
		}
	}catch(e){
	}
	if(name != null && cpNum != "" ){
		data = data + name + ", " + cpNum + "<br>";
	}

}
myWindow = window.open("data:text/html," + encodeURIComponent(data),"_blank", "width=800,height=600");
myWindow.focus();
