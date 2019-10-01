
var group_map = {};
var chatHub = $.connection.chatHub;
var chatProxy = $.connection.GroupChatHub;
$(document).ready(function () {
    $('<audio id="chatAudio"><source src="' + srp + 'images/notify.ogg" type="audio/ogg"><source src="' + srp + 'images/notify.mp3" type="audio/mpeg"><source src="' + srp + 'images/notify.wav" type="audio/wav"></audio>').appendTo('body');
    
    // Declare a proxy to reference the hub. 
    var chatHub = $.connection.chatHub;
    registerClientMethods(chatHub);
    // Start Hub
    $.connection.hub.start().done(function () {
        registerEvents(chatHub);
        //registerEvents_group(chatProxy);
    });

    $("#chat_min_button").click(function () {
        if ($(this).html() == "<i class=\"fa fa-minus-square\"></i>") {
            $(this).html("<i class=\"fa fa-plus-square\"></i>");
        }
        else {
            $(this).html("<i class=\"fa fa-minus-square\"></i>");
        }
        $("#chat_box").slideToggle();
        //$("#chat_box").append("<button type='button' class='btn btn-info btn-sm' data-toggle='modal' data-target='#myModal'>Create Group</button>");
        //$("#chat_box").append("<button type='button' class='btn btn-info btn-sm' data-toggle='modal' data-target='#myModal_new'>Join Group</button>");
    });
    $("#chat_box").append("<button type='button' class='btn btn-info btn-sm' data-toggle='modal' data-target='#myModal'>Create Group</button>"); 
    setInterval(ResetTypingFlag, 6000);  
});


function registerEvents(chatHub) {
    var UserName = $("[id$=hdnCurrentUserName]").val();
    var UserID = parseInt($("[id$=hdnCurrentUserID]").val());
    chatHub.server.connect(UserName, UserID);
    
    //chatProxy.server.connect($("#spnName").text(), $("#connID").text(), $("#connID").text());
}



function registerClientMethods(chatHub) {
    // Calls when user successfully logged in
    chatHub.client.onConnected = function (id, userName, allUsers, messages, userid) {
        $('#hdId').val(id);
        $('#hdUserName').val(userName);

        // Add All Users
        for (i = 0; i < allUsers.length; i++) {
            //AddUser(chatHub, allUsers[i].ConnectionId, allUsers[i].UserName, userid);
            //console.log("Adding User:" + allUsers[i].UserName)
            AddUser(chatHub, allUsers[i].UserID, allUsers[i].UserName, userid);
        }

        // Add Existing Messages
        for (i = 0; i < messages.length; i++) {
            AddMessage(messages[i].UserName, messages[i].Message);
        }

    }
}

// On New User Connected
chatHub.client.onNewUserConnected = function (id, name, userid) {
    AddUser(chatHub, id, name, userid);
}

// On User Disconnected
chatHub.client.onUserDisconnected = function (id, userName) {
    $('#' + id).remove();
}

chatHub.client.messageReceived = function (userName, message) {
    AddMessage(userName, message);
    //var code = "<p>" + message + "</p>";
    //$("#chat_box").append(code);
}


chatHub.client.sendPrivateMessage = function (windowId, fromUserName, chatTitle, message) {
    //console.log("sendPrivateMessage" + windowId);
    var ctrId = 'private_' + windowId;
    if ($('#' + ctrId).length == 0) {
        createPrivateChatWindow(chatHub, windowId, ctrId, fromUserName, chatTitle);
        $('#chatAudio')[0].play();
    }
    else {
        var rType = CheckHiddenWindow();
        if ($('#' + ctrId).parent().css('display') == "none") {
            $('#' + ctrId).parent().parent().effect("shake", { times: 2 }, 1000);
            rType = true;
        }
        if (rType == true) {
            $('#chatAudio')[0].play();
        }
    }

    // To Be changed - Ravi 
    //$('#' + ctrId).chatbox("option", "boxManager").addMsg(fromUserName, message);
    //
    $('#' + ctrId).chatbox("option", "boxManager").addMsg(fromUserName, message);
    $('#typing_' + windowId).hide();
}
// Ravi

