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
    public partial class creditcardView : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void creditcard_Click(object sender, EventArgs e)
        {

            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand cmd = new SqlCommand("ChooseCreditCard", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            int Ordernumber = Convert.ToInt32(Session["OrderID"].ToString());
            string cc = ccnumber.Text;
            string customer = Session["username"].ToString();

            cmd.Parameters.Add(new SqlParameter("@creditcard", cc));
            cmd.Parameters.Add(new SqlParameter("@orderID", Ordernumber));
            cmd.Parameters.Add(new SqlParameter("@customername", customer));
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

        }
    }
}