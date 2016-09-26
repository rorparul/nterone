var handle
var evtEmitter
var total
var myVarName
var myLabels
var varHandle;
var eventDisp;
var cpInterface;
var varValue;

var movieWidth;
var movieHeight;

var width
var height

var scalefont = "false";

var contentStylessize;
var buttonStylessize;
var headerStylessize;
var instStylessize;

var iframewidth;
var iframeheight;


radiobutton1 = {
	onLoad: function()
	{
		if ( ! this.captivate )
			return;
		
				handle = this.captivate.CPMovieHandle;
				evtEmitter =  handle.getCPAPIEventEmitter();
				cpInterface = handle.getCPAPIInterface();
		//if(handle.isWidgetVisible() == true)
		//{

		this.movieProps = this.captivate.CPMovieHandle.getMovieProps();
		if ( ! this.movieProps )
			return;
		varHandle = this.movieProps.variablesHandle;
		eventDisp = this.movieProps.eventDispatcher;
		mainCPNamespace = this.movieProps.getCpHandle();
		isResponsiveProject = mainCPNamespace.responsive;
		this.xmlStr = this.captivate.CPMovieHandle.widgetParams();
		myVarName = '';
		this.direction = '';
		this.movieWidth = this.movieProps.contentWidth;
		this.movieHeight = this.movieProps.contentHeight;
		this.correctString = '';
		this.fontName;
		this.styleInfo;
		this.sizeInfo;
		var size = this.OpenAjax.getSize();
		width = size.width;
		height = size.height;
		this.boldInfo;
		this.underlineInfo;
		this.nohighlight;
		this.italicInfo;
		this.textColorInfo;
		this.highlightColorInfo;
		movieWidth = parseInt(size.width.split("px")[0]);
        movieHeight = parseInt(size.height.split("px")[0]);
			
		this.updateData();
		this.doUpdate();
        var that = this;
		this.bindEvents();
		
		eventDisp.addEventListener(eventDisp.VARIABLECHANGEDEVENT,varHandChangedFull,false)
		
		//Captivate Event listener
		eventDisp.addEventListener(mainCPNamespace.WINDOWRESIZECOMPLETEDEVENT,updateSizeNPositionOnResizeComplete, false );
		eventDisp.addEventListener(mainCPNamespace.ORIENTATIONCHANGECOMPLETEDEVENT,updateSizeNPositionOnResizeComplete, false );
			
		//}
	},

	updateData: function()
	{
		var result = jQuery.parseXML( this.xmlStr );
		var resultDoc = jQuery( result );
		var strProp = resultDoc.find( '#dataXML' ).find('string').text();
		
		var getscalefont = resultDoc.find('#scaleFonts');
        if (getscalefont){
            if (getscalefont.find('string')){
                scalefont = getscalefont.find('string').text();
            }
        }
		
		this.nohighlight = resultDoc.find( '#nohighlight' ).find('string').text()
		var userInformation = $(strProp).find('userdata');
		if(userInformation)
		{
			myVarName = userInformation.attr('varnames');
			this.direction = userInformation.attr('direction');
			myLabels = userInformation.attr('labels').split(',');
			total = myLabels.length;
			if(myVarName!=""){				
				try{
					evtEmitter.removeEventListener("CPAPI_VARIABLEVALUECHANGED",varHandChanged,myVarName)
				}catch(e){
				}
				evtEmitter.addEventListener("CPAPI_VARIABLEVALUECHANGED",varHandChanged,myVarName)
			}
			if(this.direction == "vertical"){
				this.correctString += '<ol>'
				for(i = 0 ;i < total; i++){
					this.correctString += '<li><input type="radio" id="' + "myRadioBtn"+i +'" name="myRadio" value="' + myLabels[i] + '" ><label>' + myLabels[i] + '</label></input></li>';
				}
				this.correctString += '</ol>'
			}else{
				for(i = 0 ;i < total; i++){
					this.correctString += '<input type="radio" id="' + "myRadioBtn"+i +'" name="myRadio" value="' + myLabels[i] + '" ><label>' + myLabels[i] + '</label></input>';
				}
			}
		}
		var styleInformation = $(strProp).find('textProperties');
		
		if(styleInformation){
			this.fontName = styleInformation.find('font').attr('face');
			this.styleInfo = styleInformation.find('font').attr('style');
			this.sizeInfo = styleInformation.find('font').attr('size');
			this.boldInfo = styleInformation.find('textDecoration').attr('bold');
			this.underlineInfo = styleInformation.find('textDecoration').attr('underline');
			this.italicInfo = styleInformation.find('textDecoration').attr('italic');
			this.textColorInfo = styleInformation.find('color').attr('textColor');
			
			contentStylessize = this.sizeInfo;
		
			if(this.nohighlight == "false")
			this.highlightColorInfo = styleInformation.find('color').attr('highlightColor');		
		}

		var allWidgets = window.parent.document.getElementsByClassName("cp-widget");
		var myFrameName = window.name;
		for(i=0;i<allWidgets.length;i++){
			var tempFrame =allWidgets[i].getElementsByTagName("iframe");
			for(var j=0;j<tempFrame.length;j++)
			{
			if(tempFrame[j].id == myFrameName)
				{	
					if(this.direction == "horizontal")
					allWidgets[i].style.width = (this.movieWidth - Number(allWidgets[0].style.left.replace("px",""))) + "px";
					if(this.direction == "vertical")
					allWidgets[i].style.height = (this.movieHeight - Number(allWidgets[0].style.top.replace("px",""))) + "px";
					i=allWidgets.length;
					break;}
			}
		}

	},
	
	doUpdate: function() 
	{
		for(i=0;i<window.parent.document.getElementsByClassName("cp-widget").length;i++){
			//console.log(window.parent.document.getElementsByClassName("cp-widget")[i].children[0].children[0],"saasd")
			if(window.parent.document.getElementsByClassName("cp-widget")[i].children[0].children[0].contentDocument.getElementById("radiobuttonwdgt") != null){
				myFrameName = window.name;
				myWidgetiFrame = window.parent.document.getElementById(window.name);
				iframewidth = String(myWidgetiFrame.style.width).replace("px","");
				iframeheight = String(myWidgetiFrame.style.height).replace("px","");
				break;
			}
		}
		
		$(myWidgetiFrame).hide();
		
		var elem = document.getElementById( 'description_div' );
		if ( elem ) {
			elem.innerHTML = this.correctString;
			elem.style.fontFamily = this.fontName;
			elem.style.fontSize = this.sizeInfo * "0.06" +"em";
			//elem.style.backgroundColor = getHexColor(this.highlightColorInfo);
			elem.style.color = getHexColor(this.textColorInfo);
			if(this.boldInfo == "true")
				elem.style.bold = true;
			if(this.underlineInfo == "true")
				elem.style.textDecoration = "underline";
			if(this.italicInfo == "true")
				elem.style.fontStyle = "italic";
			if(this.direction == "horizontal")
				elem.style.verticalAlign = "middle";
			//apply background color for elements inside as it will look differently
			var insideElem = elem.getElementsByTagName("label");
			var inputElem = elem.getElementsByTagName("input");
			var sizeHor = 20;
			var sizeVer = 5;
			for (var i = 0; i < insideElem.length; i++) {
				//insideElem[0].style.cssText = "font-family: 'Arial Black'; background-color: rgb(102, 255, 153); color: rgb(153, 0, 51); vertical-align: middle"
				//insideElem[i].style.cssText = "background-color:" + getHexColor(this.highlightColorInfo) + ";";
				if(this.nohighlight == "false"){
					insideElem[i].style.backgroundColor = getHexColor(this.highlightColorInfo);
				}
				
				if(this.direction == "horizontal"){
					inputElem[i].style.marginLeft = "15px";
					insideElem[i].style.verticalAlign = "middle";
					inputElem[i].style.verticalAlign = "middle";
				}else{
					insideElem[i].style.verticalAlign = "top";
					insideElem[i].style.display= "block";
					insideElem[i].style.marginLeft= "25px";
					insideElem[i].style.paddingTop= "2px";
					
					inputElem[i].style.verticalAlign = "top";
					inputElem[i].style.float = "left";
				}
				sizeHor = sizeHor + 40 + $(insideElem[i]).width();
				sizeVer = sizeVer + 20 + $(insideElem[i]).height();
			};

			//resize the div
			var sizeStringHor = sizeHor + 100 + "px";
			var sizeStringVer = sizeVer + 50 + "px";

			var allWidgets = window.parent.document.getElementsByClassName("cp-widget");
			var myFrameName = window.name;
			for(i=0;i<allWidgets.length;i++)
			{
				var tempFrame =allWidgets[i].getElementsByTagName("iframe");
				for(var j=0;j<tempFrame.length;j++)
				{
				if(tempFrame[j].id == myFrameName)
					{	
						allWidgets[i].style.width = sizeStringHor;
						allWidgets[i].style.height = sizeStringVer;
						i=allWidgets.length;
						break;}
				}
			}
		}
		elem = null;	
		resizeInteraction(width,height);		
	},

	bindEvents: function() 
	{
		var self = this;
		 $('input[name=myRadio]:radio').live('change', function() { 
		 	var selectedVal = $("#description_div input:radio:checked").val();
			if(isNumeric(selectedVal)){
				varHandle[myVarName] = parseInt(selectedVal);
			}else{
		 		varHandle[myVarName] = selectedVal;
			}

		 });
		 
	}
};