chatHub.client.sendGroupMessage = function (chatTitle, windowId, message, fromUserName) {
    console.log("windowID" + windowId);
    console.log("fromUsername" + fromUserName);
    console.log("ChatTitle: " + chatTitle);
    console.log("mesasge: "+ message);
    var ctrId = "group_"+windowId;
    console.log("ctrID---------", $('#' + ctrId).length );
    if ($('#' + ctrId).length == 0) {
        console.log("I am here");
        createPrivateChatWindow(chatHub, windowId, ctrId, fromUserName, chatTitle);
        $('#chatAudio')[0].play();
    }
    else {
        var rType = CheckHiddenWindow();
        if ($('#' + ctrId).parent().css('display') == "none") {
            $('#' + ctrId).parent().parent().effect("shake", { times: 2 }, 1000);
            rType = true;
        }
        if (rType == true) {
            $('#chatAudio')[0].play();
        }
    }

    // To Be changed - Ravi 
    //$('#' + ctrId).chatbox("option", "boxManager").addMsg(fromUserName, message);
    //
    $('#' + ctrId).chatbox("option", "boxManager").addMsg(fromUserName, message);
    $('#typing_' + windowId).hide();
}


// Testing



chatHub.client.receiveMessage = function (msgFrom, msg, senderid) {
    
    if (msgFrom == "NewConnection") {
        //console.log("msg:", msg);
        $("#usersCount").text(senderid);
        $('#divUsers').append('<li>' + msg + '</li>')
    }
    else if (msgFrom == "ChatHub") {
        //console.log("msg:", msg);
        $("#usersCount").text(senderid);
        $("#connID").text(msg);
    }
    else if (msgFrom == "RU") {
        //console.log("msg:", msg);
        var online = senderid.split('#');
        var length = online.length;
        for (var i = 0; i < length; i++) {
            $('#divUsers').append('<li>' + online[i] + '</li>')
        }

        $('#divChat').append('<li><strong>' + msgFrom
            + '</strong>:&nbsp;&nbsp;' + msg + '</li>')
    }
    else {
        //console.log("msg:", msg);
        $("#txtTo").val(senderid);
        $('#divChat').append('<li><strong>' + msgFrom
            + '</strong>:&nbsp;&nbsp;' + msg + '</li>')
    }
};

chatHub.client.GetLastMessages = function (TouserID, CurrentChatMessages) {
    //debugger;
    var ctrId = 'private_' + TouserID;
    var AllmsgHtml = "";
    for (i = 0; i < CurrentChatMessages.length; i++) {
        if (CurrentChatMessages[i].Message.includes("#")) {
            var array = CurrentChatMessages[i].Message.split("#");
            var msg = '<a href="' + array[1] + '">Download File</a>';
            CurrentChatMessages[i].Message = msg;
            //console.log('Helo' + CurrentChatMessages[i].Message)
            
        }

        AllmsgHtml += "<div id='divChatWindow' style=\"display: block; max-width: 200px;\" class=\"ui-chatbox-msg\">";
        if (i == CurrentChatMessages.length - 1) {
            if ($('#' + ctrId).children().last().html() != "<b>" + CurrentChatMessages[i].FromUserName + ": </b><span>" + CurrentChatMessages[i].Message + "</span>") {
                AllmsgHtml += "<b>" + CurrentChatMessages[i].FromUserName + ": </b><span>" + CurrentChatMessages[i].Message + "</span>";
            }
        }
        else {
            AllmsgHtml += "<b>" + CurrentChatMessages[i].FromUserName + ": </b><span>" + CurrentChatMessages[i].Message + "</span>";
        }
        AllmsgHtml += "</div>";
    }
    $('#' + ctrId).prepend(AllmsgHtml);
}

chatHub.client.sampleMessage = function (toUser, fromUser, fromUserid, groupid, groupName, msg) {
    //console.log(" groupName" + groupName + "groupid" + groupid);
    var sel = document.getElementById('join_groups');
    var opt = document.createElement('option');
    opt.appendChild(document.createTextNode(groupName));
    opt.value = groupName;
    sel.appendChild(opt); 
    var connectionid = $('#hdId').val();
    code = $('<div id="' + groupName + '" class="col-sm-12 bg-success"  ><i class=\"fa fa-user\"></i> ' + groupName + '<div>');
    $("#chat_box").append(code);
    $(".mydiv").append(code);
    var id = groupid;
    //OpenPrivateChatWindow(chatHub, id, groupName);
    //console.log(" hdUsername--------------------" + $('#hdUserName').val());
    //chatHub.server.broadCastMessage($('#hdUserName').val(), msg, groupName);
    $(code).dblclick(function () {
        var id = $(this).attr('id');
        //console.log("samplemessghae:", id)
        if (connectionid != id) {
            //console.log("groupid ---id"+id)
            OpenPrivateChatWindow(chatHub, "group_"+id, groupName);
        }
    });
}



