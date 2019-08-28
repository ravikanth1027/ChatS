using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SignalRPrivateChat.controls
{
    public partial class ctlChatBox : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null || Session["UserId"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }else
            {
                hdnCurrentUserName.Value = Session["UserName"].ToString();
                hdnCurrentUserID.Value = Session["UserId"].ToString();
            }
        }
    }
}