function isNumeric(num){
    return !isNaN(num)
}

function varHandChanged(evt){
	//Clear all radio buttons

	for(i = 0 ;i < total; i++){
		$("#myRadioBtn"+i).attr('checked',false);
	}
	
	//Select radio button based on var change
	for(i = 0 ;i < total; i++){
		if(myLabels[i] ==  varHandle[myVarName]){	
			$("#myRadioBtn"+i).attr('checked',true);
		}
	}
}

function varHandChangedFull(){
	//Clear all radio buttons
	for(i = 0 ;i < total; i++){
		$("#myRadioBtn"+i).attr('checked',false);
	}
	
	//Select radio button based on var change
	for(i = 0 ;i < total; i++){
		if(myLabels[i] ==  varHandle[myVarName]){	
			$("#myRadioBtn"+i).attr('checked',true);
		}
	}
	eventDisp.removeEventListener(eventDisp.VARIABLECHANGEDEVENT,varHandChangedFull)
}

getHexColor = function(myColor)
{
	var col = myColor.split('x');
	var retString = "#";
	if(col[1].length < 6)
		for(var i = col[1].length;i<6;i++)
			retString = retString+"0";
	return retString + col[1];
}

radiobutton = function ()
{
	return radiobutton1;
}

function updateSizeNPositionOnResizeComplete(){
	resizeInteraction(width,height);
}

