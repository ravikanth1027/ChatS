<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StartChat.aspx.cs" Inherits="SignalRPrivateChat.StartChat" %>

<%@ Register Src="~/controls/ctlChatBox.ascx" TagName="ctlChatBox" TagPrefix="uc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Private Chat App</title>
    <script type="text/javascript">
        var srp = '<%=Page.ResolveUrl("~") %>';
    </script>
    <link href="<%=Page.ResolveUrl("~") %>Styles/bootstrap.css" rel="stylesheet" />
    <link href="<%=Page.ResolveUrl("~") %>Styles/jquery.ui.chatbox.css" rel="stylesheet" />
    <link href="<%=Page.ResolveUrl("~") %>Styles/style.css" rel="stylesheet" />        
    <link href="<%=Page.ResolveUrl("~") %>fonts/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="<%=Page.ResolveUrl("~") %>Scripts/jquery/jquery-ui/jquery-ui.css" rel="stylesheet" />
    <script src="<%=Page.ResolveUrl("~") %>Scripts/jquery.js"></script>    
    <script src="<%=Page.ResolveUrl("~") %>Scripts/jquery/jquery-ui/jquery-ui.js" type="text/javascript"></script>
    <script src="<%=Page.ResolveUrl("~") %>Scripts/bootstrap.min.js"></script>
    <script src="<%=Page.ResolveUrl("~") %>Scripts/fileUpload.js"></script>
    <%--<script src="<%=Page.ResolveUrl("~")%>lib/jquery.min.js"></script>--%>
    <%--<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>--%>
<script type="text/javascript">

        //$(document).ready(function () {
            //var _name = window.prompt("Please Enter your name");
            //var _group = window.prompt("Please Enter Group name");
    function joinGroup() {
        var _name = document.getElementById("hdUserName").value;
        
        var e = document.getElementById("join_groups");
        var strUser = e.options[e.selectedIndex].value;
        var _group = strUser;

        $("#spnName").text(_name);
        $("#GroupName").text(_group);
        $('#txtMsg').val('');
        chatHub.server.groupconnect($("#spnName").text(), $("#connID").text(), $("#connID").text(), $("#GroupName").text());
    }


    function addGroup() {
        //var listofUser = [], suser;
        var _name = document.getElementById("hdUserName").value;
        var _group = document.getElementById('group_id').value;
         var listofUser = [];    
    $("#select_users :selected").each(function(){
        listofUser.push($(this).val()); 
    });
    



        $("#spnName").text(_name);
        $("#GroupName").text(_group);
        $('#txtMsg').val('');
        //var listofUser = ["1", "2", "3"];
        chatHub.server.addgroupserver($("#spnName").text(), $("#connID").text(), $("#connID").text(), $("#GroupName").text(),listofUser );
    }

</script>
</head>
<body>
         <%--   <div class="row">
    <div class="col-sm-4" style="background-color:lavender;">.col-sm-4</div>
    <div class="col-sm-4" style="background-color:lavenderblush;">.col-sm-4</div>
    <div class="col-sm-4" style="background-color:lavender;">.col-sm-4</div>
    </div>--%>
    <form id="form1" runat="server">
        <div>
        </div>
        <uc1:ctlChatBox ID="ctlChatBox1" runat="server" />
    </form>
    <div class="container">

  <%--<h2>Modal Example</h2>--%>
  <!-- Trigger the modal with a button -->
  <%--<button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal">Open Modal</button>--%>

  <!-- Modal -->
  <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Create Group</h4>
        </div>
        <div class="modal-body text-center" >
             
         <div>
                                        <input type="text" id="group_id" />
                                    </div>
                                    <div class="form-group">
                                        <select class="custom-select" id="select_users" multiple="multiple">
                                            
                                              <option value="1">Ravi</option>
                                              <option value="2">Nikhil</option>
                                              <option value="3">Rupesh</option>
                                            <option value="4">Avinash</option>
                                            <option value="5">Satya</option>
                                            <option value="6">Raja</option>
                                            </select>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator" ValidationGroup="valgrp" ControlToValidate="ddlUsers" InitialValue="0" runat="server" ForeColor="Red" Display="Dynamic" ErrorMessage="Please Select User."></asp:RequiredFieldValidator>--%>
                                    </div>
        
                 </div>
        <div class="modal-footer">
          <button type="button" id="create_group_btn" class="btn btn-default" data-dismiss="modal" onclick="addGroup()">Create</button>
        </div>
      </div>
      
    </div>
  </div>

  <div class="modal fade" id="myModal_new" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Join Group</h4>
        </div>
        <div class="modal-body text-center" >
            <div class="form-group">
                <select class="custom-select" id="join_groups">
                    <option value="0">SelectGroup</option>
                    

                </select>

            </div>
        </div>
        <div class="modal-footer">
          <button type="button" id="join_group_btn" class="btn btn-default" data-dismiss="modal" onclick="joinGroup()">Join</button>
        </div>

        
</div>
    </div>
  </div>

           
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
            <%--<div style="float: left; width: 20%; padding: 4px">
                <input type="text" style="width: 100%" id="txtTo" />
            </div>--%>
            <div style="float: left; width: 60%; padding: 4px">
                <input type="text" style="width: 100%" id="txtMsg" />
            </div>
        <div style="float: right; width: 15%; padding: 4px">
                <button id="btnSend" onclick="sendtoGroup()" >Send Message</button>
        </div>
       </div>
    </div>
  </div>

    <div id="demo">
        
    </div>
    <%--<div  id= "groups" class="sidenav text-center" style="height: 580px; width: 200px; overflow: auto">
       <%-- <button type="button" class="btn btn-info btn-sm " data-toggle="modal" data-target="#myModal">Create Group</button>
        <button type="button" class="btn btn-info btn-sm " data-toggle="modal" data-target="#myModal_new">Join Group</button>
        <div class="mydiv" style="cursor: pointer;">

        </div>--%>
  
  
</div>

</body>
</html>
