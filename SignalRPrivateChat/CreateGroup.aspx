<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateGroup.aspx.cs" Inherits="SignalRPrivateChat.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">

        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>  
    <link href="http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/css/bootstrap.min.css"  
        rel="stylesheet" type="text/css" />  
    <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js"></script>  
    <link href="http://cdn.rawgit.com/davidstutz/bootstrap-multiselect/master/dist/css/bootstrap-multiselect.css"  
        rel="stylesheet" type="text/css" />  
    <script src="http://cdn.rawgit.com/davidstutz/bootstrap-multiselect/master/dist/js/bootstrap-multiselect.js"  
        type="text/javascript"></script>  
    <script type="text/javascript">  
        $(function () {  
            $('[id*=lstEmployee]').multiselect({  
                includeSelectAllOption: true  
            });
            $('#group_button').click(function () {
                alert("Group Created");
            });
        });


        
    </script>  

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
        //}</script>
     <div class="container">
            <div class="row">
                <div class="col-md-4 col-md-offset-4">
                    <div class="login-panel panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">Please Select Members</h3>
                        </div>
                        <div class="panel-body">
                            <div role="form">
                                <fieldset>
                                    <div class="form-group">
                                        <asp:Label ID="lblMsg" ForeColor="Red" runat="server"></asp:Label>
                                    </div>
                                    <div>
                                        <input type="text" id="group_id" />
                                    </div>
                                    <div class="form-group">
                                        <asp:ListBox ID="lstEmployee" runat="server" SelectionMode="Multiple">  
                                                    <asp:ListItem Text="Ravi" Value="1" />  
                                                    <asp:ListItem Text="Nikhil" Value="2" />  
                                                    <asp:ListItem Text="Rupesh" Value="3" />  
                                                    <asp:ListItem Text="Avinash" Value="4" />  
                                                    <asp:ListItem Text="Staya" Value="5" />  
                                                    <asp:ListItem Text="Raja" Value="6" />  
                                                </asp:ListBox>  
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator" ValidationGroup="valgrp" ControlToValidate="ddlUsers" InitialValue="0" runat="server" ForeColor="Red" Display="Dynamic" ErrorMessage="Please Select User."></asp:RequiredFieldValidator>--%>
                                    </div>
                                    <!-- Change this to a button or input when using this as a form -->
                                    <asp:Button ID="group_button" runat="server" value="Create Group"  Text="Create" Width="100px"/>
                                </fieldset>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
