using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SignalRPrivateChat.ChatHelper
{
    public class GroupDetails
    {
        private List<UserDetail> _groupMembers;

        public int GroupConnectionID { get; set; }
        public string GroupName { get; set; }
        public List<UserDetail> GroupMembers { get => _groupMembers; set => _groupMembers = value; }
    }
}