/**
 * POPUP WINDOW CODE
 * Used for displaying DHTML only popups instead of using buggy modal windows.
 *
 * By Seth Banks (webmaster at subimage dot com)
 * http://www.subimage.com/
 *
 * Contributions by Eric Angel (tab index code) and Scott (hiding/showing selects for IE users)
 *
 * Up to date code can be found at http://www.subimage.com/dhtml/subModal
 *
 * This code is free for you to use anywhere, just keep this comment block.
 */

 function addEvent(obj, evType, fn){
 if (obj.addEventListener){
    obj.addEventListener(evType, fn, true);
    return true;
 } else if (obj.attachEvent){
    var r = obj.attachEvent("on"+evType, fn);
    return r;
 } else {
    return false;
 }
}
function removeEvent(obj, evType, fn, useCapture){
  if (obj.removeEventListener){
    obj.removeEventListener(evType, fn, useCapture);
    return true;
  } else if (obj.detachEvent){
    var r = obj.detachEvent("on"+evType, fn);
    return r;
  } else {
    alert("Handler could not be removed");
  }
}

/**
 * Code below taken from - http://www.evolt.org/article/document_body_doctype_switching_and_more/17/30655/
 *
 * Modified 4/22/04 to work with Opera/Moz (by webmaster at subimage dot com)
 *
 * Gets the full width/height because it's different for most browsers.
 */
function getViewportHeight() {
    if (document.compatMode=='CSS1Compat') return document.documentElement.clientHeight;
	if (window.innerHeight!=window.undefined) return window.innerHeight;	
	if (document.body) return document.body.clientHeight; 
	return window.undefined; 
}
function getViewportWidth() {
    if (document.compatMode=='CSS1Compat') return document.documentElement.clientWidth; 
	if (window.innerWidth!=window.undefined) return window.innerWidth; 	
	if (document.body) return document.body.clientWidth; 
	return window.undefined; 
}

// Popup code
var gPopupMask = null;
var gPopupContainer = null;
var gPopFrame = null;
var gReturnFunc;
var gBeforePopUpFunc;
var gPopupIsShown = false;
var gPopupTitle = null;

var gHideSelects = false;
var gHideObjects = true;
var gLoadingUrl = "loading.html";

var gTabIndexes = new Array();
// Pre-defined list of tags we want to disable/enable tabbing into
var gTabbableTags = new Array("A","BUTTON","TEXTAREA","INPUT","IFRAME");	

var gPopupWidth;
var gPopupHeight;

// If using Mozilla or Firefox, use Tab-key trap.
if (!document.all) {
	document.onkeypress = keyDownHandler;
}

/**
 * Override the loading page from loading.html to something else
 */
function setPopUpLoadingPage(loading) {
	gLoadingUrl = loading;
}

/**
 * Initializes popup code on load.	
 */
function initPopUp() { 
	gPopupMask = document.getElementById("popupMask");
	gPopupContainer = document.getElementById("popupContainer");
	gPopFrame = document.getElementById("popupFrame");	
	
	// check to see if this is IE version 6 or lower. hide select boxes if so
	// maybe they'll fix this in version 7?
	var brsVersion = parseInt(window.navigator.appVersion.charAt(0), 10);
	if (brsVersion <= 6 && window.navigator.userAgent.indexOf("MSIE") > -1) {
		gHideSelects = true;
	}
}
addEvent(window, "load", initPopUp);
addEvent(window, "resize", resizePopup);

function resizePopup()
{    
    if (gPopupIsShown && gPopupWidth!=window.undefined && gPopupHeight!=window.undefined)
    {    	
	    var titleBarHeight = parseInt(document.getElementById("popupTitleBar").offsetHeight, 10);
	    var footerHeight = parseInt(document.getElementById("popupFooter").offsetHeight, 10);
        var windowHeight = getViewportHeight();
        var windowWidth = getViewportWidth();
            
        var width;
        var height;
                    
        if (gPopupHeight+titleBarHeight+footerHeight > windowHeight)
        {            
	        gPopupContainer.style.height = windowHeight + "px";
	        gPopFrame.style.height = (windowHeight - titleBarHeight - footerHeight) + "px";
	        height = windowHeight - titleBarHeight - footerHeight;	        
	    }
	    else
	    {
	        gPopupContainer.style.height = (gPopupHeight+titleBarHeight+footerHeight) + "px";
	        gPopFrame.style.height = (gPopupHeight) + "px";
	        
	        height = gPopupHeight;
	    }
	    
	    if (gPopupWidth > windowWidth)
	    {
	    	gPopupContainer.style.width = windowWidth + "px";
	        gPopFrame.style.width = parseInt(document.getElementById("popupTitleBar").offsetWidth, 10) + "px";
	        
	        width = windowWidth;
	    }
	    else
	    {
            gPopupContainer.style.width = gPopupWidth + "px";
	        gPopFrame.style.width = parseInt(document.getElementById("popupTitleBar").offsetWidth, 10) + "px";	    
	        
	        width = gPopupWidth;
	    }
	    
	    centerPopWin(width, height);	    
    }
}

