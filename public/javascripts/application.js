// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function getServiceTypes()
{
    clearFrame();
    $.getJSON("/remote/_get_service_types",
        function(data){
            $("<select />").attr("id","service_type").appendTo("#frame");
            $.each(data, function(i,item){
                $("<option/>").attr("value",item.code).html(item.type).appendTo("#service_type");
            });
            $("<a/>").addClass("next").attr("href","#").click(getServiceFields).html("Next").appendTo("#frame");
        });
}

function getServiceFields()
{
    selected_code = $("#service_type option:selected").attr("value");
    addAnswer("service_code",selected_code);
    clearFrame();
    $.getJSON("/remote/_get_service_fields?service_code="+selected_code,
        function(data){
            questionTime(data);
        });
}

function questionTime(questions)
{
    $("<h3 />").html("We've got some questions for you.").appendTo("#frame");
    $("<ul/>").attr("id","questions").appendTo("#frame");
    $.each(questions,function(i,item){
        switch(item.field_type)
        {
            case "TextBox":
                $("<li/>").html("<label>"+item.field_label+"</label>"+"<input type=\"text\" id=\""+item.field_name+"\" name=\""+item.field_name+"\" />"+"<a href=\"#\" class=\"button next\">next</a>").appendTo("#questions");
                break;
            case "DropDown":
                $("<li/>").html("<label>"+item.field_label+"</label>"+"<select id=\""+item.field_name+"\" name=\""+item.field_name+"\" />"+"<a href=\"#\" class=\"button next\">next</a>").appendTo("#questions");
                var options = item.item_list.split(",");

                $.each(options,function(i,vl){
                    $("<option />").attr("value",vl).html(vl).appendTo("#"+item.field_name);
                });
                break;
            case "SelectList":
                $("<li/>").html("<label>"+item.field_label+"</label>"+"<input id=\""+item.field_name+"\" name=\""+item.field_name+"\" />"+"<a href=\"#\" class=\"button next\">next</a>").appendTo("#questions");
                var options = item.item_list.split(",");
                $.each(options,function(i,vl){
                    $("<option />").attr("value",vl).html(vl).appendTo("#"+item.field_name);
                });
                break;
            case "PhoneNum":
                $("<li/>").html("<label>"+item.field_label+"</label>"+"<input type=\"text\" id=\""+item.field_name+"\" name=\""+item.field_name+"\" />"+"<a href=\"#\" class=\"button next\">next</a>").appendTo("#questions");
                break;
        }
    });
    $("#questions li:not(:first)").hide();
    $("#questions li a").click(function(){
        var id = $(this).siblings("select,input").attr("id");
        var value = $(this).siblings("select,input").attr("value");
        addAnswer(id,value);
    });
    $("#questions li:not(:last) a").click(function(){
        $(this).parent().hide().next().show();
        return false;
    });
    $("#questions li:last a").click(function(){
        $(this).hide();
        launchDescription();
    });
}

function launchDescription()
{
    clearFrame();
    $("<h3 />").html("Anything else to add?").appendTo("#frame");
    $("<textarea id=\"description\" name=\"description\" ></textarea>").appendTo("#frame");
    $("<a href=\"#\" class=\"button next\" id=\"submit_form\">next</a>").appendTo("#frame");
    $("#frame a").click(function(){
        addAnswer("description",$("#description").attr("value"));
        getFollowUpInformation();
    });
}

var markers = [];
var geo;
var map;
var pin;

function launchAddressFinder()
{
    clearFrame();
    $("<h3 />").html("Where's the problem?").appendTo("#frame");
    //$("<input type=\"text\" id=\"address_box\" name=\"address_box\" />").appendTo("#frame");
    $('<span id="api-version"></span><form class ="geocode" action="#" onsubmit="geocode(this.haku.value, null); return false">          <input type="text" size="30" id="haku" name="haku" title="Placename or address"/>   <input type="submit" id="hae" value=" >> " title="Set zoom first"/></form><a class="marker" href="javascript:follow(0)"><img src="http://maps.google.com/mapfiles/marker.png" alt="" title="click me" class="pushpin"/></a><div id="map"><noscript>You should turn on JavaScript</noscript></div>').appendTo("#frame");

    document.getElementById("map").innerHTML = "Map coming...";
    document.getElementById("api-version").innerHTML = "api v=2."+G_API_VERSION;
    if (!GBrowserIsCompatible()) {
        alert('Sorry. Your browser is not Google Maps compatible.');
    }

    /**
 * map
 */
    _mPreferMetric = true;
    map = new GMap2(document.getElementById("map"));
    var start = new GLatLng(38.908154,-77.044839);
    map.setCenter(start, 14);
    map.addControl(new GLargeMapControl());
    map.addControl(new GMapTypeControl(1));
    map.addControl(new GScaleControl());
    map.openInfoWindowHtml(map.getCenter(), "Nice to see you.");
    map.closeInfoWindow(); //preload iw
    geo = new GClientGeocoder();

/**
 * reverse/forward gecoder
 * sets marker LatLng
 */


}


    