function resizeInteraction(thewidth, theheight){
    var scale = 0;
	thewidth = String(thewidth).replace("px","");
	theheight = String(theheight).replace("px","");

	/**********************/
	//Modification made for Presenter same logic holds good for Captivate
	//iframe width and Height
	
	var scaleW = thewidth / (iframewidth);
	var scaleH = theheight/ (iframeheight);
	
	if(scaleW<scaleH){
		scale = scaleW
	}else{
		scale = scaleH
	}
	
	if(scalefont=="true"){
		//Content font size
			if(thewidth>=1024){
				$("#description_div").css('font-size', contentStylessize+"px");
			}else if(thewidth>= 768){
				var tempNum = Math.round(contentStylessize-2);
				if(tempNum>=12){
					$("#description_div").css('font-size', tempNum+"px");
				}else{
					$("#description_div").css('font-size', "12px");
				}
			}else if(thewidth>= 360){
				$("#description_div").css('font-size', "12px");
			}else{
				$("#description_div").css('font-size', "12px");
			}
			
			var tempcontentStylessize = contentStylessize*scale;
			if(tempcontentStylessize>=12 && tempcontentStylessize<=contentStylessize){
				$("#description_div").css('font-size', tempcontentStylessize+"px");
			}
	}else{
		if(theheight == 350 || thewidth == 320){
			$("#description_div").css('font-size', "12px");
		}
	}
	/*********************/

	$('#radiobuttonwdgt').css('width',(iframewidth*scaleW));
	$('#radiobuttonwdgt').css('height',(iframeheight*scaleH));
	
	$('#description_div').css('width',(iframewidth*scaleW)-10);
	$('#description_div').css('height',(iframeheight*scaleH));
	
	$(myWidgetiFrame).show();
	
}