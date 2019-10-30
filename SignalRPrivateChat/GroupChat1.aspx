﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GroupChat1.aspx.cs" Inherits="SignalRPrivateChat.GroupChat" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title>Group Chat App</title>

    <link href="<%=Page.ResolveUrl("~") %>Styles/bootstrap.css" rel="stylesheet" />
    <link href="<%=Page.ResolveUrl("~") %>Styles/style.css" rel="stylesheet" />
    <script src="<%=Page.ResolveUrl("~") %>Scripts/jquery.js"></script>
    <script src="<%=Page.ResolveUrl("~") %>Scripts/bootstrap.min.js"></script>
    <!--Add reference to the JQuery file-->
    <%--<script src="Scripts/jquery-1.10.2.min.js"></script>--%>
    <!-- Add reference to the minified version of the SignarR client library -->
    <%--<script src="Scripts/jquery.signalR-2.2.0.min.js"></script>--%>
    <script src="<%=Page.ResolveUrl("~") %>Scripts/jquery.signalR-2.2.0.min.js"></script>
    <!-- Add reference to the auto-generated proxy file -->
    <%--<script src="signalr/chubs"></script>--%>
    <script src="<%=Page.ResolveUrl("~") %>signalr/hubs"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            //var _name = window.prompt("Please Enter your name");
            //var _group = window.prompt("Please Enter Group name");

    var _name = "ravi";
    var _group = "my";

            $("#spnName").text(_name);
            $("#GroupName").text(_group);
            $('#txtMsg').val('');

            //Get proxy instance using the auto-generated proxy class
            var chatProxy = $.connection.GroupChatHub;
            //chatProxy.client.foo = function () { };
            // Bind the btnClick event when connection to the hub is started
            $.connection.hub.start().done(function () {

                try {
                    chatProxy.server.groupconnect($("#spnName").text(), $("#connID").text(), $("#connID").text(), $("#GroupName").text());
                } catch (e) { alert(e.message); }

                $("#btnSend").click(function () {
                    // Send Message to the Hub using the proxy instance
                    chatProxy.server.broadCastMessage($("#spnName").text(), $("#txtMsg").val(), $("#GroupName").text());
                    $('#txtMsg').val('').focus();
                })
            })
            //Callback function which the hub will call when it has finished processing,
            // is attached to the proxy
            chatProxy.client.receiveMessage = function (msgFrom, msg, senderid) {
                if (msgFrom == "NewConnection") {
                    $("#usersCount").text(senderid);
                    $('#divUsers').append('<li>' + msg + '</li>')
                }
                else if (msgFrom == "ChatHub") {
                    $("#usersCount").text(senderid);
                    $("#connID").text(msg);
                }
                else if (msgFrom == "RU") {
                    var online = senderid.split('#');
                    var length = online.length;
                    for (var i = 0; i < length; i++) {
                        $('#divUsers').append('<li>' + online[i] + '</li>')
                    }

                    $('#divChat').append('<li><strong>' + msgFrom
                        + '</strong>:&nbsp;&nbsp;' + msg + '</li>')
                }
                else {
                    $("#txtTo").val(senderid);
                    $('#divChat').append('<li><strong>' + msgFrom
                        + '</strong>:&nbsp;&nbsp;' + msg + '</li>')
                }
            };
        });


        //function joinGroup() {
        //        var _name = "ravi";
        //    var _group = "my";
        //    document.getElementById("groupChatdiv").setAttribute("display", "block");
        //    document.getElementById("seleted_group").setAttribute("display", "none");

        //    $("#spnName").text(_name);
        //    $("#GroupName").text(_group);
        //    $('#txtMsg').val('');

        //    //Get proxy instance using the auto-generated proxy class
        //    var chatProxy = $.connection.GroupChatHub;
        //    //chatProxy.client.foo = function () { };
        //    // Bind the btnClick event when connection to the hub is started
        //    $.connection.hub.start().done(function () {

        //        try {
        //            chatProxy.server.groupconnect($("#spnName").text(), $("#connID").text(), $("#connID").text(), $("#GroupName").text());
        //        } catch (e) { alert(e.message); }

        //        $("#btnSend").click(function () {
        //            // Send Message to the Hub using the proxy instance
        //            chatProxy.server.broadCastMessage($("#spnName").text(), $("#txtMsg").val(), $("#GroupName").text());
        //            $('#txtMsg').val('').focus();
        //        })
        //    })
        //    //Callback function which the hub will call when it has finished processing,
        //    // is attached to the proxy
        //    chatProxy.client.receiveMessage = function (msgFrom, msg, senderid) {
        //        if (msgFrom == "NewConnection") {
        //            $("#usersCount").text(senderid);
        //            $('#divUsers').append('<li>' + msg + '</li>')
        //        }
        //        else if (msgFrom == "ChatHub") {
        //            $("#usersCount").text(senderid);
        //            $("#connID").text(msg);
        //        }
        //        else if (msgFrom == "RU") {
        //            var online = senderid.split('#');
        //            var length = online.length;
        //            for (var i = 0; i < length; i++) {
        //                $('#divUsers').append('<li>' + online[i] + '</li>')
        //            }

        //            $('#divChat').append('<li><strong>' + msgFrom
        //                + '</strong>:&nbsp;&nbsp;' + msg + '</li>')
        //        }
        //        else {
        //            $("#txtTo").val(senderid);
        //            $('#divChat').append('<li><strong>' + msgFrom
        //                + '</strong>:&nbsp;&nbsp;' + msg + '</li>')
        //        }
        //    };
        //}

        
        //function registerEvents(chatHub) {
        //    try {
        //        chatHub.server.connect($("#spnName").text(), $("#connID").text(), $("#connID").text());
        //    } catch (e) { alert(e.message); }
        //}

    </script>
</head>
<body style= "background: #fff;">

    <form>
      <select id="seleted_group">
        <option value="books">Books</option>
        <option value="html">HTML</option>
        <option value="css">CSS</option>
        <option value="php">PHP</option>
        <option value="js">JavaScript</option>
      </select>
        <button id="join_group">Join</button>
    </form>

    <div style="width: 55%; border: solid 1px Red; height: 40px">
        <h3 style="margin: 10px 0px 0px 10px">
            <span id="spnName"></span>
            <span id="GroupName" style="margin-left: 25px;"></span>
        </h3>
    </div>
<div style="width: 55%; border: solid 1px Red; height: 40px">
        <h3 style="margin: 10px 0px 0px 10px">
            <span id="connID"></span>
            <span id="usersCount"></span>
        </h3>
    </div>
    <div id="groupChatdiv" style="width: 55%; border: solid 1px Red; height: auto ; display: block">
        <div style="height: auto" id="divUsers"></div>
        <div style="height: 70%" id="divChat"></div>
        <div style="border: dashed 1px Black; margin-top: 5%;">
           <%-- <div style="float: left; width: 20%; padding: 4px">
                <input type="text" style="width: 100%" id="txtTo" />
            </div>--%>
            <div style="float: left; width: 60%; padding: 4px">
                <input type="text" style="width: 100%" id="txtMsg" />
            </div>
            <div style="float: right; width: 15%; padding: 4px">
                <input type="button" id="btnSend" value="Send Message" style="width: 45px" />
            </div>
        </div>
    </div>
</body>
</html>