function renderPopWin()
{
	document.write("<div id=\"popupMask\" style=\"display: none;\">&nbsp;</div>");
	document.write("<div id=\"popupContainer\" style=\"display: none;\">");
	document.write("<div id=\"popupInner\">");
	document.write("<div id=\"popupTitleBar\">");
	document.write("<div id=\"popupTitle\"></div>");
	document.write("<div id=\"popupControls\"><a onclick=\"hidePopWin(false);\"><span>Close</span></a></div>");
	document.write("</div>");
	document.write("<iframe src=\"" + gLoadingUrl + "\" style=\"width:100%;height:100%;background-color:transparent;\" scrolling=\"auto\" frameborder=\"0\" allowtransparency=\"true\" id=\"popupFrame\" name=\"popupFrame\" width=\"100%\" height=\"100%\"></iframe>");
	document.write("<div id=\"popupFooter\"></div>");
	document.write("</div>");
	document.write("</div>");
}

 /**
	* @argument width - int in pixels
	* @argument height - int in pixels
	* @argument url - url to display
	* @argument returnFunc - function to call when returning true from the window.
	*/

function showPopWin(url, title, width, height, beforePopUpFunc, returnFunc) {
    gBeforePopUpFunc = beforePopUpFunc;
    
    if (gBeforePopUpFunc != null)
    {
        if (!gBeforePopUpFunc())
        {
            return;
        }
    }
    
	gPopupIsShown = true;
	disableTabIndexes();
	gPopupMask.style.display = "block";
	gPopupContainer.style.display = "block";
	
	var titleBarHeight = parseInt(document.getElementById("popupTitleBar").offsetHeight, 10);
	var footerHeight = parseInt(document.getElementById("popupFooter").offsetHeight, 10);
	var windowHeight = getViewportHeight();
	var windowWidth = getViewportWidth();
	
    var realWidth;
    var realHeight;
                
    if (height+titleBarHeight+footerHeight > windowHeight)
    {            
        gPopupContainer.style.height = windowHeight + "px";
        gPopFrame.style.height = (windowHeight - titleBarHeight - footerHeight) + "px";
        realHeight = windowHeight - titleBarHeight - footerHeight;	        
    }
    else
    {
        gPopupContainer.style.height = (height+titleBarHeight+footerHeight) + "px";
        gPopFrame.style.height = (height) + "px";
        
        realHeight = height;
    }
    
    if (width > windowWidth)
    {
    	gPopupContainer.style.width = windowWidth + "px";
        gPopFrame.style.width = parseInt(document.getElementById("popupTitleBar").offsetWidth, 10) + "px";
        
        realWidth = windowWidth;
    }
    else
    {
        gPopupContainer.style.width = width + "px";
        gPopFrame.style.width = parseInt(document.getElementById("popupTitleBar").offsetWidth, 10) + "px";	    
        
        realWidth = width;
    }
    
    centerPopWin(realWidth, realHeight);	
	
	gPopupTitle = title;
	
	gPopupWidth = width;
	gPopupHeight = height;
	
	// set the url
	gPopFrame.src = url;
	
	gReturnFunc = returnFunc;	
	
	// for IE
	if (gHideSelects || gHideObjects) {
		hideSelectBoxes();
	}
	
	window.setTimeout("setPopTitle();", 249);
}

