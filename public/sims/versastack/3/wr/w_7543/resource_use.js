var handle
var evtEmitter
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

var myWidgetiFrame


resourceUse1 = {
	onLoad: function(){
		if ( ! this.captivate )
			return;
				handle = this.captivate.CPMovieHandle;
				evtEmitter =  handle.getCPAPIEventEmitter();
				cpInterface = handle.getCPAPIInterface();
		//if(handle.isWidgetVisible() == true){
			this.movieProps = this.captivate.CPMovieHandle.getMovieProps();
			if ( ! this.movieProps )
				return;
			varHandle = this.movieProps.variablesHandle;
			eventDisp = this.movieProps.eventDispatcher;
			mainCPNamespace = this.movieProps.getCpHandle();
			isResponsiveProject = mainCPNamespace.responsive;
			this.xmlStr = this.captivate.CPMovieHandle.widgetParams();
			this.internalImage = '';
			this.externalImage = '';
			this.description = '';
			this.myVar = '';
			myVarName = '';
			this.tab="";
			this.bgcolor= '';
			this.bcolor = '';
			this.align = '';
			this.fcolor = '';
			this.fsize = '';
			var size = this.OpenAjax.getSize();
			width = size.width;
			height = size.height;
			this.font = '';
			this.boldo = '';
			this.boldc = '';
			this.undo = '';
			this.undc = '';
			this.itao = '';
			this.itac = '';
			this.msg = '';
		
			var bodystring = '';
			
			movieWidth = parseInt(size.width.split("px")[0]);
        	movieHeight = parseInt(size.height.split("px")[0]);
		
			eventDisp.addEventListener(eventDisp.VARIABLECHANGEDEVENT,varHandChangedFull,false)
			
			//Captivate Event listener
			eventDisp.addEventListener(mainCPNamespace.WINDOWRESIZECOMPLETEDEVENT,updateSizeNPositionOnResizeComplete, false );
			eventDisp.addEventListener(mainCPNamespace.ORIENTATIONCHANGECOMPLETEDEVENT,updateSizeNPositionOnResizeComplete, false );
			
			this.updateData();
			this.doUpdate();
		//}
	},

	updateData: function(){
		var id = 0;
		var result = jQuery.parseXML( this.xmlStr );
		var resultDoc = jQuery( result );
		var strProp = resultDoc.find( 'string' ).text();
		var arrayofvalues=$(strProp).find('data').text().split(",")
		
		bodystring = "<select id='dropdown'  onchange='"+this.msg+"=this.value;'>" ;
		for( i=0;i<arrayofvalues.length;i++){
			bodystring = bodystring + "<option value="+arrayofvalues[i]+">"+arrayofvalues[i]+"</option>" ;
		}
		bodystring =bodystring + "</select>";

	},
	

	doUpdate: function() {
		var elem = document.getElementById( 'description_div' );
		if ( elem ) {
			elem.innerHTML = bodystring;
			$(elem).parent().width(movieWidth+20);
			$(elem).parent().height(movieHeight);
			
			console.log(movieWidth)
		}

		var result = jQuery.parseXML( this.xmlStr );
		var resultDoc = jQuery( result );
		var strProp1 = resultDoc.find( 'string' ).text();
		
		myVarName = $(strProp1).find('variable').text();	
		var msg = $('#dropdown').val();
			//msg = msg.replace(/\n/g,"<br />");
		varHandle[myVarName] = msg;
		
		if(myVarName!=""){
			try{
				evtEmitter.removeEventListener("CPAPI_VARIABLEVALUECHANGED",varHandChanged,myVarName)
			}catch(e){
			}
			evtEmitter.addEventListener("CPAPI_VARIABLEVALUECHANGED",varHandChanged,myVarName)
		}
		
		//alert(msg);
		var self = this;
		if($(strProp1).find("font").attr("face")!='')
		$('#dropdown').css("font-family",$(strProp1).find("font").attr("face"));
		
		if($(strProp1).find("font").attr("size")!='')
		$('#dropdown').css("font-size",$(strProp1).find("font").attr("size")+"px");
		
		if($(strProp1).find("textDecoration").attr("bold")=="true")
		$('#dropdown').css("font-weight",'bold');
		
		if($(strProp1).find("textDecoration").attr("italic")=="true")
		$('#dropdown').css("font-style",'italic');
		
		if($(strProp1).find("textDecoration").attr("underline")=="true")
		$('#dropdown').css("text-decoration",'underline');
		
		if($(strProp1).find("color").attr("textColor")!='')
		$('#dropdown').css('color',toHex($(strProp1).find("color").attr("textColor")));
		
		var allWidgets = window.parent.document.getElementsByClassName("cp-widget");
		var myFrameName = window.name;
		//alert(myFrameName);
		myWidgetiFrame = window.parent.document.getElementById(window.name);
		if(myWidgetiFrame){
			myWidgetiFrame.style.width = (movieWidth+20)+"px"
			
			myWidgetiFrame.parentElement.parentElement.style.width = myWidgetiFrame.contentWindow.document.getElementById("dropdown").offsetWidth + 60 + "px";
			myWidgetiFrame.parentElement.parentElement.style.height = myWidgetiFrame.contentWindow.document.getElementById("dropdown").offsetHeight + 10 + "px";
			//myWidgetiFrame.style.height= myWidgetiFrame.contentWindow.document.body.offsetHeight + "px";
			myWidgetiFrame.parentElement.parentElement.parentElement.style.width= myWidgetiFrame.contentWindow.document.getElementById("dropdown").offsetWidth + 20 + "px";
		}
			
		$('#dropdown').css('min-width','100px')
		$("#dropdown").live("change" , function(){	
			var msg1 = this.value;
			varHandle[myVarName] = msg1;
		});
		
		elem = null;	
	}
};


