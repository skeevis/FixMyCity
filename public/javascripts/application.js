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

function launchAddressFinder()
{
    clearFrame();
    $("<h3 />").html("Where's the problem?").appendTo("#frame");
    $("<input type=\"text\" id=\"address_box\" name=\"address_box\" />").appendTo("#frame");
    $("<ul/>").attr("id","address_results").appendTo("#frame");
    $("<div/>").attr("id","load_indicator").css("display","none").appendTo("#frame");

    $('#address_box').delayedObserver(1, function(element, value) {
        $("#address_results li").remove();
        $("#load_indicator").show();
        $.getJSON("/remote/_lookup_address?partial="+$("#address_box").attr("value"),
            function(data){
                listPossibleAddresses(data);
            });
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

