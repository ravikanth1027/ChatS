using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SignalRPrivateChat.ChatHelper
{
    public class ImageMessage
    {
        public byte[] ImageBinary { get; set; }
        public string ImageHeaders { get; set; }
    }
}