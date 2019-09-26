using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SignalRPrivateChat.Controllers
{
    public class UploadController : Controller
    {
        // GET: Upload
        public ActionResult Index()
        {
            return Json("Hello WOrld");
            //return View();
        }

        [HttpPost]
        [Route("Upload/UploadFiles")]
        public ActionResult UploadFiles(IEnumerable<HttpPostedFileBase> files)
        {
            foreach (HttpPostedFileBase file in files)
            {
                
            }
            return Json("All files have been successfully stored.");
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

            //            HttpPostedFileBase file = files[i];
            //            string fname;

            //            // Checking for Internet Explorer  
            //            if (Request.Browser.Browser.ToUpper() == "IE" || Request.Browser.Browser.ToUpper() == "INTERNETEXPLORER")
            //            {
            //                string[] testfiles = file.FileName.Split(new char[] { '\\' });
            //                fname = testfiles[testfiles.Length - 1];
            //            }
            //            else
            //            {
            //                fname = file.FileName;
            //            }

            //            // Get the complete folder path and store the file inside it.  
            //            fname = Path.Combine(Server.MapPath("~/Uploads/"), fname);
            //            file.SaveAs(fname);
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