toHex = function(myColor){
		var col = myColor.split('x');
		var retString = "#";
		if(col[1].length < 6)
			for(var i = col[1].length;i<6;i++)
				retString = retString+"0";
		return retString + col[1];
}

function varHandChanged(evt){
	$('#dropdown option').each(function() { 
		if($(this).attr('value') == varHandle[myVarName]){
			$(this).attr('selected', 'selected');
		}
	});
}

function varHandChangedFull(){
	$('#dropdown option').each(function() { 
		if($(this).attr('value') == varHandle[myVarName]){
			$(this).attr('selected', 'selected');
		}
	});
	eventDisp.removeEventListener(eventDisp.VARIABLECHANGEDEVENT,varHandChangedFull)
}


resource_use = function ()
{
	return resourceUse1;
}

function updateSizeNPositionOnResizeComplete(){
	resizeInteraction(width,height);
}

function resizeInteraction(thewidth, theheight){
    var scale = 0;
    thewidth = String(thewidth).replace("px", "");
    theheight = String(theheight).replace("px", "");
    if (thewidth < theheight){
        scale = thewidth / (movieWidth);
    } else {
        scale = theheight / (movieHeight);
    }
    var margins = Math.round(25 * scale);
    margins += "px"
    scale = "scale(" + scale + ")";
	
	myWidgetiFrame.style.width = (movieWidth+20)+"px"
	
	$('#description_div').css('-webkit-transform', scale);
    $('#description_div').css('-moz-transform', scale);
    $('#description_div').css('-o-transform', scale);
    $('#description_div').css('-ms-transform', scale);
    $('#description_div').css('-moz-transform-origin', '0 0');
    $('#description_div').css('-webkit-transform-origin', '0 0');
    $('#description_div').css('-moz-transform-origin', '0 0');
    $('#description_div').css('-o-transform-origin', '0 0');
    $('#description_div').css('-ms-transform-origin', '0 0');
}