function sendtoGroup(groupName) {
    chatHub.server.broadCastMessage($("#spnName").text(), $("#txtMsg").val(), groupName);
    $('#txtMsg').val('').focus();
}
function CheckHiddenWindow() {
    var hidden, state;

    if (typeof document.hidden !== "undefined") {
        state = "visibilityState";
    } else if (typeof document.mozHidden !== "undefined") {
        state = "mozVisibilityState";
    } else if (typeof document.msHidden !== "undefined") {
        state = "msVisibilityState";
    } else if (typeof document.webkitHidden !== "undefined") {
        state = "webkitVisibilityState";
    }

    if (document[state] == "hidden")
        return true;
    else
        return false;

}

function AddUser(chatHub, id, name, userid) {
    var currentuserid = parseInt($("[id$=hdnCurrentUserID]").val());
    //console.log("currentuserid:" + currentuserid);
    var connectionid = $('#hdId').val();
    //console.log("connectionid:" + connectionid);
    var code = "";
    if (connectionid == "") {
        if (userid == currentuserid) {
            $('#hdId').val(id);
            connectionid = id;
            $('#hdUserName').val(name);
        }
    }
    if (connectionid != id) {
        if ($('#' + id).length == 0) {
            code = $('<a id="' + id + '" class="col-sm-12 bg-success" > <i class=\"fa fa-user\"></i> ' + name + '<a>');
            $(code).dblclick(function () {
                var id = $(this).attr('id');
                if (connectionid != id) {
                    OpenPrivateChatWindow(chatHub, id, name);
                }
            });
        }
    }
    else {
        if ($('#curruser_' + id).length == 0) {
            code = $('<div id="curruser_' + id + '" class="col-sm-12 bg-info"  ><i class=\"fa fa-user\"></i> ' + name + '<div>');

        }
    }

    //file_image = $('<div><button type="button">Click Me!</button><div>');
    $("#chat_box").append(code);
    

    //$("#chat_box").append(file_image);
}


function AddUsertoGroup(chatHub, id, name, userid) {
    var currentuserid = parseInt($("[id$=hdnCurrentUserID]").val());
    //console.log("currentuserid:" + currentuserid);
    var connectionid = $('#hdId').val();
    //console.log("connectionid:" + connectionid);
    var code = "";
    if (connectionid == "") {
        if (userid == currentuserid) {
            $('#hdId').val(id);
            connectionid = id;
            $('#hdUserName').val(name);
        }
    }


    if (connectionid != id) {
        if ($('#' + id).length == 0) {
            code = $('<a id="' + id + '" class="col-sm-12 bg-success" > <i class=\"fa fa-user\"></i> ' + name + '<a>');
            $(code).dblclick(function () {
                var id = $(this).attr('id');
                if (connectionid != id) {
                    OpenPrivateChatWindow(chatHub, id, name);
                }
            });
        }
    }
    else {
        if ($('#curruser_' + id).length == 0) {
            code = $('<div id="curruser_' + id + '" class="col-sm-12 bg-info"  ><i class=\"fa fa-user\"></i> ' + name + '<div>');

        }
    }

    //file_image = $('<div><button type="button">Click Me!</button><div>');
    $("#chat_box").append(code);
    //$("#chat_box").append("<button id='btnSend' onclick='sendtoGroup()' >Send Message</button>");
    //$("#chat_box").append(file_image);
}

//function OpenPrivateChatWindow(chatHub, id, userName) {
//    var ctrId = 'private_' + id;
//    if ($('#' + ctrId).length > 0) return;
//    createPrivateChatWindow(chatHub, id, ctrId, userName, userName);
//}
function OpenPrivateChatWindow(chatHub, id, userName) {
    var ctrId = "";
    console.log("Username: " + userName + "  ID:"+ id)
    if (id.includes("group_")) {
        ctrId = id
        ////console.log("crtd group_:" + ctrId);
    } else {
        ctrId = 'private_' + id;
    }
    
    if ($('#' + ctrId).length > 0) return;

    createPrivateChatWindow(chatHub, id, ctrId, userName, userName);
    
}

