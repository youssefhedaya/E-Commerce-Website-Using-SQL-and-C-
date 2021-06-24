using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
       
        }

        protected void Buttonlogin_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            //userLogin
            SqlCommand cmd = new SqlCommand("userLogin", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            string username = TextBoxusername.Text;
            string password = TextBoxpassword.Text;
            cmd.Parameters.Add(new SqlParameter("@username", username));
            cmd.Parameters.Add(new SqlParameter("@password", password));


            SqlParameter success = cmd.Parameters.Add("@success", SqlDbType.Int);
            success.Direction = ParameterDirection.Output;
            SqlParameter type1 = cmd.Parameters.Add("@type", SqlDbType.Int);
            type1.Direction = ParameterDirection.Output;

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            string type = type1.Value.ToString();
            if (success.Value.ToString().Equals("1"))
            {
              //  Response.Write(success);
                //To send response data to the client side (HTML)
              //  Response.Write("SUCCESS");

                /*ASP.NET session state enables you to store and retrieve values for a user
                as the user navigates ASP.NET pages in a Web application.
                This is how we store a value in the session*/
                Session["username"] = username;

                //To navigate to another webpage
                if(type == "0")
               Response.Redirect("customerView.aspx", true);
               else if(type == "1")
                    Response.Redirect("Vendor2.aspx", true);
            }
            else
            {
               // Response.Write(success.Value);   
                Response.Write("WRONG USERNAME OR PASSWORD");
            }


        }

        protected void redirectRegister_Click(object sender, EventArgs e)
        {

            Response.Redirect("customerVendorRegister.aspx", true);

        }

       
    }
}