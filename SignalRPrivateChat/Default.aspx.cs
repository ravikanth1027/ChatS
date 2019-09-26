using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SignalRPrivateChat
{
    public partial class Default : System.Web.UI.Page
    {
        protected string testVar;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Session["UserName"] = ddlUsers.SelectedItem.Text;
            Session["UserId"] = ddlUsers.SelectedValue;
            Response.Redirect("~/StartChat.aspx");
            //Response.Redirect("~/GroupChat.aspx");
        }

        public void UploadFiles(IEnumerable<HttpPostedFileBase> files)
        {
            string globalName="Helo";
            foreach (HttpPostedFileBase file in files)
            {
                //HttpPostedFileBase file = files[i];
                try
                {
                    string filename;

                    // Checking for Internet Explorer  
                    if (Request.Browser.Browser.ToUpper() == "IE" || Request.Browser.Browser.ToUpper() == "INTERNETEXPLORER")
                    {
                        string[] testfiles = file.FileName.Split(new char[] { '\\' });
                        filename = testfiles[testfiles.Length - 1];
                    }
                    else
                    {
                        //TextWriter writer = File.CreateText("C:\\Users\\hp\\Desktop\\f.txt");
                        filename = Path.GetFileName(file.FileName);
                        //fname = file.FileName;
                        //Console.WriteLine("Data written successfully...");
                    }

                    // Get the complete folder path and store the file inside it.  
                    //fname = Path.Combine(Server.MapPath("~/Uploads/"), fname);
                    //fname = Path.Combine(Server.MapPath("~/App_Data/"), fname);
                        //Path.Combine(Server.MapPath("C: /Users/hp/Downloads/SignalR -private-one-to-one-chat-master/SignalR-private-one-to-one-chat-master/SignalRPrivateChat/SignalRPrivateChat/Uploads"), fname); 
                      file.SaveAs(Server.MapPath("~/")+filename);
                    
                    
                }
                catch (Exception ex)
                {
                    Response.Write(ex.Message);
                }
            }

            Debug.WriteLine("Inside Docs"+globalName);
            // Checking no of files injected in Request object  
            //if (Request.Files.Count > 0)
            //{
            //    try
            //    {
            //        //  Get all files from Request object  
            //        HttpFileCollectionBase files = Request.Files;
            //        for (int i = 0; i < files.Count; i++)
            //        {
            //            //string path = AppDomain.CurrentDomain.BaseDirectory + "Uploads/";  
            //            //string filename = Path.GetFileName(Request.Files[i].FileName);  


            //        }
            //        // Returns message that successfully uploaded  
            //        return Json("File Uploaded Successfully!");
            //    }
            //    catch (Exception ex)
            //    {
            //        return Json("Error occurred. Error details: " + ex.Message);
            //    }
            //}
            //else
            //{
            //    return Json("No files selected.");
            //}
        }
    }
}