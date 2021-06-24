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
    public partial class addCCView : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void TextBoxCVV_TextChanged(object sender, EventArgs e)
        {

        }

        protected void ButtonADD_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand cmd = new SqlCommand("AddCreditCard", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            string number = TextBoxNumber.Text;
            string expiry1 = TextBoxexpiry.Text;
            string cvv = TextBoxCVV.Text;

            DateTime expiry = Convert.ToDateTime(expiry1);

            string username = Session["username"].ToString();
            Response.Write(username);

            cmd.Parameters.Add(new SqlParameter("@creditcardnumber", number));
            cmd.Parameters.Add(new SqlParameter("@expirydate", expiry));
            cmd.Parameters.Add(new SqlParameter("@cvv", cvv));
            cmd.Parameters.Add(new SqlParameter("@customername", username));





            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
        }
    }
}