function createPrivateChatWindow(chatHub, userId, ctrId, userName, chatTitle) {
    //console.log("ctrId:" + ctrId);
    $("#chat_div").append("<div id=\"" + ctrId + "\"></div>")
    showList.push(ctrId);
    
    $('#' + ctrId).chatbox({
        id: ctrId,
        title: chatTitle,
        user: userName,
        offset: getNextOffset(),
        width: 200,
        messageSent: function (id, user, msg) {
            if (id.includes("group_")) {
                var group_name = id.split("_");
                chatHub.server.broadCastMessage($('#hdUserName').val(), msg, group_name[1])
            } else {
                chatHub.server.sendPrivateMessage(userId, msg);
            }
            
            
            //chatHub.server.sendmessagetoall(userId, msg);
            TypingFlag = true;
        },
        boxClosed: function (removeid) {
            $('#' + removeid).remove();
            var idx = showList.indexOf(removeid);
            if (idx != -1) {
                showList.splice(idx, 1);
                diff = config.width + config.gap;
                for (var i = idx; i < showList.length; i++) {
                    offset = $("#" + showList[i]).chatbox("option", "offset");
                    $("#" + showList[i]).chatbox("option", "offset", offset - diff);
                }
            }
        }

    });

    $('#' + ctrId).siblings().css("position", "relative");
    $('#' + ctrId).siblings().append("<div id=\"typing_" + userId + "\" style=\"width:20px; height:20px; display:none; position:absolute; right:14px; top:8px\"><img height=\"20\" src=\"" + srp + "images/pencil.gif\" /></div>");
    $('#' + ctrId).siblings().append("<input type='file' id='fileUpload' />");
    $('#' + ctrId).siblings().append("<input type='button' id='btnUploadFile' value='Send' onclick='onUploadButton(" + userId + "," + ctrId +")'/>");
    $('#' + ctrId).siblings().find('textarea').on('input', function (e) {
        if (TypingFlag == true) {
            chatHub.server.sendUserTypingRequest(userId);
        }
        TypingFlag = false;
    });

    var FromUserID = parseInt($("[id$=hdnCurrentUserID]").val());
    var ToUserID = userId;
    chatHub.server.requestLastMessage(FromUserID, ToUserID);
}

chatHub.client.ReceiveTypingRequest = function (userId) {
    var ctrId = 'private_' + userId;
    if ($('#' + ctrId).length > 0) {
        jQuery('#typing_' + userId).show();
        jQuery('#typing_' + userId).delay(6000).fadeOut("slow");
    }
}

// list of boxes shown on the page
var showList = new Array();
var config = {  
    width: 200, //px
    gap: 20,
    maxBoxes: 5
};

var getNextOffset = function () {
    return (config.width + config.gap) * showList.length;
};

var TypingFlag = true;

function ResetTypingFlag() {
    TypingFlag = true;
}

function AddMessage(userName, message) {
    ////console.log("Called Addmesssge from group");
    //$('#divChatWindow').append('<div class="message"><span class="userName">' + userName + '</span>: ' + message + '</div>');
    //var height = $('#divChatWindow')[0].scrollHeight;
    //$('#divChatWindow').scrollTop(height);
}

function saveFile() {
    //console.log("Clicked on save file");
    var firstName = $("#fileContainer").val();
    //console.log(firstName.files[0])
    localStorage.setItem("file", firstName)
}

function showfileName(userId, ctrId) {
    var x = document.getElementById('fileContainer');
    //console.log(x.files.length);
    if (x.files.length > 0) {
        //console.log("Inside length");
        getBase64(x.files[0], userId);
        
    }
    
 
}

function onUploadButton(userId, ctrId) {

    console.log("Clicked upload button:" + userId + ctrId);
    var data = new FormData();
    var filename_v;
    var files = $("#fileUpload").get(0).files;

    // Add the uploaded image content to the form data collection
    if (files.length > 0) {
        data.append("UploadedImage", files[0]);
        filename_v = files[0].filename;
    }

    // Make Ajax request with the contentType = false, and procesDate = false
    var ajaxRequest = $.ajax({
        type: "POST",
        url: "/api/fileupload/uploadfile",
        contentType: false,
        processData: false,
        data: data
    });

    ajaxRequest.done(function (xhr, textStatus) {
        //console.log(xhr.Key)
        //console.log(xhr.Value)
        //var f_tag = "<a href=" + xhr.Value + ">" + filename_v + "</a>"
        var f_tag = "#" + xhr.Value;
        chatHub.server.sendPrivateMessage(userId, f_tag);

    });

}

function btnUpload() {
    //console.log("Helloword")
    // Checking whether FormData is available in browser  
    if (window.FormData !== undefined) {
        //console.log("Inside Ajax function")
        var fileUpload = document.getElementById("FileUpload1").get(0);
        var files = fileUpload.files;

        // Create FormData object  
        var fileData = new FormData();

        // Looping over all files and add it to FormData object  
        for (var i = 0; i < files.length; i++) {
            fileData.append(files[i].name, files[i]);
            ////console.log(files[i]);
        }

        // Adding one more key to FormData object  
        fileData.append('username', 'Manas');

        $.ajax({
            type: "POST",
            url: 'StartChat.aspx/UploadFiles',
            contentType: false, // Not to set any content header  
            processData: false, // Not to process data  
            data: fileData,
            dataType: "json",
            success: function (result) {
               alert(result.d);
                
            },
            error: function (err) {
                alert(err.statusText);
            }
        });
    } else {
        alert("FormData is not supported.");
    }
}