function geocode(query, pin_,has_line){
    geo.getLocations(query, function(addresses){
        if(addresses.Status.code != 200){
            alert("D'oh!\n " + query);
        }else{
            marker = createMarker();
            var result = addresses.Placemark[0];
            marker.howMany = addresses.Placemark.length;
            marker.response = result.address;
            //alert(result.address);
            var details = result.AddressDetails||{};
            marker.accuracy = details.Accuracy||0;
            var lat = result.Point.coordinates[1];
            var lng = result.Point.coordinates[0];
            var responsePoint = new GLatLng(lat, lng);
            marker.setLatLng(responsePoint);
            if(marker.poly) map.removeOverlay(marker.poly);
            if(has_line){
                marker.poly = new GPolyline([query, responsePoint],"#ff0000",2,1);
                map.addOverlay(marker.poly);
            }
            marker.index = markers.length;
            markers.push(marker);
            if(!pin_){
                map.setCenter(responsePoint);
                map.setZoom(marker.accuracy*2 + 3);
            }
            if(result.address) doInfo(marker);
        }
    });
}


/**
 * creates and opens an info window
 * @param GMarker
 */
function doInfo(marker_){
    pin = marker_;
    var iwContents = pin.response.replace(/,/g, ",<br/>");
    iwContents += "<div class='small'>" + pin.getLatLng().toUrlValue();
    iwContents += "<br/>Accuracy: " + pin.accuracy;
    //if (pin.howMany>1)iwContents += "<br/>" + pin.howMany;
    iwContents += "</div>";
    iwContents += "<a href='javascript:selectPoint(markers["+pin.index+"])'>Select Point</a>";
    pin.bindInfoWindowHtml(iwContents);
    map.openInfoWindowHtml(pin.getLatLng(), iwContents);
}

function selectPoint(marker_){
    pin = marker_;
    var lat = pin.getLatLng().lat().toFixed(6);
    var lng = pin.getLatLng().lng().toFixed(6);

    clearFrame();
    GUnload();
    $("<label>Pick the exact address:</label>").appendTo("#frame");
    $("<ul/>").attr("id","address_results").appendTo("#frame");
    $("<div/>").attr("id","load_indicator").appendTo("#frame");

    $.getJSON("/remote/_lookup_point?lat="+lat+"&lon="+lng,
        function(data){
            //       alert(data);
            listPossibleAddresses(data)

        });

//var html = pin.response;
//alert(pin.response);
//  memoarea.value += lng + ", " + lat + ", " + html + "\n";
}


/**
 * marker with follow() function
 * @author: Esa 2008
 */
var marker;

function createMarker(){
    marker = new GMarker(map.getCenter(),{
        draggable:true,
        autoPan:false
    });
    map.addOverlay(marker);

    GEvent.addListener(marker, 'dragend', function(markerPoint){
        if(!map.getBounds().containsLatLng(markerPoint)){
            map.removeOverlay(this);
            map.removeOverlay(this.poly);
        }else{
            geocode(this.getLatLng(),this,false);
        }
    });
    return marker
}

function follow(imageInd){
    var dog = true;
    var noMore = false;

    var mouseMove = GEvent.addListener(map, 'mousemove', function(cursorPoint){
        if(!noMore){
            marker = createMarker();
            noMore = true;
        }
        if(dog){
            marker.setLatLng(cursorPoint);
        }
    });
    var mapClick = GEvent.addListener(map, 'click', function(){
        dog = false;
        geocode(marker.getLatLng(),marker,true);
        // 'mousemove' event listener is deleted for saving resources
        GEvent.removeListener(mouseMove);
        GEvent.removeListener(mapClick);
    });
}




















function listPossibleAddresses(data)
{
    $("#load_indicator").hide();
    $.each(data,function(i,item){
        $("#address_results").append("<li id=\""+item.aid+"\">"+item.address+"</li>");
    });
    $("#address_results li").click(function(){
        //$("<input type=\"hidden\" id=\"aid\" name=\"aid\" value=\""+$(this).attr("id")+"\" />").appendTo("#answers");
        addAnswer("aid",$(this).attr("id"));
        getServiceTypes();
    });
}


function getFollowUpInformation()
{
    clearFrame();
    $("#frame").html("<h3>Let's Stay In Touch</h3><label>Enter in your phone number OR your email address below, so we can keep in touch with you. We wont use it for anything else.</label><input id=\"phone_or_email\" name=\"phone_or_email\" type=\"text\"/><a href=\"#\" class=\"button next\" id=\"submit_form\">next</a>");
    $("#submit_form").click(function(){
        addAnswer("phone_or_email",$("#phone_or_email").attr("value"));
        $("#req_form").submit();
    });
}

function clearFrame()
{
    $("#frame").children().remove();
}

function addAnswer(answer_name,answer_value)
{
    if($("#answers #"+answer_name).length > 0)
    {
        $("#answers #"+answer_name).attr("value",answer_value);
    }
    else
    {
        $("<input type=\"hidden\" id=\""+answer_name+"\" name=\"answer["+answer_name+"]\" value=\""+answer_value+"\" />").appendTo("#answers");
    }
}

