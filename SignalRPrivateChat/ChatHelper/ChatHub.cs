﻿using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace SignalRPrivateChat.ChatHelper
{
    [HubName("chatHub")]
    public class ChatHub : Hub
    {
        #region---Data Members---
        static List<UserDetail> ConnectedUsers = new List<UserDetail>();
        static List<MessageDetail> CurrentMessage = new List<MessageDetail>();
        static List<GroupDetails> GroupMessages = new List<GroupDetails>();
        Dictionary<string, List<String>> UserCreatedGroups = new Dictionary<string, List<String>>();
        #endregion

        #region---Methods---

        public void Connect(string UserName, int UserID)
        {
            var id = Context.ConnectionId;

            if (ConnectedUsers.Count(x => x.ConnectionId == id) == 0)
            {
                ConnectedUsers.Add(new UserDetail { ConnectionId = id, UserName = UserName + "-" + UserID, UserID = UserID });
            }
            UserDetail CurrentUser = ConnectedUsers.Where(u => u.ConnectionId == id).FirstOrDefault();

            // send to caller           
            Clients.Caller.onConnected(CurrentUser.UserID.ToString(), CurrentUser.UserName, ConnectedUsers, CurrentMessage, CurrentUser.UserID);
            // send to all except caller client           
            Clients.AllExcept(CurrentUser.ConnectionId).onNewUserConnected(CurrentUser.UserID.ToString(), CurrentUser.UserName, CurrentUser.UserID);

            
        }

        [HubMethodName("sendmessagetoall")]
        public void SendMessageToAll(string userName, string message)
        {
            // store last 100 messages in cache
            //AddMessageinCache(userName, message);

            // Broad cast message
            Clients.All.messageReceived(userName, message);
        }


        [HubMethodName("groupconnect")]
        public void Group_Connect(String username, String userid, String connectionid, String GroupName)
        {
            string count = "NA";
            string msg = "Welcome to group " + GroupName;
            string list = "";

            var id = Context.ConnectionId;
            //this will add the connected user to particular group
            Groups.Add(id, GroupName);

            string[] Exceptional = new string[1];
            Exceptional[0] = id;

            Clients.Caller.receiveMessage("Group Chat Hub", msg, list);
            Clients.OthersInGroup(GroupName).receiveMessage("NewConnection", GroupName + " " + username + " " + id, count);
           //Clients.AllExcept(Exceptional).receiveMessage("NewConnection", username + " " + id, count);
            

        }


        public void SendPrivateMessage(string toUserId, string message)
        {
            try
            {
                string fromconnectionid = Context.ConnectionId;
                string strfromUserId = (ConnectedUsers.Where(u => u.ConnectionId == Context.ConnectionId).Select(u => u.UserID).FirstOrDefault()).ToString();
                int _fromUserId = 0;
                int.TryParse(strfromUserId, out _fromUserId);
                int _toUserId = 0;
                int.TryParse(toUserId, out _toUserId);
                List<UserDetail> FromUsers = ConnectedUsers.Where(u => u.UserID == _fromUserId).ToList();
                List<UserDetail> ToUsers = ConnectedUsers.Where(x => x.UserID == _toUserId).ToList();

                if (FromUsers.Count != 0 && ToUsers.Count() != 0)
                {
                    foreach (var ToUser in ToUsers)
                    {
                        // send to                                                                                            //Chat Title
                        Clients.Client(ToUser.ConnectionId).sendPrivateMessage(_fromUserId.ToString(), FromUsers[0].UserName, FromUsers[0].UserName, message);
                    }


                    foreach (var FromUser in FromUsers)
                    {
                        // send to caller user                                                                                //Chat Title
                        Clients.Client(FromUser.ConnectionId).sendPrivateMessage(_toUserId.ToString(), FromUsers[0].UserName, ToUsers[0].UserName, message);
                    }
                    // send to caller user
                    //Clients.Caller.sendPrivateMessage(_toUserId.ToString(), FromUsers[0].UserName, message);
                    //ChatDB.Instance.SaveChatHistory(_fromUserId, _toUserId, message);
                    MessageDetail _MessageDeail = new MessageDetail { FromUserID = _fromUserId, FromUserName = FromUsers[0].UserName, ToUserID = _toUserId, ToUserName = ToUsers[0].UserName, Message = message };
                    AddMessageinCache(_MessageDeail);
                }
            }
            catch { }
        }

        public void RequestLastMessage(int FromUserID, int ToUserID)
        {
            List<MessageDetail> CurrentChatMessages = (from u in CurrentMessage where ((u.FromUserID == FromUserID && u.ToUserID == ToUserID) || (u.FromUserID == ToUserID && u.ToUserID == FromUserID)) select u).ToList();
            //send to caller user
            Clients.Caller.GetLastMessages(ToUserID, CurrentChatMessages);
        }

        [HubMethodName("RequestLastGroupMessage")]
        public void RequestLastGroupMessage(int FromUserID, string ToUserID)
        {
            List<string> GroupNameList = ToUserID.Split('_').ToList<string>();
            List<GroupDetails> CurrentChatMessages = (from u in GroupMessages where ((u.GName == GroupNameList[1])) select u).ToList();
            //send to caller user
            Clients.Caller.GetGroupLastMessages(ToUserID, CurrentChatMessages);
        }
        public void SendUserTypingRequest(string toUserId)
        {
            string strfromUserId = (ConnectedUsers.Where(u => u.ConnectionId == Context.ConnectionId).Select(u => u.UserID).FirstOrDefault()).ToString();

            int _toUserId = 0;
            int.TryParse(toUserId, out _toUserId);
            List<UserDetail> ToUsers = ConnectedUsers.Where(x => x.UserID == _toUserId).ToList();

            foreach (var ToUser in ToUsers)
            {
                // send to                                                                                            
                Clients.Client(ToUser.ConnectionId).ReceiveTypingRequest(strfromUserId);
            }
        }

        public override System.Threading.Tasks.Task OnDisconnected(bool stopCalled)
        {
            var item = ConnectedUsers.FirstOrDefault(x => x.ConnectionId == Context.ConnectionId);
            if (item != null)
            {
                ConnectedUsers.Remove(item);
                if (ConnectedUsers.Where(u => u.UserID == item.UserID).Count() == 0)
                {
                    var id = item.UserID.ToString();
                    Clients.All.onUserDisconnected(id, item.UserName);
                }
            }
            return base.OnDisconnected(stopCalled);
        }

        [HubMethodName("addgroupserver")]
        public void Add_to_Group(String username, String userid, String connectionid, String GroupName, List<String> listofUsers)
        {
            string count = "NA";
            string msg = "Welcome to group " + GroupName;
            string list = "";

            var id = Context.ConnectionId;
            //this will add the connected user to particular group
            Groups.Add(id, GroupName);

            string[] Exceptional = new string[1];
            Exceptional[0] = id;

            Clients.Caller.receiveMessage("Group Chat Hub", msg, list);
            Clients.OthersInGroup(GroupName).receiveMessage("NewConnection", GroupName + " " + username + " " + id, count);
            //Clients.AllExcept(Exceptional).receiveMessage("NewConnection", username + " " +GroupName + id, count);
            var GroupId = GroupName;
            string fromconnectionid = Context.ConnectionId;
                string strfromUserId = (ConnectedUsers.Where(u => u.ConnectionId == Context.ConnectionId).Select(u => u.UserID).FirstOrDefault()).ToString();
                int _fromUserId = 0;
                int.TryParse(strfromUserId, out _fromUserId);
                int _toUserId = 0;
                List<UserDetail> FromUsers = ConnectedUsers.Where(u => u.UserID == _fromUserId).ToList();
            
            foreach (var toUserId in listofUsers)
            {
                int.TryParse(toUserId, out _toUserId);
                List<UserDetail> ToUsers = ConnectedUsers.Where(x => x.UserID == _toUserId).ToList();
                if (FromUsers.Count != 0 && ToUsers.Count() != 0)
                {
                    foreach (var ToUser in ToUsers)
                    {
                        // send to                                           
                        //Chat Title
                        Groups.Add(ToUser.ConnectionId, GroupName); // Just Checking - Working but client 2 cnnot send back since groupname is not available so add it as chat window
                        Clients.Client(ToUser.ConnectionId).samplemessage(_fromUserId.ToString(), FromUsers[0].UserName, FromUsers[0].UserName, "group_"+GroupName, GroupId, "You have been added to this group");
                    }
                }

            }
                
                
                
           
            }
       
        [HubMethodName("sendgroupmessage")]
        public void SendGroupMessage(string toGroupId, string message)
        {


            Groups.Add(Context.ConnectionId, "private_1");
            //Clients.Client(ToUser.ConnectionId).sendPrivateMessage(_fromUserId.ToString(), FromUsers[0].UserName, FromUsers[0].UserName, message);
            //Clients.All.addMessage("You have been added to group - " + toGroupId);
            //try
            //{
            //    string fromconnectionid = Context.ConnectionId;
            //    string strfromUserId = (ConnectedUsers.Where(u => u.ConnectionId == Context.ConnectionId).Select(u => u.UserID).FirstOrDefault()).ToString();
            //    int _fromUserId = 0;
            //    int.TryParse(strfromUserId, out _fromUserId);
            //    int _toUserId = 0;
            //    int.TryParse(toUserId, out _toUserId);
            //    List<UserDetail> FromUsers = ConnectedUsers.Where(u => u.UserID == _fromUserId).ToList();
            //    List<UserDetail> ToUsers = ConnectedUsers.Where(x => x.UserID == _toUserId).ToList();

            //    if (FromUsers.Count != 0 && ToUsers.Count() != 0)
            //    {
            //        foreach (var ToUser in ToUsers)
            //        {
            //            // send to                                                                                            //Chat Title
            //            Clients.Client(ToUser.ConnectionId).sendPrivateMessage(_fromUserId.ToString(), FromUsers[0].UserName, FromUsers[0].UserName, message);
            //        }


            //        foreach (var FromUser in FromUsers)
            //        {
            //            // send to caller user                                                                                //Chat Title
            //            Clients.Client(FromUser.ConnectionId).sendPrivateMessage(_toUserId.ToString(), FromUsers[0].UserName, ToUsers[0].UserName, message);
            //        }
            //        // send to caller user
            //        //Clients.Caller.sendPrivateMessage(_toUserId.ToString(), FromUsers[0].UserName, message);
            //        //ChatDB.Instance.SaveChatHistory(_fromUserId, _toUserId, message);
            //        MessageDetail _MessageDeail = new MessageDetail { FromUserID = _fromUserId, FromUserName = FromUsers[0].UserName, ToUserID = _toUserId, ToUserName = ToUsers[0].UserName, Message = message };
            //        AddMessageinCache(_MessageDeail);
            //    }
            //}
            //catch { }
        }
        #endregion

        #region---private Messages---
        private void AddMessageinCache(MessageDetail _MessageDetail)
        {
            CurrentMessage.Add(_MessageDetail);
            if (CurrentMessage.Count > 100)
                CurrentMessage.RemoveAt(0);
        }

        private void AddGroupMessageinCache(GroupDetails _GroupDetails)
        {
            GroupMessages.Add(_GroupDetails);
            if (GroupMessages.Count > 100)
                GroupMessages.RemoveAt(0);
        }
        #endregion

        //public Task SendMessageToGroup(string groupName, string message)
        //{
        //    return Clients.Group(groupName).SendAsync("Send", $"{Context.ConnectionId}: {message}");
        //}



        public void Send(string message)
        {
            // Call the addMessage method on all clients            
            Clients.All.addMessage(message);
            Clients.Group("RoomA").addMessage("Group Message " + message);
            
        }

        public Task ImageMessage(ImageMessage file)
        {
            return Clients.All.SendAsync("ImageMessage", file);
        }

        public void sendPrivateFile(string toUserId, string message)
        {
            try
            {
                string fromconnectionid = Context.ConnectionId;
                string strfromUserId = (ConnectedUsers.Where(u => u.ConnectionId == Context.ConnectionId).Select(u => u.UserID).FirstOrDefault()).ToString();
                int _fromUserId = 0;
                int.TryParse(strfromUserId, out _fromUserId);
                int _toUserId = 0;
                int.TryParse(toUserId, out _toUserId);
                List<UserDetail> FromUsers = ConnectedUsers.Where(u => u.UserID == _fromUserId).ToList();
                List<UserDetail> ToUsers = ConnectedUsers.Where(x => x.UserID == _toUserId).ToList();

                if (FromUsers.Count != 0 && ToUsers.Count() != 0)
                {
                    foreach (var ToUser in ToUsers)
                    {
                        // send to                                                                                            //Chat Title
                        Clients.Client(ToUser.ConnectionId).sendPrivateFile(_fromUserId.ToString(), FromUsers[0].UserName, FromUsers[0].UserName, message);
                    }


                    foreach (var FromUser in FromUsers)
                    {
                        // send to caller user                                                                                //Chat Title
                        Clients.Client(FromUser.ConnectionId).sendPrivateFile(_toUserId.ToString(), FromUsers[0].UserName, ToUsers[0].UserName, message);
                    }
                    // send to caller user
                    //Clients.Caller.sendPrivateMessage(_toUserId.ToString(), FromUsers[0].UserName, message);
                    //ChatDB.Instance.SaveChatHistory(_fromUserId, _toUserId, message);
                    MessageDetail _MessageDeail = new MessageDetail { FromUserID = _fromUserId, FromUserName = FromUsers[0].UserName, ToUserID = _toUserId, ToUserName = ToUsers[0].UserName, Message = message };
                    AddMessageinCache(_MessageDeail);
                }
            }
            catch { }
        }

        public void BroadCastMessage(String msgFrom, String msg, String GroupName)
        {
            var id = Context.ConnectionId;
            string[] Exceptional = new string[0];
            
            Clients.Group(GroupName).sendGroupMessage(GroupName, GroupName, msg, msgFrom);
            GroupDetails _GroupDetail = new GroupDetails { GName = GroupName, sender = msgFrom, txt = msg };
            //FromUserID = _fromUserId, FromUserName = FromUsers[0].UserName, ToUserID = _toUserId, ToUserName = ToUsers[0].UserName, Message = message };
            AddGroupMessageinCache(_GroupDetail);

        }

    }
}