//
var gi = 0;
function centerPopWin(width, height) {
	if (gPopupIsShown == true) {
		if (width == null || isNaN(width)) {
		    if (gPopupWidth == null || isNaN(gPopupWidth))
		    {
		        width = gPopupContainer.offsetWidth;
		    }
			else
			{
			    width = gPopupWidth;
			}
		}
		if (height == null) {
		    if (gPopupHeight == null || isNaN(gPopupHeight))
		    {
		        height = gPopupContainer.offsetHeight;
		    }
			else
			{
			    height = gPopupHeight;
			}
		}
		
		var fullHeight = getViewportHeight();
		var fullWidth = getViewportWidth();
		
		var theBody = document.documentElement;
		
		var scTop = parseInt(theBody.scrollTop,10);
		var scLeft = parseInt(theBody.scrollLeft,10);
		
		gPopupMask.style.height = fullHeight + "px";
		gPopupMask.style.width = fullWidth + "px";
		gPopupMask.style.top = scTop + "px";
		gPopupMask.style.left = scLeft + "px";
		
		//window.status = gPopupMask.style.top + " " + gPopupMask.style.left + " " + gi++;
		
		var titleBarHeight = parseInt(document.getElementById("popupTitleBar").offsetHeight, 10);
		var footerHeight = parseInt(document.getElementById("popupFooter").offsetHeight, 10);
		
		var top = (fullHeight - (height+titleBarHeight+footerHeight)) / 2;
		var left = (fullWidth - width) / 2;
		
		if (top > 0)
		{
		    gPopupContainer.style.top = (scTop + top) + "px";
		}
		else
		{
		    gPopupContainer.style.top = (scTop) + "px";
		}
		
		if (left > 0)
		{
		    gPopupContainer.style.left =  (scLeft + left) + "px";
		}
		else
		{
		    gPopupContainer.style.left = (scLeft) + "px";
		}		
	}
}
//addEvent(window, "resize", centerPopWin);
//addEvent(window, "scroll", centerPopWin);
window.onscroll = centerPopWin;

/**
 * @argument callReturnFunc - bool - determines if we call the return function specified
 * @argument returnVal - anything - return value 
 */
function hidePopWin(callReturnFunc) {
	gPopupIsShown = false;
	restoreTabIndexes();
	if (gPopupMask == null) {
		return;
	}
	gPopupMask.style.display = "none";
	gPopupContainer.style.display = "none";
	if (callReturnFunc == true && gReturnFunc != null) {
		gReturnFunc(window.frames["popupFrame"].returnVal);
	}
	
	gPopFrame.src = gLoadingUrl;
	
	// display all select boxes
	if (gHideSelects || gHideObjects) {
		displaySelectBoxes();
	}
}

/**
 * Sets the popup title based on the title of the html document it contains.
 * Uses a timeout to keep checking until the title is valid.
 */
function setPopTitle() {
	if (window.frames["popupFrame"].document.title == null || window.frames["popupFrame"].document.title == gPopupTitle) 
	{
		window.setTimeout("setPopTitle();", 99);
	} 
	else 
	{
		document.getElementById("popupTitle").innerHTML = gPopupTitle
	}
}

// Tab key trap. iff popup is shown and key was [TAB], suppress it.
// @argument e - event - keyboard event that caused this function to be called.
function keyDownHandler(e) {
    if (gPopupIsShown && e.keyCode == 9)  return false;
}

// For IE.  Go through predefined tags and disable tabbing into them.
function disableTabIndexes() {
	if (document.all) {
		var i = 0;
		for (var j = 0; j < gTabbableTags.length; j++) {
			var tagElements = document.getElementsByTagName(gTabbableTags[j]);
			for (var k = 0 ; k < tagElements.length; k++) {
				gTabIndexes[i] = tagElements[k].tabIndex;
				tagElements[k].tabIndex="-1";
				i++;
			}
		}
	}
}

// For IE. Restore tab-indexes.
function restoreTabIndexes() {
	if (document.all) {
		var i = 0;
		for (var j = 0; j < gTabbableTags.length; j++) {
			var tagElements = document.getElementsByTagName(gTabbableTags[j]);
			for (var k = 0 ; k < tagElements.length; k++) {
				tagElements[k].tabIndex = gTabIndexes[i];
				tagElements[k].tabEnabled = true;
				i++;
			}
		}
	}
}


/**
* Hides all drop down form select boxes on the screen so they do not appear above the mask layer.
* IE has a problem with wanted select form tags to always be the topmost z-index or layer
*
* Thanks for the code Scott!
*/
function hideSelectBoxes() {
	for(var i = 0; i < document.forms.length; i++) {
		for(var e = 0; e < document.forms[i].length; e++){
			if( (gHideSelects && document.forms[i].elements[e].tagName == "SELECT") 
				|| (gHideObjects && document.forms[i].elements[e].tagName == "OBJECT") ) {
				document.forms[i].elements[e].style.visibility="hidden";
			}
		}
	}
}

/**
* Makes all drop down form select boxes on the screen visible so they do not reappear after the dialog is closed.
* IE has a problem with wanted select form tags to always be the topmost z-index or layer
*/
function displaySelectBoxes() {
	for(var i = 0; i < document.forms.length; i++) {
		for(var e = 0; e < document.forms[i].length; e++){
			if( (gHideSelects && document.forms[i].elements[e].tagName == "SELECT") 
				|| (gHideObjects && document.forms[i].elements[e].tagName == "OBJECT") ) {
				document.forms[i].elements[e].style.visibility="visible";
			}
		}
	}
}